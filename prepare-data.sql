-- Fail fast in psql so you catch the first error
-- \set ON_ERROR_STOP on

CREATE SCHEMA IF NOT EXISTS s;

CREATE OR REPLACE FUNCTION s.gen_rand_text(n integer)
RETURNS text
LANGUAGE sql
AS $$
  SELECT string_agg(chr(32 + (random()*95)::int), '')
  FROM generate_series(1, n)
$$;

-- Fill data (explicitly call s.gen_rand_text to avoid search_path issues)
INSERT INTO s.t_plain  (payload) SELECT s.gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_main   (payload) SELECT s.gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_ext    (payload) SELECT s.gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_extd   (payload) SELECT s.gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;

-- 128 KiB payloads
INSERT INTO s.t_big_ext  (payload) SELECT s.gen_rand_text(131072) FROM generate_series(1,20000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_big_extd (payload) SELECT s.gen_rand_text(131072) FROM generate_series(1,20000) ON CONFLICT DO NOTHING;

VACUUM ANALYZE s.t_plain;
VACUUM ANALYZE s.t_main;
VACUUM ANALYZE s.t_ext;
VACUUM ANALYZE s.t_extd;
VACUUM ANALYZE s.t_big_ext;
VACUUM ANALYZE s.t_big_extd;
