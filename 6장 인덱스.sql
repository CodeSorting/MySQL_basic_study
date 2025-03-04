-- ------------------------------
-- 1절 : 인덱스
-- ------------------------------
/*
인덱스는 클러스터형 인덱스(기본 키로 지정되면 자동 생성, 테이블 당 1개만 존재) : 영어사전과 비슷,
보조 인덱스(고유 키로 지정하면 자동 생성, 여러개 만들 수 있음 but 자동정렬 X) : 일반 책 뒤의 찾아보기와 비슷.
적절한 인덱스는 성능을 향상시키지만, UPDATE,DELETE가 많으면 오히려 방해가 된다.
*/
USE market_db;
CREATE TABLE table1  (
    col1  INT  PRIMARY KEY,
    col2  INT,
    col3  INT
);
SHOW INDEX FROM table1; -- 테이블의 인덱스 볼 수 있다. Non_unique 0, key_name PRIMARY, column_name col1..으로 인덱스 정보를 확인한다.

CREATE TABLE table2  (
    col1  INT  PRIMARY KEY,
    col2  INT  UNIQUE, -- 고유키로 지정.
    col3  INT  UNIQUE
);
SHOW INDEX FROM table2; -- 각각 키 이름이 PRIMARY,col2,col3이며 column_name은 col1,col2,col3이다.

USE market_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10),
  mem_number  INT ,  
  addr        CHAR(2)  
 );

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;

ALTER TABLE member
     ADD CONSTRAINT 
     PRIMARY KEY (mem_id); -- mem_id를 기본키로 설정하면 자동으로 알파벳 순서대로 정렬됨.
SELECT * FROM member;

ALTER TABLE member DROP PRIMARY KEY ; -- 기본 키 제거
ALTER TABLE member 
    ADD CONSTRAINT 
    PRIMARY KEY(mem_name); -- mem_name(한글) 순서대로 정렬됨. (실제에서 회원이름은 중복될 수 있으므로 기본키 사용 금지)
SELECT * FROM member;

INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

-- 고유키 = 보조 인덱스 생성, 보조 인덱스는 책 뒤의 찾아보기 같은 느낌이라 본문이 정렬되지는 않는다.
USE market_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10),
  mem_number  INT ,  
  addr        CHAR(2)  
 );

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member; -- 입력한 순서 그대로 나옴.

ALTER TABLE member
     ADD CONSTRAINT 
     UNIQUE (mem_id); -- 고유키 추가
SELECT * FROM member; -- 고유키로 설정해도 보조 인덱스를 생성해도 데이터의 내용이나 순서는 변하지 않는다.

ALTER TABLE member
     ADD CONSTRAINT 
     UNIQUE (mem_name); -- 고유키 추가
SELECT * FROM member;

INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울'); -- 역시 순서대로 있다.
SELECT * FROM member;

-- ------------------------------
-- 2절 인덱스의 내부 작동
-- ------------------------------
/*
클러스터형 인덱스와 보조 인덱스 모두 균형 트리로 이루어진다.
균형 트리는 SELECT를 사용할 때 아주 뛰어난 성능을 보인다.
균형 트리는 루트 페이지부터 검색해서 여러개의 데이터를 읽어오고 n개의 자식 중 어디로 갈지 정한다.
그러나 인덱스 사용시 INSERT,UPDATE,DELETE시 성능이 나빠진다. 페이지 분할 때문인데, 페이지 분할이란 새로운 페이지를 준비해서, 데이터를 나누는 작업이다.
만약 특정 노드 삽입시 페이지 공간이 없을 경우 데이터를 나눠서 새로운 페이지를 만들어 연결해야하기 때문이다.
*/
USE market_db;
CREATE TABLE cluster  -- 클러스터형 테이블 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10)
 );
INSERT INTO cluster VALUES('TWC', '트와이스');
INSERT INTO cluster VALUES('BLK', '블랙핑크');
INSERT INTO cluster VALUES('WMN', '여자친구');
INSERT INTO cluster VALUES('OMY', '오마이걸');
INSERT INTO cluster VALUES('GRL', '소녀시대');
INSERT INTO cluster VALUES('ITZ', '잇지');
INSERT INTO cluster VALUES('RED', '레드벨벳');
INSERT INTO cluster VALUES('APN', '에이핑크');
INSERT INTO cluster VALUES('SPC', '우주소녀');
INSERT INTO cluster VALUES('MMU', '마마무');

SELECT * FROM cluster; -- 아직은 모두 동일함.

ALTER TABLE cluster
    ADD CONSTRAINT 
    PRIMARY KEY (mem_id); -- 기본 키 제약 추가

SELECT * FROM cluster; -- APN,BLK,GRL,...순으로 정렬됨.
/*
APN 1000
MMU 1001
TWC 1002     |
|        |    |   
|           |   |   
1000         1001    |
APN 에이핑크   MMU 마마무    |
BLK 블랭핑크   OMY 오마이걸    1002
GRL 소녀시대   ....          TWC 트와이스
ITZ 잇지                    WMN 여자친구
*/

USE market_db;
CREATE TABLE second  -- 보조 인덱스 테이블 
( mem_id      CHAR(8) , 
  mem_name    VARCHAR(10)
 );
INSERT INTO second VALUES('TWC', '트와이스');
INSERT INTO second VALUES('BLK', '블랙핑크');
INSERT INTO second VALUES('WMN', '여자친구');
INSERT INTO second VALUES('OMY', '오마이걸');
INSERT INTO second VALUES('GRL', '소녀시대');
INSERT INTO second VALUES('ITZ', '잇지');
INSERT INTO second VALUES('RED', '레드벨벳');
INSERT INTO second VALUES('APN', '에이핑크');
INSERT INTO second VALUES('SPC', '우주소녀');
INSERT INTO second VALUES('MMU', '마마무');

ALTER TABLE second
    ADD CONSTRAINT 
    UNIQUE (mem_id); -- 보조 인덱스 사용

SELECT * FROM second;

/*
보조 인덱스 구조
(루트 페이지)
10
APN 100
OMY 200
|     |
|       | 
100         200 (리프 페이지)
APN 1001+#4   OMY 1000+#4
BLK 1000+#2   ...
GRL 1001+#1   SPC 1002+#1

실제 데이터 페이지
1000          1001          1002
TWC 트와이스     GRL 소녀시대    SPC 우주소녀 
BLK 블랙핑크     ITZ 잇지       ...
WMN 여자친구     RED 레드벨벳
OMY 오마이걸     APN 에이핑크

만약 SPC 검색 시 먼저 루트 페이지 200번을 읽고 SPC안의 주소 값인 1002번으로 들어가 찾는다. (10->200->1002 총 3번 읽음. logN)
*/


-- ------------------------------
-- 3절 : 인덱스의 실제 사용
-- ------------------------------

/*
CREATE [UNIQUE] INDEX 인덱스_이름 ON 테이블_이름 (열_이름) [ASC|DESC] : 기본 중복허용,기본 오름차순
DROP INDEX 인덱스_이름 ON 테이블_이름
*/
USE market_db;
SELECT * FROM member;

SHOW INDEX FROM member; -- member 테이블의 인덱스 보여줌.

SHOW TABLE STATUS LIKE 'member'; -- Data_length로 테이블의 현재 데이터 길이(1페이지는 기본 16KB(1KB=1024Byte)),index_length로 보조 인덱스 크기를 알려준다.

CREATE INDEX idx_member_addr 
   ON member (addr); -- 중복을 허용하는 addr 단순 보조 인덱스

SHOW INDEX FROM member; -- Non_Unique가 1이니 고유 보조 인덱스가 아니다.

SHOW TABLE STATUS LIKE 'member'; -- 이상하게 index_length가 0임.

ANALYZE TABLE member; -- 다시 테이블을 분석함.
SHOW TABLE STATUS LIKE 'member'; -- 이번에는 index_length가 16384로 제대로 나온다.

CREATE UNIQUE INDEX idx_member_mem_number
    ON member (mem_number); -- 중복된 값이 있어서 오류 발생

CREATE UNIQUE INDEX idx_member_mem_name
    ON member (mem_name); -- 생성됨.

SHOW INDEX FROM member;

INSERT INTO member VALUES('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020.10.10'); -- 에러. 마마무가 중복이다.

ANALYZE TABLE member;  -- 지금까지 만든 인덱스를 모두 적용
SHOW INDEX FROM member;


SELECT * FROM member; -- FULL TABLE SCAN이다.

SELECT mem_id, mem_name, addr FROM member; -- FULL TABLE SCAN이다.

SELECT mem_id, mem_name, addr 
    FROM member 
    WHERE mem_name = '에이핑크'; -- mem_name은 보조키가 있으므로 Single Row(constant)가 나온다.
    
    
CREATE INDEX idx_member_mem_number
    ON member (mem_number); -- 이번에는 숫자 범위로 조회
ANALYZE TABLE member; -- 인덱스 적용

SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 7; -- 결과는 4건 나옴. (index range scan)
    
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 1;  -- 이 경우는 full table scan이다. 1명 이상이니 인덱스 검색보다는 전체 테이블 검색이 낫겠다고 판단했기 때문이다.
    
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number*2 >= 14; -- 그러나 where문에서 열에 연산이 가해지면 인덱스를 사용하지 않는다.
    
SELECT mem_name, mem_number 
    FROM member 
    WHERE mem_number >= 14/2; -- 따라서 이렇게 해야한다. 이러면 index range scan이다.
    
SHOW INDEX FROM member;

DROP INDEX idx_member_mem_name ON member;
DROP INDEX idx_member_addr ON member;
DROP INDEX idx_member_mem_number ON member; -- 인덱스 3개 모두 삭제

ALTER TABLE member 
    DROP PRIMARY KEY; -- 기본키 삭제 = 오류, member의 mem_id 열을 buy가 참조하고 있기 때문이다.


SELECT table_name, constraint_name -- MySQL 안에 원래 포함되어 있는 시스템 데이터베이스와 테이블이다. 여기에 MySQL 전체의 외래키 정보가 있다.
    FROM information_schema.referential_constraints
    WHERE constraint_schema = 'market_db';

ALTER TABLE buy 
    DROP FOREIGN KEY buy_ibfk_1; -- 외래키 버리기
ALTER TABLE member 
    DROP PRIMARY KEY; -- 이제 버려짐.

/*
1. 인덱스는 열 단위에 생성된다.
2. Where 절에서 사용되는 열에 인덱스를 만들어야 한다.
3. Where 절에 사용되더라도 자주 사용해야 가치가 있다.
4. 데이터의 중복이 높은 열은 인덱스를 만들어도 별 효과가 없다.
5. 클러스터형 인덱스는 테이블당 하나만 생성할 수 있다. 성능이 우수하고 조회할 때 가장 많이 사용하는 열에 지정하는 것이 효과적이다.
6. 사용하지 않는 인덱스는 제거하는게 좋다.
*/
SELECT mem_id, mem_name, mem_number, addr -- 4개 모두 인덱스를 만들기 보다 where 절에서 사용하는 mem_name만 인덱스를 만드는게 좋다.
    FROM member 
    WHERE mem_name = '에이핑크';