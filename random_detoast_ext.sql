\timing on
SET track_io_timing = on;
SET max_parallel_workers_per_gather = 0;

SET enable_hashjoin = off;
SET enable_mergejoin = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SET enable_seqscan = on;

-- configurable sample size (default 50000)
\if :{?sample_n}
\else
\set sample_n 50000
\endif

CREATE TEMP TABLE tmp_ids AS
WITH bounds AS (SELECT max(id) AS max_id FROM s.t_ext)
SELECT (1 + floor(random() * max_id))::bigint AS id
FROM bounds, generate_series(1, :sample_n);

ANALYZE tmp_ids;

EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY)
SELECT sum(length(convert_to(e.payload, 'UTF8')::bytea))
FROM (SELECT id FROM tmp_ids ORDER BY random()) i   -- shuffle driving order
JOIN s.t_ext e USING (id);

DROP TABLE tmp_ids;
