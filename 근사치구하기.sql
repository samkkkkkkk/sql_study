
-- �ٻ�ġ�� ���ϴ� ���
SELECT * FROM
    (
    SELECT * FROM test_location
    ORDER BY ABS(latitude - 37.5621181) + ABS(longitude - 126.9428028)
    )
WHERE ROWNUM = 1;
