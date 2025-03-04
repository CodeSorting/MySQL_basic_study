-- ------------------------------
-- 1절 : stored procedure 사용 방법
-- ------------------------------

USE market_db;
DROP PROCEDURE IF EXISTS user_proc;
DELIMITER $$ -- 
CREATE PROCEDURE user_proc()
BEGIN
    SELECT * FROM member; -- 스토어드 프로시저 내용
END $$
DELIMITER ;

CALL user_proc();

DROP PROCEDURE user_proc; -- 프로시저 지우기

USE market_db;
DROP PROCEDURE IF EXISTS user_proc1;
DELIMITER $$
CREATE PROCEDURE user_proc1(IN userName VARCHAR(10)) -- IN 매개변수이름 데이터형식 : 입력 매개변수 지정
BEGIN
  SELECT * FROM member WHERE mem_name = userName; 
END $$
DELIMITER ;

CALL user_proc1('에이핑크');


DROP PROCEDURE IF EXISTS user_proc2;
DELIMITER $$
CREATE PROCEDURE user_proc2(
    IN userNumber INT, 
    IN userHeight INT  ) -- 입력 매개변수 설정
BEGIN
  SELECT * FROM member 
    WHERE mem_number > userNumber AND height > userHeight; -- 멤버 수>첫 매개변수, 키>둘째 매개변수
END $$
DELIMITER ;

CALL user_proc2(6, 165);


DROP PROCEDURE IF EXISTS user_proc3;
DELIMITER $$
CREATE PROCEDURE user_proc3(
    IN txtValue CHAR(10),
    OUT outValue INT     ) -- 출력 매개변수 설정
BEGIN
  INSERT INTO noTable VALUES(NULL,txtValue);
  SELECT MAX(id) INTO outValue FROM noTable; -- noTable의 id 최댓값을 outValue에 넣음.
END $$
DELIMITER ;

DESC noTable; -- 에러, noTable이 없음. 함수를 선언할 때는 아직 존재하지 않는 테이블을 사용해도 된다.


CREATE TABLE IF NOT EXISTS noTable( -- noTable 만들기
    id INT AUTO_INCREMENT PRIMARY KEY, 
    txt CHAR(10)
);

CALL user_proc3 ('테스트1', @myValue); -- 출력 매개변수의 위치에 @변수명 형태로 전달해주면 그 변수에 결과가 저장된다. 그리고 SELECT로 출력하면 된다.
SELECT CONCAT('입력된 ID 값 ==>', @myValue);

DROP PROCEDURE IF EXISTS ifelse_proc;
DELIMITER $$
CREATE PROCEDURE ifelse_proc(
    IN memName VARCHAR(10) -- 입력 매개변수 VARCHAR
)
BEGIN
    DECLARE debutYear INT; -- 변수 선언
    SELECT YEAR(debut_date) into debutYear FROM member
        WHERE mem_name = memName; -- member 테이블에서 debut_date 열 중 mem_name 열이 memName과 같은 것을 선택해 debutYear 변수에 넣는다.
    IF (debutYear >= 2015) THEN
            SELECT '신인 가수네요. 화이팅 하세요.' AS '메시지';
    ELSE
            SELECT '고참 가수네요. 그동안 수고하셨어요.'AS '메시지';
    END IF;
END $$
DELIMITER ;

CALL ifelse_proc ('오마이걸');

SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAY(CURDATE()); -- 현재 연,월,일을 알려주는 함수를 각각의 변수 형태로 출력함.


DROP PROCEDURE IF EXISTS while_proc;
DELIMITER $$
CREATE PROCEDURE while_proc() -- 1~100까지의 합
BEGIN
    DECLARE hap INT; -- 합계
    DECLARE num INT; -- 1부터 100까지 증가
    SET hap = 0; -- 합계 초기화
    SET num = 1; 
    
    WHILE (num <= 100) DO  -- 100까지 반복.
        SET hap = hap + num;
        SET num = num + 1; -- 숫자 증가
    END WHILE;
    SELECT hap AS '1~100 합계'; -- 1~100합계 출력
END $$
DELIMITER ;

CALL while_proc();

-- 동적 SQL : 다이나믹하게 SQL이 변경된다. 테이블이 고정된 것이 아니라 테이블 이름을 매개변수로 전달 받아서 해당 테이블을 조회한다.
DROP PROCEDURE IF EXISTS dynamic_proc;
DELIMITER $$
CREATE PROCEDURE dynamic_proc(
    IN tableName VARCHAR(20) -- 테이블 이름
)
BEGIN
  SET @sqlQuery = CONCAT('SELECT * FROM ', tableName); -- SET으로 세션변수 만듬.넘겨받은 테이블 이름을 @sqlQuery에 SELECT 문으로 문자열을 생성함. 결국 SELECT * FROM member가 실행된 것이다.
  PREPARE myQuery FROM @sqlQuery; -- SELECT 문자열을 준비하고 실행시킴.
  EXECUTE myQuery;
  DEALLOCATE PREPARE myQuery; -- 사용한 myQuery를 해제함.
END $$
DELIMITER ;

CALL dynamic_proc ('member');


-- ------------------------------
-- 2절 : stored function과 cursor
-- ------------------------------
-- 함수는 프로시저와 달리 무조건 반환값이 있다.

SET GLOBAL log_bin_trust_function_creators = 1; -- SQL로 스토어드 함수 생성 권한 허용. 밑의 4가지 중 1개를 지정할 필요가 없음.

USE market_db;
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT) -- 함수 만들기,입력 매개변수들
    RETURNS INT -- 반환 형식
	-- 여기에 지정해야하는게 있음
    /*
     DETERMINISTIC	같은 입력값에 대해 항상 같은 결과를 반환
     NO SQL	SQL 문을 실행하지 않음
     READS SQL DATA	SELECT 같은 읽기 작업만 수행
     MODIFIES SQL DATA	INSERT, UPDATE, DELETE 같은 변경 작업 수행
     */
BEGIN
    RETURN number1 + number2; -- 합을 반환
END $$
DELIMITER ;

SELECT sumFunc(100, 200) AS '합계';


DROP FUNCTION IF EXISTS calcYearFunc;
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT)
    RETURNS INT
BEGIN
    DECLARE runYear INT; -- 활동기간(연도)
    SET runYear = YEAR(CURDATE()) - dYear;
    RETURN runYear;
END $$
DELIMITER ;

SELECT calcYearFunc(2010) AS '활동햇수';

SELECT calcYearFunc(2007) INTO @debut2007; -- 현재-2007 = 18
SELECT calcYearFunc(2013) INTO @debut2013; -- 현재-2013 = 12
SELECT @debut2007-@debut2013 AS '2007과 2013 차이' ;

SELECT mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 햇수' 
    FROM member; 


SHOW CREATE FUNCTION calcYearFunc;

DROP FUNCTION calcYearFunc;


USE market_db;
DROP PROCEDURE IF EXISTS cursor_proc; -- 커서로 한 행씩 처리하는 함수
DELIMITER $$
CREATE PROCEDURE cursor_proc() -- 커서는 첫 행부터 마지막 행까지 한행씩 접근해서 값을 처리한다.
-- 커서 작동 순서 : 커서 선언 -> 반복 조건 선언 -> 커서 열기 -> (데이터 가져오기 -> 데이터 처리하기) -> 커서 닫기 이 순서대로 이루어진다.
BEGIN
    DECLARE memNumber INT; -- 회원의 인원수
    DECLARE cnt INT DEFAULT 0; -- 읽은 행의 수
    DECLARE totNumber INT DEFAULT 0; -- 인원의 합계
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부(기본을 FALSE)

    DECLARE memberCuror CURSOR FOR-- SELECT mem_number FROM member하는 커서 선언
        SELECT mem_number FROM member;

    DECLARE CONTINUE HANDLER -- 행의 끝이면 endOfRow 변수에 TRUE를 대입, DECLARE CONTINUE HANDLER는 반복 조건을 준비하는 예약어.
        FOR NOT FOUND SET endOfRow = TRUE; -- FOR NOT FOUND는 더이상 행이 없을 때 이 문장을 실행한다.

    OPEN memberCuror;  -- 커서 열기

    cursor_loop: LOOP -- 루프 이름 : cursor_loop
        FETCH  memberCuror INTO memNumber; 

        IF endOfRow THEN -- IF문으로 행 끝나면 탈출
            LEAVE cursor_loop;
        END IF;

        SET cnt = cnt + 1;
        SET totNumber = totNumber + memNumber;        
    END LOOP cursor_loop; -- 루프 끝내기

    SELECT (totNumber/cnt) AS '회원의 평균 인원 수';

    CLOSE memberCuror; 
END $$
DELIMITER ;

CALL cursor_proc();


-- ------------------------------
-- 3절 : 자동 실행되는 trigger
-- ------------------------------
-- 트리거는 INSERT,UPDATE,DELETE문이 작동할 때 자동으로 실행되는 프로그래밍 기능이다. 데이터의 무결성을 유지하고, 실수를 방지한다.
USE market_db;
CREATE TABLE IF NOT EXISTS trigger_table (id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES(1, '레드벨벳');
INSERT INTO trigger_table VALUES(2, '잇지');
INSERT INTO trigger_table VALUES(3, '블랙핑크');

DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$ 
CREATE TRIGGER myTrigger  -- 트리거 이름
    AFTER  DELETE -- 삭제 후에 작동하도록 지정
    ON trigger_table -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
    SET @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행시 작동되는 코드들
END $$ 
DELIMITER ;

SET @msg = '';
INSERT INTO trigger_table VALUES(4, '마마무');
SELECT @msg; -- 아무것도 출력 X
UPDATE trigger_table SET txt = '블핑' WHERE id = 3;
SELECT @msg; -- 아무것도 출력 X

DELETE FROM trigger_table WHERE id = 4;
SELECT @msg; -- '가수 그룹이 삭제됨' 이 출력된다.
-- 트리거 활용 : 정보를 백업하는데에도 쓰인다.
USE market_db;
CREATE TABLE singer (SELECT mem_id, mem_name, mem_number, addr FROM member); -- member 테이블을 이용해 singer 테이블 만듬.

DROP TABLE IF EXISTS backup_singer;
CREATE TABLE backup_singer
( mem_id  		CHAR(8) NOT NULL , 
  mem_name    	VARCHAR(10) NOT NULL, 
  mem_number    INT NOT NULL, 
  addr	  		CHAR(2) NOT NULL,
  modType  CHAR(2), -- 변경된 타입. '수정' 또는 '삭제'
  modDate  DATE, -- 변경된 날짜
  modUser  VARCHAR(30) -- 변경한 사용자
);

DROP TRIGGER IF EXISTS singer_updateTrg;
DELIMITER $$
CREATE TRIGGER singer_updateTrg  -- 트리거 이름
    AFTER UPDATE -- 변경 후에 작동하도록 지정
    ON singer -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
        OLD.addr, '수정', CURDATE(), CURRENT_USER() ); -- OLD 테이블은 UPDATE나 DELETE가 수행될 때, 변경되기 전의 데이터가 잠시 저장되는 임시 테이블이다. 이들 데이터를 backup_singer로 백업한다.
END $$ 
DELIMITER ;
-- 이와 반대로 NEW 테이블은 INSERT가 테이블에 들어가기 전 잠시 NEW 테이블에 있는다.
DROP TRIGGER IF EXISTS singer_deleteTrg;
DELIMITER $$
CREATE TRIGGER singer_deleteTrg  -- 트리거 이름
    AFTER DELETE -- 삭제 후에 작동하도록 지정
    ON singer -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
        OLD.addr, '삭제', CURDATE(), CURRENT_USER() );
END $$ 
DELIMITER ;


UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
DELETE FROM singer WHERE mem_number >= 7;

SELECT * FROM backup_singer; 

TRUNCATE TABLE singer; -- 모든 행의 데이터 삭제

SELECT * FROM backup_singer; -- TRUNCATE TABLE로 삭제 시에는 트리거가 발동되지 않는다. DELETE 트리거는 오직 DELETE 문에만 작동한다.