\set ON_ERROR_STOP on
\timing on

-- Keep apples-to-apples: no parallel or index scans
SET track_io_timing = on;
SET max_parallel_workers_per_gather = 0;
SET enable_indexscan = off;
SET enable_bitmapscan = off;
SET enable_parallel_append = off;
SET enable_parallel_hash = off;

-- Optional: uncomment to warm cache a bit
CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm('s.t_plain'::regclass);
SELECT pg_prewarm('s.t_main'::regclass);
SELECT pg_prewarm('s.t_ext'::regclass);
SELECT pg_prewarm('s.t_extd'::regclass);

\echo '=== s.t_plain: no-detoast (COUNT) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT count(*) FROM s.t_plain;

\echo '=== s.t_plain: detoast (SUM(octet_length)) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT sum(octet_length(payload)) FROM s.t_plain;

\echo '=== s.t_main: no-detoast (COUNT) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT count(*) FROM s.t_main;

\echo '=== s.t_main: detoast (SUM(octet_length)) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT sum(octet_length(payload)) FROM s.t_main;

\echo '=== s.t_ext: no-detoast (COUNT) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT count(*) FROM s.t_ext;

\echo '=== s.t_ext: detoast (SUM(octet_length)) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT sum(octet_length(payload)) FROM s.t_ext;

\echo '=== s.t_extd: no-detoast (COUNT) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT count(*) FROM s.t_extd;

\echo '=== s.t_extd: detoast (SUM(octet_length)) ==='
EXPLAIN (ANALYZE, BUFFERS, TIMING, SUMMARY) SELECT sum(octet_length(payload)) FROM s.t_extd;

