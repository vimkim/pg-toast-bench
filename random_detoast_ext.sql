\timing on
-- Force indexed lookups + random access
SET track_io_timing = on;
SET max_parallel_workers_per_gather = 0;
SET enable_seqscan = off;       -- prefer index scans
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SET enable_hashjoin = off;      -- push to nested loops
SET enable_mergejoin = off;

-- configurable sample size (default 5000)
\if :{?sample_n}
\else
\set sample_n 5000
\endif

-- Random ids without touching table data
CREATE TEMP TABLE tmp_ids AS
WITH bounds AS (SELECT max(id) AS max_id FROM s.t_ext)
SELECT (1 + floor(random() * max_id))::bigint AS id
FROM bounds, generate_series(1, :sample_n);

CREATE INDEX ON tmp_ids(id);
ANALYZE tmp_ids;

-- TOASTed payload: random heap + random toast fetches (expensive cold)
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY)
SELECT sum(length(convert_to(e.payload, 'UTF8')::bytea))
FROM tmp_ids i
JOIN s.t_ext e USING (id);

DROP TABLE tmp_ids;

