\timing on
SET track_io_timing = on;
SET max_parallel_workers_per_gather = 0;

-- Force nested loops; keep base-table index scans; allow seqscan for temp table
SET enable_hashjoin = off;
SET enable_mergejoin = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SET enable_seqscan = on;
SET random_page_cost = 4;   -- discourage seq scans
SET effective_io_concurrency = 1;  -- minimal readahead on spinning disk; might not matter on NVMe


-- configurable sample size (default 50000)
\if :{?sample_n}
\else
\set sample_n 50000
\endif

-- Random ids; no index; preserve insertion (random) order, then re-shuffle to defeat any correlation
CREATE TEMP TABLE tmp_ids AS
WITH bounds AS (SELECT max(id) AS max_id FROM s.t_plain)
SELECT (1 + floor(random() * max_id))::bigint AS id
FROM bounds, generate_series(1, :sample_n);

ANALYZE tmp_ids;

EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY)
SELECT sum(length(convert_to(p.payload, 'UTF8')::bytea))
FROM (SELECT id FROM tmp_ids ORDER BY random()) i   -- shuffle driving order
JOIN s.t_plain p USING (id);

DROP TABLE tmp_ids;
