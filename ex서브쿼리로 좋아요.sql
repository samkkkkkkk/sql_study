
-- 좋아요 테이블
CREATE TABLE sns_like(
    lno NUMBER PRIMARY KEY,
    user_id VARCHAR2(50) NOT NULL,
    bno NUMBER NOT NULL
);

--ON DELETE CASCADE
--외래 키(FK)를 참조할 때, 참조하는 데이터가 삭제되는 경우
--참조하고 있는 데이터도 함께 삭제를 진행하겠다.
ALTER TABLE sns_like ADD FOREIGN KEY(bno)
REFERENCES snsboard(bno)
ON DELETE CASCADE;
SELECT * FROM sns_like;
CREATE SEQUENCE sns_like_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100000
    NOCYCLE
    NOCACHE;


SELECT tbl2.*, 
    (SELECT COUNT(*) FROM sns_like WHERE bno = tbl2.bno) AS like_cnt
FROM
		(
		SELECT ROWNUM AS rn, tbl.*
			FROM
			(
                SELECT * FROM snsboard
                ORDER BY bno DESC
			) tbl
		)tbl2
WHERE rn > 0
AND rn <= 3;


SELECT tbl2.*, NVL(b.like_cnt, 0) AS like_cnt
FROM
    (
    SELECT ROWNUM AS rn, tbl.*
        FROM
        (
            SELECT * FROM snsboard
            ORDER BY bno DESC
        ) tbl
    ) tbl2
LEFT JOIN 
(
SELECT 
    bno,
    COUNT(*) AS like_cnt
FROM sns_like
GROUP BY bno
) b
ON tbl2.bno = b.bno
WHERE rn > 0
AND rn <= 3;


    
	




