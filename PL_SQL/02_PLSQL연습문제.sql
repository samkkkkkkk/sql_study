
SET SERVEROUTPUT ON;

-- 1. employees ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ�
-- �͸����� ����� ����. (������ ��Ƽ� ����ϼ���.)

DECLARE
    emp_name employees.first_name%TYPE;
    emp_email employees.email%TYPE;        
BEGIN
    SELECT 
        first_name, email
    INTO emp_name, emp_email
    FROM employees
    WHERE employee_id = 201;
    
    DBMS_OUTPUT.put_line(emp_name || '-' || emp_email);
END;

-- 2. employees ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� �� (MAX �Լ� ���)
-- �� ��ȣ + 1������ �Ʒ��� ����� emps ���̺�
-- employee_id, last_name, email, hire_date, job_id�� �ű� �����ϴ� �͸� ����� ���弼��.
-- SELECT�� ���Ŀ� INSERT�� ����� �����մϴ�.
/*
<�����>: steven
<�̸���>: stevenjobs
<�Ի�����>: ���ó�¥
<JOB_ID>: CEO
*/

DECLARE
    emp_id employees.employee_id%TYPE;
BEGIN
    SELECT
    MAX(employee_id)
    INTO emp_id
    FROM employees;
    
    INSERT INTO emps
    (employee_id, last_name, email, hire_date, job_id)
    VALUES(emp_id + 2, 'Kim', 'kkk', sysdate, '300');
END;


DECLARE
    emp_id employees.employee_id%TYPE;    
BEGIN
    SELECT 
        MAX(employee_id)
    INTO emp_id
    FROM employees;
    
    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES
        (emp_id + 1, 'steven', 'stevenjobs', sysdate, 'CEO');
END;

SELECT * FROM emps;