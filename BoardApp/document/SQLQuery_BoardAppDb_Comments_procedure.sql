--=============================Comments_TB ���ν���================================

-- **********************Comment Insert ���ν��� (1) : �ֽű��� ����*****************************
 -- CommentOrder�� �θ�ۺ��� �ϳ��� +
 -- �θ�� �Ķ���Ͱ� 0�̸� �ڱ��ڽ� commentID�� OriginCommentNo�� �־��ֱ�
--INSERT INTO Comments_TB
--	(BoardNo, OriginCommentNo, CommentLevel, CommentWriter, CommentContent,CommentCreatedDate)
--VALUES (154, 3, 1, 'ȫ�浿', '3���Ǵ��3', GETDATE())

---- ADD ���ν��� (�ۼ���)
--ALTER PROCEDURE USP_InsertComment
--	@P_BoardNo INT
--	, @P_CommentID INT
--	, @P_OriginCommentNo INT
--	, @P_CommentLevel INT
--	, @P_CommentWriter VARCHAR(50)
--	, @P_CommentContent TEXT

--AS

--DECLARE @ID INT
--DECLARE @groupOrder INT

--BEGIN TRAN

--INSERT INTO Comments_TB
--	(BoardNo, OriginCommentNo, CommentLevel, CommentWriter, CommentContent, CommentCreatedDate)
--VALUES(@P_BoardNo, @P_OriginCommentNo, @P_CommentLevel, @P_CommentWriter, @P_CommentContent, GETDATE())

--SET @ID = SCOPE_IDENTITY()

--IF(@P_OriginCommentNo = 0)
--	BEGIN
--	 -- ����� �ڱ� �ڽ��� OriginCommentNo�� 0���� �ԷµǹǷ� OriginCommentNo = CommentID�� ������Ʈ
--	 UPDATE Comments_TB
--		SET OriginCommentNo = @ID WHERE CommentID = @ID
--	END
--IF(@P_CommentID != 0)
--	BEGIN
	
--	SELECT @groupOrder = CommentOrder FROM Comments_TB WHERE CommentId = @P_CommentID
--	UPDATE Comments_TB SET CommentOrder = @groupOrder + 1 WHERE CommentID = @ID
--	UPDATE Comments_TB SET CommentOrder = CommentOrder + 1 
--		WHERE OriginCommentNo = @P_OriginCommentNo AND CommentOrder > @groupOrder AND CommentID != @ID
--	END

--COMMIT TRAN





--*********************Comment Insert ���ν��� (2): �ֽű��� �Ʒ��� ***************************************
ALTER PROCEDURE USP_InsertComment
	@P_BoardNo INT
	, @P_OriginCommentNo INT
	, @P_ParentCommentID INT --�θ���� CommentID, ������ ���� 0���� parameter �ް� �ڱ��ڽ� CommentID�� Set
	, @P_CommentLevel INT
	, @P_CommentWriter VARCHAR(50)
	, @P_CommentContent TEXT
	, @P_CommentPassword VARBINARY(100)

AS

DECLARE @ID INT
DECLARE @originCommentOrder INT
DECLARE @originCommentLevel INT
DECLARE @minCommentOrder INT
DECLARE @maxCommentOrder INT
DECLARE @originCommentNo INT

BEGIN TRAN

INSERT INTO Comments_TB
	(BoardNo, OriginCommentNo, ParentCommentNo, CommentLevel, CommentWriter, CommentContent, CommentCreatedDate, CommentPassword)
VALUES(@P_BoardNo, @P_OriginCommentNo, @P_ParentCommentID, @P_CommentLevel, @P_CommentWriter, @P_CommentContent, GETDATE(), PWDENCRYPT('@P_CommentPassword'))

SET @ID = SCOPE_IDENTITY()

-- ����1�� ����� OriginCommentNo�� 0���� �ԷµǹǷ� OriginCommentNo = CommentID�� ������Ʈ
IF(@P_OriginCommentNo = 0)
	BEGIN
	 UPDATE Comments_TB
		SET OriginCommentNo = @ID WHERE CommentID = @ID

	SET @originCommentNo = @ID
	SET @P_ParentCommentID = @ID
		PRINT '1-1.@P_ParentCommentID�� �ڱ��ڽ����� ���� :' PRINT @P_ParentCommentID
	END
ELSE
	BEGIN
	SET @originCommentNo = @P_OriginCommentNo
	PRINT '1-2.@originCommentNO�� :' PRINT @originCommentNo
	END

SELECT @originCommentOrder = ISNULL(CommentOrder, 0) FROM Comments_TB WHERE CommentID = @P_ParentCommentID
		PRINT '2.@originCommentOrder��: ' PRINT @originCommentOrder
SELECT @originCommentLevel = ISNULL(CommentLevel, 0) FROM Comments_TB WHERE CommentID = @P_ParentCommentID
		PRINT '3.@originCommentLevel��: ' PRINT @originCommentLevel
	
SELECT @minCommentOrder = ISNULL(MIN(CommentOrder), 0) FROM Comments_TB
   WHERE  OriginCommentNo = @originCommentNo
   AND CommentOrder > @originCommentOrder
   AND CommentLevel <= @originCommentLevel
    	PRINT '4.@minCommentOrder:' PRINT @minCommentOrder

   IF(@minCommentOrder = 0)
   BEGIN 
	SELECT @maxCommentOrder = ISNULL(MAX(CommentOrder),0) FROM Comments_TB 
    WHERE OriginCommentNo = @originCommentNo

	UPDATE Comments_TB SET CommentOrder = @maxCommentOrder + 1 WHERE CommentID = @ID
	   PRINT '5-1. @minCommentOrder�� 0=' PRINT @minCommentOrder
	   PRINT '5-1. @maxCommentOrder��' PRINT @maxCommentOrder
   END 
   
   ELSE -- 0�� �ƴϸ� 
   BEGIN
   PRINT '5-2. @minCommentOrder�� 0 �̻� :' PRINT @minCommentOrder
   UPDATE Comments_TB SET CommentOrder = CommentOrder + 1 
   WHERE OriginCommentNo =  @originCommentNo  AND CommentOrder >= @minCommentOrder

   UPDATE Comments_TB SET CommentOrder = @minCommentOrder WHERE CommentID = @ID
   END


SELECT 
	A.CommentID
	, A.BoardNo
	, A.OriginCommentNo
	, ISNULL(B.CommentWriter, '0') AS ParentCommentWriter
	, A.CommentLevel
	, A.CommentOrder
	, A.CommentWriter
	, A.CommentContent
	, CONVERT (CHAR(10), A.CommentCreatedDate, 23) AS CreatedDate
	, A.CommentFlag
	FROM Comments_TB AS A
	LEFT JOIN Comments_TB AS B
		ON A.ParentCommentNo = B.CommentID
	WHERE A.CommentID = @ID
	

COMMIT TRAN


-- �׽�Ʈ
EXEC USP_InsertComment 154, 0, 0, 0, '�׽���', '�׹�°���(1)'
EXEC USP_InsertComment 154, 0, 0, 0, 'Tester', '�׹�°���(2)'
EXEC USP_InsertComment 154, 33, 33, 1, '���', 'RE: �׹�°���(1)�� ���'
EXEC USP_InsertComment 154, 34, 34, 1, '���', 'RE: �׹�°���(2)�� ���'
EXEC USP_InsertComment 154, 35, 33, 2, '����', 'RE: RE: �׹�°���(1)�� ����'
EXEC USP_InsertComment 154, 36, 34, 2, '����', 'RE: RE: �׹�°���(2)�� ����'
EXEC USP_InsertComment 2000, 35, 33, 2, '����', 'RE: RE: �׹�°���(1)�� ����(2)'

Select * from Comments_TB WHERE BoardNo = 154 Order By OriginCommentNo ASC, CommentOrder ASC 


	--@P_BoardNo INT
	--, @P_OriginCommentNo INT
	--, @P_ParentCommentID INT --�θ���� CommentID, ������ ���� 0���� parameter �ް� �ڱ��ڽ� CommentID�� Set
	--, @P_CommentLevel INT
	--, @P_CommentWriter VARCHAR(50)
	--, @P_CommentContent TEXT
	--, @P_CommentPassword VARBINARY(100)

EXEC USP_InsertComment 152, 0, 0, 0, 'A', '����1�δ��(1)', 1234
EXEC USP_InsertComment 152, 0, 0, 0, 'B', '����1�δ��(2)', 1234
EXEC USP_InsertComment 152, 41, 41, 1, 'A-A', '����1�δ��(1)�� ���(1)', 1234
EXEC USP_InsertComment 152, 41, 43, 2, 'A-A-a', '����1�δ��(1)�� ���(1)�� �� ����Դϴ�', 1234
EXEC USP_InsertComment 152, 41, 43, 2, 'A-A-b', '����1�δ��(1)�� ���(1)�� �� ����Դϴ�(2)', 1234
EXEC USP_InsertComment 152, 42, 42, 1, 'B-B', 'B���� �� ���', 1234

EXEC USP_InsertComment 153, 0, 0, 0, 'SS', 'test', 1234



--*******************************SelectCommentList By BoardNo Procedure : �ֽű��� �Ʒ��� ***************************
-- ���߿� ���� �� �� : level 0 ����� ���� ����� ������ �������� �ʱ�
ALTER PROCEDURE USP_SelectCommentByBoardNo
	@P_BoardNo INT

AS

SELECT 
	A.CommentID
	, A.BoardNo
	, A.OriginCommentNo
	, ISNULL(B.CommentWriter, '0') AS ParentCommentWriter
	, A.CommentLevel
	, A.CommentOrder
	, A.CommentWriter
	, A.CommentContent
	, CONVERT (CHAR(10), A.CommentCreatedDate, 23) AS CreatedDate
	, A.CommentFlag
	FROM Comments_TB AS A
	LEFT JOIN Comments_TB AS B
		ON A.ParentCommentNo = B.CommentID
	WHERE A.BoardNo = @P_BoardNo
	ORDER BY OriginCommentNo ASC, CommentOrder ASC

--�׽�Ʈ
EXEC USP_SelectCommentByBoardNo 154


--*******************************DeleteComment Procedure ***************************


--�ۼ���
SELECT A.CommentID, COUNT(B.OriginCommentNo) AS CNT
FROM Comments_TB AS A 
LEFT JOIN Comments_TB AS B
ON A.CommentID = B.OriginCommentNo
WHERE B.CommentFlag = 0 
GROUP BY A.CommentID HAVING COUNT(B.OriginCommentNo) > 0

