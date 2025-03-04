-- ------------------------------
-- 1절 테이블 만들기
-- ------------------------------

CREATE DATABASE naver_db; -- db 생성

CREATE TABLE sample_table (num INT); -- 테이블 생성

DROP DATABASE IF EXISTS naver_db;
CREATE DATABASE naver_db;

USE naver_db;
DROP TABLE IF EXISTS member;  -- 기존에 있으면 삭제
CREATE TABLE member -- 회원 테이블
( mem_id        CHAR(8), -- 회원 아이디(PK)
  mem_name      VARCHAR(10), -- 이름
  mem_number    TINYINT,  -- 인원수
  addr          CHAR(2), -- 주소(경기,서울,경남 식으로 2글자만입력)
  phone1        CHAR(3), -- 연락처의 국번(02, 031, 055 등)
  phone2        CHAR(8), -- 연락처의 나머지 전화번호(하이픈제외)
  height        TINYINT UNSIGNED,  -- 평균 키
  debut_date    DATE  -- 데뷔 일자
);

DROP TABLE IF EXISTS member;  -- 기존에 있으면 삭제
CREATE TABLE member -- 회원 테이블
( mem_id        CHAR(8) NOT NULL, -- NOT NULL 지정!!
  mem_name      VARCHAR(10) NOT NULL, 
  mem_number    TINYINT NOT NULL, 
  addr          CHAR(2) NOT NULL,
  phone1        CHAR(3) NULL,
  phone2        CHAR(8) NULL,
  height        TINYINT UNSIGNED NULL, 
  debut_date    DATE NULL
);

DROP TABLE IF EXISTS member;  -- 기존에 있으면 삭제
CREATE TABLE member -- 회원 테이블
( mem_id        CHAR(8) NOT NULL PRIMARY KEY, -- 기본 키 추가
  mem_name      VARCHAR(10) NOT NULL, 
  mem_number    TINYINT NOT NULL, 
  addr          CHAR(2) NOT NULL,
  phone1        CHAR(3) NULL,
  phone2        CHAR(8) NULL,
  height        TINYINT UNSIGNED NULL, 
  debut_date    DATE NULL
);

DROP TABLE IF EXISTS buy;  -- 기존에 있으면 삭제
CREATE TABLE buy -- 구매 테이블
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- AUTO_INCREMENT를 지정하면 무조건 UNIQUE나 PRIMARY KEY로 이용해야함.
   mem_id      CHAR(8) NOT NULL, -- 아이디(FK)
   prod_name     CHAR(6) NOT NULL, --  제품이름
   group_name     CHAR(4) NULL , -- 분류
   price         INT UNSIGNED NOT NULL, -- 가격
   amount        SMALLINT UNSIGNED  NOT NULL -- 수량
);

DROP TABLE IF EXISTS buy;  -- 기존에 있으면 삭제
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   group_name     CHAR(4) NULL ,
   price         INT UNSIGNED NOT NULL,
   amount        SMALLINT UNSIGNED  NOT NULL ,
   FOREIGN KEY(mem_id) REFERENCES member(mem_id) -- 외래 키 추가. mem_id가 뭔지 모르니 REFERENCES를 써줘야함.
   -- 즉, buy를 갱신하려면 일단 member 안에 mem_id가 있어야 한다.(구매 전 회원가입 필수)
);

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-8-8');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-1-15');

INSERT INTO buy VALUES( NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES( NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES( NULL, 'APN', '아이폰', '디지털', 200, 1);


-- ------------------------------
-- 2절 제약 조건 이용 (기본키-외래키,NOT NULL,기본값(default),고유 키등)
-- ------------------------------
/*
MySQL의 대표적인 제약 조건
primary key 제약조건
foreign key 제약조건
unique 제약조건
check 제약조건
default 정의
null 값 허용
*/
USE naver_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, -- 기본키 나타내는 방식
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);

DESCRIBE member;

DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  PRIMARY KEY (mem_id) -- 기본키 나타내는 방식2
);

DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
ALTER TABLE member
     ADD CONSTRAINT -- 제약 추가
     PRIMARY KEY (mem_id); -- 기본키 추가


DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  CONSTRAINT PRIMARY KEY PK_member_mem_id (mem_id) -- 기본키에 이름 지어줄 수 있음. PK_member_mem_id임.
);

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   FOREIGN KEY(mem_id) REFERENCES member(mem_id) -- 외래키가 참조하는 열은 반드시 기본키나 고유키여야함.
);

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL
);
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   user_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL, 
   FOREIGN KEY(user_id) REFERENCES member(mem_id) -- FOREIGN KEY(열_이름) REFERENCES 기준_테이블(열_이름)
);

DROP TABLE IF EXISTS buy;
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL
);
ALTER TABLE buy
    ADD CONSTRAINT 
    FOREIGN KEY(mem_id) REFERENCES member(mem_id); -- 제약 추가로 외래키 지정

INSERT INTO member VALUES('BLK', '블랙핑크', 163);
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

SELECT M.mem_id, M.mem_name, B.prod_name 
   FROM buy B
      INNER JOIN member M
      ON B.mem_id = M.mem_id;
      
UPDATE member SET mem_id = 'PINK' WHERE mem_id='BLK'; -- 변경 안됨. 이 테이블을 참조하는 buy 떄문.

DELETE FROM member WHERE  mem_id='BLK'; -- 삭제도 안됨.

DROP TABLE IF EXISTS buy;
CREATE TABLE buy 
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   mem_id      CHAR(8) NOT NULL, 
   prod_name     CHAR(6) NOT NULL
);
ALTER TABLE buy
    ADD CONSTRAINT 
    FOREIGN KEY(mem_id) REFERENCES member(mem_id)
    ON UPDATE CASCADE -- 기준 테이블의 데이터가 업데이트되면 참조 테이블의 데이터도 업데이트됨.
    ON DELETE CASCADE; -- 기준 테이블의 데이터가 삭제되면 참조 테이블의 데이터도 삭제됨.
    
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

UPDATE member SET mem_id = 'PINK' WHERE mem_id='BLK'; -- 이번엔 오류 없음.

SELECT M.mem_id, M.mem_name, B.prod_name 
   FROM buy B
      INNER JOIN member M -- 내부 조인을 통해 확인 : 테이블 둘다 잘 변경됨.
      ON B.mem_id = M.mem_id;

DELETE FROM member WHERE  mem_id='PINK'; -- 삭제도 오류 없음.

SELECT * FROM buy;

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL,
  email       CHAR(30)  NULL UNIQUE -- 중복 허락 X, 그러나 NULL은 허용(primary는 안됨), 만약 NULL도 허락하고 싶지 않다면 NOT NULL을 쓴다.
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES('TWC', '트와이스', 167, NULL);
INSERT INTO member VALUES('APN', '에이핑크', 164, 'pink@gmail.com'); -- 중복 오류
SELECT * FROM member;

DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL CHECK (height >= 100), -- 체크 제약 조건 : 조건을 만족해야 삽입,변경 가능
  phone1      CHAR(3)  NULL
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES('TWC', '트와이스', 99, NULL); -- 체크 제약으로 안됨.

ALTER TABLE member
    ADD CONSTRAINT 
    CHECK  (phone1 IN ('02', '031', '032', '054', '055', '061' )) ; -- 제약 추가

INSERT INTO member VALUES('TWC', '트와이스', 167, '02');
INSERT INTO member VALUES('OMY', '오마이걸', 167, '010'); -- 위의 안에 없음. 안됨.

DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id  CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name    VARCHAR(10) NOT NULL, 
  height      TINYINT UNSIGNED NULL DEFAULT 160, -- 입력 안하면 자동으로 160으로 입력
  phone1      CHAR(3)  NULL
);

ALTER TABLE member
    ALTER COLUMN phone1 SET DEFAULT '02'; -- SET DEFAULT로 변경

INSERT INTO member VALUES('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES('SPC', '우주소녀', default, default); -- 디폴트라고 써주면 됨.
SELECT * FROM member;


-- ------------------------------
-- 3절 가상의 테이블 : 뷰(view)
-- ------------------------------
/*
뷰(View)란?
**뷰(View)**는 가상의 테이블로, 특정 SELECT 문을 저장해서 사용할 수 있는 개념입니다.

원본 테이블의 데이터를 기반으로 하지만, 물리적으로 별도의 데이터가 저장되지 않음.
새로운 테이블을 만들지 않고, 자주 사용하는 SELECT 쿼리를 미리 정의해두고 사용할 때 편리함.
예를 들어, 이런 식으로 만들 수 있음:
CREATE VIEW vip_members AS
SELECT mem_id, mem_name, height
FROM member
WHERE height >= 170;
SELECT * FROM vip_members; -- 이렇게 만든 뷰를 사용할 때는 일반 테이블처럼 조회 가능
뷰는 보안에 도움됨. 모든 정보가 필요 없기 때문임.
또한 읽기 전용이지만 뷰를 통해서 원본 테이블의 데이터를 수정할 수도 있다.
*/

USE market_db;
SELECT mem_id, mem_name, addr FROM member;

USE market_db;
CREATE VIEW v_member -- 뷰 만들기 : AS 뒤의 SELECT문으로 뷰를 지정한다.
AS
    SELECT mem_id, mem_name, addr FROM member;

SELECT * FROM v_member; -- 뷰의 모든 행열 보기

SELECT mem_name, addr FROM v_member
   WHERE addr IN ('서울', '경기');

SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, -- 또한 뷰는 복잡한 SQL을 단순하게 만들 수 있다.
        CONCAT(M.phone1, M.phone2) '연락처' 
   FROM buy B
     INNER JOIN member M
     ON B.mem_id = M.mem_id;

CREATE VIEW v_memberbuy -- 뷰를 만들고
AS
    SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, 
            CONCAT(M.phone1, M.phone2) '연락처' 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;

SELECT * FROM v_memberbuy WHERE mem_name = '블랙핑크'; -- 단순한 조건에서 볼 수 있음.

USE market_db;
CREATE VIEW v_viewtest1
AS
    SELECT B.mem_id 'Member ID', M.mem_name AS 'Member Name', -- 별칭을 통해 다른 이름을 쓸 수도 있다.
            B.prod_name "Product Name", 
            CONCAT(M.phone1, M.phone2) AS "Office Phone" 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;
         
SELECT DISTINCT `Member ID`, `Member Name` FROM v_viewtest1; -- 백틱을 사용해야함.

ALTER VIEW v_viewtest1 -- 뷰의 수정방법.
AS
    SELECT B.mem_id '회원 아이디', M.mem_name AS '회원 이름', 
            B.prod_name "제품 이름", 
            CONCAT(M.phone1, M.phone2) AS "연락처" 
       FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id;
         
SELECT  DISTINCT `회원 아이디`, `회원 이름` FROM v_viewtest1;  -- 백틱을 사용

DROP VIEW v_viewtest1; -- 뷰를 삭제하기

USE market_db;
CREATE OR REPLACE VIEW v_viewtest2 -- 뷰를 생성할때 CREATE VIEW는 같은 이름의 기존의 뷰가 있다면 오류가 나지만 CREATE OR REPLACE VIEW는 뷰가 있어도 덮어쓴다.
AS
    SELECT mem_id, mem_name, addr FROM member;

DESCRIBE v_viewtest2; -- 기존 뷰의 정보 확인.

DESCRIBE member;

SHOW CREATE VIEW v_viewtest2; -- SHOW CREATE VIEW로 뷰의 소스코드도 확인할 수 있다.

UPDATE v_member SET addr = '부산' WHERE mem_id='BLK'; -- 뷰를 통한 데이터의 수정

INSERT INTO v_member(mem_id, mem_name, addr) VALUES('BTS','방탄소년단','경기') ; -- 뷰를 통한 데이터 삽입 : 실패한다. member테이블 중 mem_number열은 NOT NULL이어야 하는데 v_member에서는 입력할 방법이 없다.

CREATE VIEW v_height167
AS
    SELECT * FROM member WHERE height >= 167 ; -- height>=167인 것만 SELECT 함.
    
SELECT * FROM v_height167 ;

DELETE FROM v_height167 WHERE height < 167; -- 아무것도 삭제 안됨.

INSERT INTO v_height167 VALUES('TRA','티아라', 6, '서울', NULL, NULL, 159, '2005-01-01') ; -- 159cm 입력해 추가는 함. 그러나..

SELECT * FROM v_height167; -- 159가 안 보임.

ALTER VIEW v_height167
AS
    SELECT * FROM member WHERE height >= 167
        WITH CHECK OPTION ; -- 뷰에 설정된 값의 범위가 벗어나는 값은 입력되지 않는다.
        
INSERT INTO v_height167 VALUES('TOB','텔레토비', 4, '영국', NULL, NULL, 140, '1995-01-01') ; -- 에러남.

CREATE VIEW v_complex -- 두 개 이상의 테이블 사용 : 복합 뷰
AS
    SELECT B.mem_id, M.mem_name, B.prod_name, M.addr
        FROM buy B
            INNER JOIN member M
            ON B.mem_id = M.mem_id;

DROP TABLE IF EXISTS buy, member; -- 뷰가 참조하는 테이블을 삭제

SELECT * FROM v_height167; -- 에러가 난다.

CHECK TABLE v_height167; -- 뷰 조회를 위해서는 CHECK TABLE을 이용한다.