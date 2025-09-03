\set win 10000
\set lo  random(1, 200000 - :win + 1)
\set hi  :lo + :win - 1

SET LOCAL enable_indexscan = off;
SET LOCAL enable_bitmapscan = off;

-- Full-row fetch triggers TOAST fetch/decompress as needed
SELECT /*mid-star-plain-range*/  * FROM s.t_plain  WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-star-main-range*/   * FROM s.t_main   WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-star-ext-range*/    * FROM s.t_ext    WHERE id BETWEEN :lo AND :hi;
SELECT /*mid-star-extd-range*/   * FROM s.t_extd   WHERE id BETWEEN :lo AND :hi;

