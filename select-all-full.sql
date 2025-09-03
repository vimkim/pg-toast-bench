\set idwin 10000        -- 한 번에 읽을 행 수 (창 크기)
\set idmin 1
\set idmax 200000
\setrandom base :idmin :idmax
\set hi (:base)
\set lo (:hi - :idwin + 1)
\if :lo < 1
  \set lo 1
\endif

-- 인덱스 영향 최소화를 위해 순차스캔 유도 (원치 않으면 주석)
SET LOCAL enable_indexscan = off;
SET LOCAL enable_bitmapscan = off;

-- 모두 SELECT * (전컬럼 송신/디컴프/디토스트 유발)
SELECT * FROM s.t_plain  WHERE id BETWEEN :lo AND :hi;
SELECT * FROM s.t_main   WHERE id BETWEEN :lo AND :hi;
SELECT * FROM s.t_ext    WHERE id BETWEEN :lo AND :hi;
SELECT * FROM s.t_extd   WHERE id BETWEEN :lo AND :hi;

