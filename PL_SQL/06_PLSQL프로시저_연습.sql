
/*
프로시저명 divisor_proc
숫자 하나를 전달받아 해당 값의 약수의 개수를 출력하는 프로시저를 선언합니다.
*/

CREATE OR REPLACE PROCEDURE dicisor_proc
    (d_num IN NUMBER)
IS  
    d_cnt NUMBER := 0;
    v_num NUMBER := d_num;
BEGIN
    WHILE v_num >= 1
    LOOP
        IF MOD(d_num,v_num) = 0 THEN
            d_cnt := d_cnt + 1;
        END IF;
    v_num := v_num - 1;
    END LOOP;
    
    dbms_output.put_line(d_num || '의 약수의 개수: ' || d_cnt);
END;

CREATE PROCEDURE guguProc
    (dan IN NUMBER)
IS
BEGIN
    dbms_output.put_line(dan || '단');
    FOR i IN 1..9
    LOOP
    dbms_output.put_line(dan || 'x' || i || '=' || dan*i);
    END LOOP;
END;

EXEC guguProc3(2);


CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS
    v_count NUMBER := 0;
BEGIN
    FOR i IN 1..P_num
    LOOP
        IF MOD(p_num, i) = 0  THEN
            v_count := v_count + 1;
        END IF;
    END LOOP;
    
    dbms_output.put_line('약수의 개수: ' || v_count);
END;

EXEC dicisor_proc(72);
/*
부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
depts 테이블에 
각각 INSERT, UPDATE, DELETE 하는 depts_proc 란 이름의 프로시저를 만들어보자.
그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
*/

CREATE OR REPLACE PROCEDURE depts_proc
    (
    p_department_id IN depts.department_id%TYPE,
    p_department_name IN depts.department_name%TYPE,
    p_flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0;
BEGIN
    
    SELECT 
        COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_department_id;    
    
    IF p_flag = 'I' THEN
        INSERT INTO depts
        (department_id, department_name)
        VALUES(p_department_id, p_department_name);
    ELSIF p_flag = 'U' THEN
        UPDATE depts
        SET department_name = p_department_name
        WHERE department_id = p_department_id;
    ELSIF p_flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('삭제하고자 하는 부서가 존재하지 않습니다.');
            RETURN;
        END IF;
    
        DELETE FROM depts
        WHERE department_id = p_department_id;
    ELSE 
        dbms_output.put_line('해당 flag에 대한 동작이 준비되지 않았습니다.');
    END IF;
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('예외가 발생했습니다');
        dbms_output.put_line('ERROR MSG: ' || SQLERRM);
        ROLLBACK;
    
END;


EXEC depts_proc(700, '영업부', 'D');

SELECT * FROM depts;

CREATE OR REPLACE PROCEDURE depts_proc
    (
     dep_dep_id IN depts.department_id%TYPE,
     dep_dep_name IN depts.department_name%TYPE,
     flag IN VARCHAR2
    )
IS
    
BEGIN
    CASE
        WHEN flag = 'I' THEN
            INSERT INTO depts
                (department_id, department_name)
            VALUES(dep_dep_id, dep_dep_name, flag);
        WHEN flag = 'U' THEN
            UPDATE depts SET department_id = dep_dep_id, 
                            department_name = dep_dep_name
            WHERE department_id = dep_dep_id;
        WHEN flag = 'D' THEN
            DELETE FROM depts
            WHERE depts_id = dep_dep_id;
    END CASE;
        
END;


/*
employee_id를 입력받아 employees에 존재하면,
근속년수를 out하는 프로시저를 작성하세요. (익명블록에서 프로시저를 실행)
없다면 exception처리하세요
*/

CREATE OR REPLACE PROCEDURE emp_proc
    (emp_employee_id IN employees.employee_id%TYPE
    )
IS
    v_hr_year VARCHAR2(10);
    v_emp_first_name VARCHAR2(10);
BEGIN
    SELECT
        TRUNC((sysdate - hire_date) / 365, 0),
        first_name
    INTO
        v_hr_year, v_emp_first_name
    FROM employees
    WHERE employee_id = emp_employee_id;
    
    dbms_output.put_line(v_emp_first_name || '의 근속년수: ' || v_hr_year);
    
    EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('존재하는 사원번호가 없습니다.');
END;

EXEC emp_proc(105);

SELECT 
    TRUNC((sysdate - hire_date) / 365, 0)
FROM employees
WHERE employee_id = 100;
---------------------------------------------------


CREATE OR REPLACE PROCEDURE emp_hire_proc
    (
     p_employee_id IN employees.employee_id%TYPE,
     p_year OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT
        hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;
    
    p_year := TRUNC((sysdate-v_hire_date) / 365);
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(p_employee_id || '은(는) 없는 데이터 입니다.');
    
END;

DECLARE
    v_year NUMBER;
BEGIN
    emp_hire_proc(500, v_year);
    dbms_output.put_line(v_year || '년');
END;


/*
프로시저명 - new_emp_proc
employees 테이블의 복사 테이블 emps를 생성합니다.
employee_id, last_name, email, hire_date, job_id를 입력받아
존재하면 이름, 이메일, 입사일, 직업을 update, 
없다면 insert하는 merge문을 작성하세요

머지를 할 타겟 테이블 -> emps
병합시킬 데이터 -> 프로시저로 전달받은 employee_id를 dual에 select 때려서 비교.
프로시저가 전달받아야 할 값: 사번, last_name, email, hire_date, job_id
*/

CREATE TABLE emps AS (SELECT * FROM employees);
DROP TABLE emps;
SELECT * FROM emps;

CREATE OR REPLACE PROCEDURE new_emp_proc
    (emp_employee_id IN emps.employee_id%TYPE,
     emp_name IN emps.last_name%TYPE,
     emp_email IN emps.hire_date%TYPE,
     emp_hire_date IN emps.hire_date%TYPE,
     emp_job_id IN emps.job_id%TYPE
    )
IS
    
BEGIN
    
    MERGE INTO emps a
    USING (SELECT emp_employee_id FROM dual) b
    ON 
        (a.employee_id = b.emp_employee_id)
        
    WHEN MATCHED THEN
        UPDATE SET
        a.last_name = emp_name,
        a.email = emp_email,
        a.hire_date = emp_hire_date,
        a.job_id = emp_job_id
        
    WHEN NOT MATCHED THEN
        INSERT 
        ( employee_id, last_name, email, hire_date, job_id)
        VALUES
        
        (emp_employee_id, emp_name, emp_email, emp_hire_date, emp_job_id);
   
END;




CREATE OR REPLACE PROCEDURE new_emp_proc (
    p_employee_id IN emps.employee_id %TYPE,
    p_last_name IN emps.last_name%TYPE,
    p_email IN emps.email%TYPE,
    p_hire_date IN emps.hire_date%TYPE,
    p_job_id IN emps.job_id%TYPE
)
IS

BEGIN
    MERGE INTO emps a --머지를 할 타켓 테이블
    USING 
        (SELECT p_employee_id AS employee_id FROM dual) b
    ON --머지 조건
        (a.employee_id = b.employee_id) --전달받은 사번이 epms에 존재하는 지를 병합 조건으로 물어봄.
    WHEN MATCHED THEN
        UPDATE SET 
            a.last_name = p_last_name,
            a.email = p_email,
            a.hire_date = p_hire_date,
            a.job_id = p_job_id        
    WHEN NOT MATCHED THEN
        INSERT (a.employee_id, a.last_name, a.email, a.hire_date, a.job_id)
        VALUES (p_employee_id, p_last_name, p_email, p_hire_date, p_job_id);

END;


EXEC new_emp_proc(300, 'park', 'park4321', '2023-04-24', 'test');



DECLARE
    v_employee_id NUMBER := 101; -- 테스트를 위한 존재하는 사원 ID 입력
    v_salary_in_won NUMBER;
BEGIN
    emp_salary_proc(v_employee_id, v_salary_in_won);

    IF v_salary_in_won IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('사원의 월급(원화): ' || v_salary_in_won);
    END IF;
END;

DECLARE 
    v_salary NUMBER;
BEGIN
    emp_salary_proc(105, v_salary);
END;

CREATE OR REPLACE PROCEDURE emp_salary_proc
    (emp_employee_id IN employees.employee_id%TYPE,
     emp_salary OUT employees.salary%TYPE)
IS
    v_salary NUMBER :=1300;
    p_salary NUMBER;
BEGIN 
    SELECT 
        salary / v_salary
    INTO
        p_salary
    FROM employees
    WHERE employee_id = emp_employee_id;
        emp_salary := p_salary;
        
    EXCEPTION 
    WHEN OTHERS THEN
    dbms_output.put_line('사원이 존재하지 않습니다.');
END;

SELECT * FROM employees;
