SET SCHEMA FN71873@
--скрипт, в който са дефинирани процедури и тестове с тях. Проектите трябва да има дефинирани следните типове процедури:
--процедура с курсор и входни и изходни параметри
--процедура с прихващане на изключение
--процедура с курсор и while цикъл

DROP PROCEDURE IN_OUT_PARAMETERS()@

CREATE PROCEDURE IN_OUT_PARAMETERS (IN V_NAME VARCHAR(50), OUT V_SPECIALIZATION VARCHAR(30))
LANGUAGE SQL

P1:BEGIN
   DECLARE C1 CURSOR FOR
      SELECT SPECIALIZATION FROM DOCTORS WHERE NAME = V_NAME;
      OPEN C1;
      FETCH C1 INTO V_SPECIALIZATION;
END P1@

CALL FN71873.IN_OUT_PARAMETERS('Ivan', ?)@

DROP PROCEDURE EXCEPTION()@

CREATE PROCEDURE EXCEPTION() 
LANGUAGE SQL
P2:BEGIN
   DECLARE at_end INTEGER DEFAULT 0;
   DECLARE v_clinics VARCHAR(3) DEFAULT ' ';
   DECLARE v_name VARCHAR(50) DEFAULT ' ';
   DECLARE not_found CONDITION FOR SQLSTATE '02000';
   DECLARE C2 CURSOR FOR SELECT CODE, NAME FROM CLINICS;
   DECLARE CONTINUE HANDLER FOR not_found 
     SET at_end = 1;                        
    OPEN C2; 
    ftch_loop1: LOOP 
    FETCH C2 INTO v_clinics, v_name;
    IF at_end = 1 THEN
     LEAVE ftch_loop1;
    ELSEIF v_clinics = 'DC' THEN 
     ITERATE ftch_loop1;
    END IF;
    INSERT INTO CLINICS (CODE, NAME)
    VALUES ('NEW', v_name); 
   END LOOP;
   CLOSE C2;
END P2@

SELECT * FROM CLINICS@

CALL FN71873.EXCEPTION()@

DROP PROCEDURE CURSOR_WHILE()@

CREATE PROCEDURE CURSOR_WHILE(OUT SUM INTEGER) 
  LANGUAGE SQL
P3:BEGIN
    DECLARE p_sum INTEGER;
    DECLARE p_salary INTEGER;
    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';
    DECLARE C3 CURSOR FOR SELECT SALARY FROM DOCTORS;
     SET p_sum = 0;
     OPEN C3;
     FETCH FROM C3 INTO p_salary;
     WHILE(SQLSTATE = '00000') DO
        SET p_sum = p_sum + p_salary;
        FETCH FROM C3 INTO p_salary; 
     END WHILE;
     CLOSE C3;
     SET sum = p_sum;
  END P3@
  
  CALL FN71873.CURSOR_WHILE(?)@