CREATE SCHEMA s;

-- 중간 크기 텍스트(3KB) 대상: PLAIN, MAIN, EXTERNAL, EXTENDED
CREATE TABLE s.t_plain   (id bigserial PRIMARY KEY, payload text);
CREATE TABLE s.t_main    (id bigserial PRIMARY KEY, payload text);
CREATE TABLE s.t_ext     (id bigserial PRIMARY KEY, payload text);
CREATE TABLE s.t_extd    (id bigserial PRIMARY KEY, payload text);



ALTER TABLE s.t_plain  ALTER COLUMN payload SET STORAGE PLAIN;
ALTER TABLE s.t_main   ALTER COLUMN payload SET STORAGE MAIN;
ALTER TABLE s.t_ext    ALTER COLUMN payload SET STORAGE EXTERNAL;
ALTER TABLE s.t_extd   ALTER COLUMN payload SET STORAGE EXTENDED;



-- 대형 텍스트(128KB) 대상: EXTERNAL vs EXTENDED만 (PLAIN 제외)
CREATE TABLE s.t_big_ext  (id bigserial PRIMARY KEY, payload text);
CREATE TABLE s.t_big_extd (id bigserial PRIMARY KEY, payload text);
ALTER TABLE s.t_big_ext  ALTER COLUMN payload SET STORAGE EXTERNAL;
ALTER TABLE s.t_big_extd ALTER COLUMN payload SET STORAGE EXTENDED;
