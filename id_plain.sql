\timing on
SET track_io_timing = on;
SET max_parallel_workers_per_gather = 0;
SET enable_indexscan = off;
SET enable_bitmapscan = off;
SET enable_parallel_append = off;
SET enable_parallel_hash = off;

EXPLAIN (ANALYZE, BUFFERS, SUMMARY)
SELECT id FROM s.t_plain;

