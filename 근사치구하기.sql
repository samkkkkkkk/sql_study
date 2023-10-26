
-- 근사치를 구하는 방식
SELECT * FROM
    (
    SELECT * FROM test_location
    ORDER BY ABS(latitude - 37.5621181) + ABS(longitude - 126.9428028)
    )
WHERE ROWNUM = 1;
