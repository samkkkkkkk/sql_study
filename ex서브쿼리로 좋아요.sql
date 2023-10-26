
-- ���ƿ� ���̺�
CREATE TABLE sns_like(
    lno NUMBER PRIMARY KEY,
    user_id VARCHAR2(50) NOT NULL,
    bno NUMBER NOT NULL
);

--ON DELETE CASCADE
--�ܷ� Ű(FK)�� ������ ��, �����ϴ� �����Ͱ� �����Ǵ� ���
--�����ϰ� �ִ� �����͵� �Բ� ������ �����ϰڴ�.
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


    
	




