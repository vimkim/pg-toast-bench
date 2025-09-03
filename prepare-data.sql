CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 임의 텍스트 생성기 (비압축성)
CREATE OR REPLACE FUNCTION gen_rand_text(n int)
RETURNS text LANGUAGE sql AS $$
  SELECT substring(encode(gen_random_bytes(n), 'hex') FROM 1 FOR n)
$$;

-- 데이터가 없다면 채우기 (행 수/길이는 필요에 맞게 조정)
INSERT INTO s.t_plain  (payload) SELECT gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_main   (payload) SELECT gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_ext    (payload) SELECT gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_extd   (payload) SELECT gen_rand_text(3000)   FROM generate_series(1,200000) ON CONFLICT DO NOTHING;

INSERT INTO s.t_big_ext  (payload) SELECT gen_rand_text(131072) FROM generate_series(1,20000) ON CONFLICT DO NOTHING;
INSERT INTO s.t_big_extd (payload) SELECT gen_rand_text(131072) FROM generate_series(1,20000) ON CONFLICT DO NOTHING;

VACUUM ANALYZE s.t_plain; VACUUM ANALYZE s.t_main;
VACUUM ANALYZE s.t_ext;   VACUUM ANALYZE s.t_extd;
VACUUM ANALYZE s.t_big_ext; VACUUM ANALYZE s.t_big_extd;
