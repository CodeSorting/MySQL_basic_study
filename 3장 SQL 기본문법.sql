-- ------------------------------
-- 1절
-- ------------------------------

USE market_db; -- db 접근

USE sys;
SELECT * FROM member;

USE market_db;
SELECT * FROM member;

SELECT * FROM market_db.member; -- db.table로 접근이 기본이다. USE를 했다면 생략 가능.

SELECT mem_name FROM member;

SELECT addr, debut_date, mem_name
	FROM member;

SELECT addr 주소, debut_date "데뷔 일자", mem_name 
	FROM member;

SELECT * FROM member WHERE mem_name = '블랙핑크';

SELECT * FROM member WHERE mem_number = 4;

SELECT mem_id, mem_name 
	FROM member 
	WHERE height <= 162;

SELECT mem_name, height, mem_number 
	FROM member 
	WHERE height >= 165 AND mem_number > 6;

SELECT mem_name, height, mem_number 
	FROM member 
	WHERE height >= 165 OR mem_number > 6;

SELECT mem_name, height 
	FROM member 
	WHERE height >= 163 AND height <= 165;

SELECT mem_name, height 
   FROM member 
   WHERE height BETWEEN 163 AND 165; -- 위와 똑같은 의미이다.
   
SELECT mem_name, addr 
   FROM member 
   WHERE addr = '경기' OR addr = '전남' OR addr = '경남';
   
SELECT mem_name, addr 
   FROM member 
   WHERE addr IN('경기', '전남', '경남'); -- 위와 똑같은 의미이다.
   
SELECT * 
   FROM member 
   WHERE mem_name LIKE '우%'; -- 우~인 단어들

SELECT * 
   FROM member 
   WHERE mem_name LIKE '__핑크';
   
SELECT height FROM member WHERE mem_name = '에이핑크';

SELECT mem_name, height FROM member WHERE height > 164;

SELECT mem_name, height FROM member
	WHERE height > (SELECT height FROM member WHERE mem_name = '에이핑크'); -- 이중으로 SELECT 쓸 수 있음.

SELECT mem_id, mem_name, debut_date 
   FROM member 
   ORDER BY debut_date; -- 기본 오름차순

SELECT mem_id, mem_name, debut_date 
   FROM member 
   ORDER BY debut_date DESC;
   
SELECT mem_id, mem_name, debut_date, height
   FROM member 
   ORDER BY height DESC
   WHERE height  >= 164;  -- 오류 발생 : WHERE 먼저 써야함.
   
SELECT mem_id, mem_name, debut_date, height
   FROM member 
   WHERE height  >= 164
   ORDER BY height DESC;
   
SELECT mem_id, mem_name, debut_date, height
   FROM member 
   WHERE height  >= 164
   ORDER BY height DESC, debut_date ASC; -- 정렬 기준 2개 사용 가능.
   
SELECT *
   FROM member 
   LIMIT 3; -- 3 행만 출력
   
SELECT mem_name, debut_date
   FROM member
   ORDER BY debut_date
   LIMIT 3;
   
SELECT mem_name, height
   FROM member
   ORDER BY height DESC
   LIMIT 3,2; -- 3번째 행부터 2개 출력
   
SELECT addr FROM member;

SELECT addr FROM member ORDER BY addr;

SELECT DISTINCT addr FROM member;

-- ------------------------------
-- 2절
-- ------------------------------

SELECT mem_id, amount FROM buy ORDER BY mem_id;

SELECT mem_id, SUM(amount) FROM buy GROUP BY mem_id;

SELECT mem_id "회원 아이디", SUM(amount) "총 구매 개수"
   FROM buy GROUP BY mem_id;


SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy GROUP BY mem_id;
   
SELECT AVG(amount) "평균 구매 개수" FROM buy;

SELECT mem_id, AVG(amount) "평균 구매 개수" 
	FROM buy
	GROUP BY mem_id;
    
SELECT COUNT(*) FROM member;

SELECT COUNT(phone1) "연락처가 있는 회원" FROM member;

SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   GROUP BY mem_id;

SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   WHERE SUM(price*amount) > 1000 
   GROUP BY mem_id;

SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   GROUP BY mem_id   
   HAVING SUM(price*amount) > 1000 ;

SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
   FROM buy 
   GROUP BY mem_id   
   HAVING SUM(price*amount) > 1000
   ORDER BY SUM(price*amount) DESC;

-- ------------------------------
-- 3절
-- ------------------------------

USE market_db;
CREATE TABLE hongong1 (toy_id  INT, toy_name CHAR(4), age INT);
INSERT INTO hongong1 VALUES (1, '우디', 25);

INSERT INTO hongong1(toy_id, toy_name) VALUES (2, '버즈');

INSERT INTO hongong1(toy_name,age, toy_id) VALUES ('제시', 20, 3);

CREATE TABLE hongong2 ( 
   toy_id  INT AUTO_INCREMENT PRIMARY KEY, -- 자동적으로 증가됨.
   toy_name CHAR(4), 
   age INT);

INSERT INTO hongong2 VALUES (NULL, '보핍', 25);
INSERT INTO hongong2 VALUES (NULL, '슬링키', 22);
INSERT INTO hongong2 VALUES (NULL, '렉스', 21);
SELECT * FROM hongong2;

SELECT LAST_INSERT_ID(); 

ALTER TABLE hongong2 AUTO_INCREMENT=100; -- 100부터 시작
INSERT INTO hongong2 VALUES (NULL, '재남', 35);
SELECT * FROM hongong2;

CREATE TABLE hongong3 ( 
   toy_id  INT AUTO_INCREMENT PRIMARY KEY, 
   toy_name CHAR(4), 
   age INT);
ALTER TABLE hongong3 AUTO_INCREMENT=1000;
SET @@auto_increment_increment=3; -- 시스템 변수를 변경한다.

INSERT INTO hongong3 VALUES (NULL, '토마스', 20); -- NULL로 넣어도 자동으로 1000,1003,1006으로 3씩 증가한다.
INSERT INTO hongong3 VALUES (NULL, '제임스', 23);
INSERT INTO hongong3 VALUES (NULL, '고든', 25);
SELECT * FROM hongong3;

SELECT COUNT(*) FROM world.city; -- 4079개 있음

DESC world.city; -- describe의 약자로 테이블의 구조를 출력해줌. 

SELECT * FROM world.city LIMIT 5;

CREATE TABLE city_popul ( city_name CHAR(35), population INT);

INSERT INTO city_popul -- INSERT INTO ~ SELECT : 해당 테이블의 데이터를 가져와 한 번에 입력할 수 있다.(SELECT문의 열 개수=INSERT할 테이블의 열 개수여야함.)
    SELECT Name, Population FROM world.city;
    
USE market_db;
UPDATE city_popul
    SET city_name = '서울'
    WHERE city_name = 'Seoul'; -- 도시 이름이 영문으로 서울일 경우 한국어로 바꿔줌.
SELECT  * FROM city_popul WHERE  city_name = '서울'; 

UPDATE city_popul
    SET city_name = '뉴욕', population = 0
    WHERE city_name = 'New York'; -- 도시 이름이 영문일 경우 인구는 0, 한국어로 바꿈.
SELECT  * FROM city_popul WHERE  city_name = '뉴욕';

-- UPDATE city_popul
--    SET city_name = '서울'

UPDATE city_popul
    SET population = population / 10000 ; -- 모든 행의 인구 수를 10000으로 나눔.
SELECT * FROM city_popul LIMIT 5;

DELETE FROM city_popul 
    WHERE city_name LIKE 'New%'; -- 도시 이름이 New~로 되어있다면 지운다.

DELETE FROM city_popul 
    WHERE city_name LIKE 'New%'
    LIMIT 5; -- 위와 같지만 5개 제한

CREATE TABLE big_table1 (SELECT * FROM world.city , sakila.country); 
CREATE TABLE big_table2 (SELECT * FROM world.city , sakila.country); 
CREATE TABLE big_table3 (SELECT * FROM world.city , sakila.country); 
SELECT COUNT(*) FROM big_table1;

DELETE FROM big_table1; -- 속도 느림.
DROP TABLE big_table2; -- drop은 테이블 자체를 삭제한다. 나머지는 삭제해도 남아있다.
TRUNCATE TABLE big_table3; -- 속도 빠름.

