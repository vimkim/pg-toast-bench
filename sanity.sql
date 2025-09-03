-- Per-table: heap vs toast size (and toast index)
WITH rels AS (
  SELECT c.oid, n.nspname, c.relname, c.reltoastrelid
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname='s' AND c.relkind='r'
)
SELECT relname AS tbl,
       pg_size_pretty(pg_relation_size(oid))           AS heap,
       pg_size_pretty(pg_relation_size(reltoastrelid)) AS toast,
       pg_size_pretty(pg_total_relation_size(oid))     AS total
FROM rels
ORDER BY relname;

-- Check average in-row tuple size (are rows staying inline?)
SELECT 't_plain'  AS t, avg(pg_column_size(payload)) FROM s.t_plain  UNION ALL
SELECT 't_main'   AS t, avg(pg_column_size(payload)) FROM s.t_main   UNION ALL
SELECT 't_ext'    AS t, avg(pg_column_size(payload)) FROM s.t_ext    UNION ALL
SELECT 't_extd'   AS t, avg(pg_column_size(payload)) FROM s.t_extd   UNION ALL
SELECT 't_big_ext'  AS t, avg(pg_column_size(payload)) FROM s.t_big_ext  UNION ALL
SELECT 't_big_extd' AS t, avg(pg_column_size(payload)) FROM s.t_big_extd ;

