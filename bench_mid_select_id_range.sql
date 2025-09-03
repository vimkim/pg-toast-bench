\set win 10000
\set lo  random(1, 200000 - :win + 1)
\set hi  :lo + :win - 1

-- Force sequential scan (we want heap width & page density effects)
SET LOCAL enable_indexscan = off;
SET LOCAL enable_bitmapscan = off;

-- All queries are SELECT id only
SELECT /*mid-id-plain-range*/  id FROM s.t_plain  WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-id-main-range*/   id FROM s.t_main   WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-id-ext-range*/    id FROM s.t_ext    WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-id-extd-range*/   id FROM s.t_extd   WHERE id BETWEEN :lo AND :hi;

