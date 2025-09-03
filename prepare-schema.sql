CREATE SCHEMA IF NOT EXISTS s;

CREATE TABLE IF NOT EXISTS s.t_plain
(
  id bigserial PRIMARY KEY,
  payload text STORAGE PLAIN
);

CREATE TABLE IF NOT EXISTS s.t_main
(
  id bigserial PRIMARY KEY,
  payload text STORAGE MAIN
);

CREATE TABLE IF NOT EXISTS s.t_ext
(
  id bigserial PRIMARY KEY,
  payload text STORAGE EXTERNAL
);

CREATE TABLE IF NOT EXISTS s.t_extd
(
  id bigserial PRIMARY KEY,
  payload text STORAGE EXTENDED
);

-- Large-text tables
CREATE TABLE IF NOT EXISTS s.t_big_ext
(
  id bigserial PRIMARY KEY,
  payload text STORAGE EXTERNAL
);

CREATE TABLE IF NOT EXISTS s.t_big_extd
(
  id bigserial PRIMARY KEY,
  payload text STORAGE EXTENDED
);
