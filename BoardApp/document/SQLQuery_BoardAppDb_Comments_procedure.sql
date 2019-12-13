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
	, @P_CommentPassword VARCHAR(50)

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
VALUES(@P_BoardNo, @P_OriginCommentNo, @P_ParentCommentID, @P_CommentLevel, @P_CommentWriter, @P_CommentContent, GETDATE(), PWDENCRYPT(@P_CommentPassword))

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

EXEC USP_InsertComment 61, 0, 0, 0, 'SSS', 'test', 'a'




--*******************************SelectCommentList By BoardNo Procedure : �ֽű��� �Ʒ��� ***************************
ALTER PROCEDURE USP_SelectCommentByBoardNo
	@P_BoardNo INT

AS

--SELECT 
--	A.CommentID
--	, A.BoardNo
--	, A.OriginCommentNo
--	, ISNULL(B.CommentWriter, '0') AS ParentCommentWriter
--	, A.CommentLevel
--	, A.CommentOrder
--	, A.CommentWriter
--	, A.CommentContent
--	, CONVERT (CHAR(10), A.CommentCreatedDate, 23) AS CreatedDate
--	, A.CommentFlag
--	FROM Comments_TB AS A
--	LEFT JOIN Comments_TB AS B
--		ON A.ParentCommentNo = B.CommentID
--	WHERE A.BoardNo = @P_BoardNo
--	ORDER BY OriginCommentNo ASC, CommentOrder ASC


SELECT A.CommentID
	, A.BoardNo
	, A.OriginCommentNo
	, ISNULL(B.CommentWriter, '0') AS ParentCommentWriter
	, A.CommentLevel
	, A.CommentOrder
	, A.CommentWriter
	, A.CommentContent
	, CONVERT (CHAR(10), A.CommentCreatedDate, 23) AS CreatedDate
	, A.CommentFlag
	, A.FinalFlag
	FROM Comments_TB AS A 
	LEFT JOIN Comments_TB AS B
		ON A.ParentCommentNo = B.CommentID
	WHERE A.BoardNo = @P_BoardNo AND A.CommentFlag = 0 AND A.CommentLevel > 0

UNION ALL

--SELECT
--	A.CommentID
--	, A.BoardNo
--	, A.OriginCommentNo
--	, ISNULL(B.CommentWriter, '0') AS ParentCommentWriter
--	, A.CommentLevel
--	, A.CommentOrder
--	, A.CommentWriter
--	, A.CommentContent
--	, CONVERT (CHAR(10), A.CommentCreatedDate, 23) AS CreatedDate
--	, A.CommentFlag
--FROM Comments_TB AS A 
--INNER JOIN Comments_TB AS B
--ON A.CommentID = B.OriginCommentNo
--WHERE B.CommentFlag = 0 AND A.CommentFlag = 1 AND A.BoardNo = @P_BoardNo
SELECT
	CommentID
	, BoardNo
	, OriginCommentNo
	, CommentWriter AS ParentCommentWriter
	, CommentLevel
	, CommentOrder
	, CommentWriter
	, CommentContent
	, CONVERT (CHAR(10), CommentCreatedDate, 23) AS CreatedDate
	, CommentFlag
	, FinalFlag
	From Comments_TB
	WHERE FinalFlag = 0 AND BoardNo = @P_BoardNo AND CommentLevel = 0

ORDER BY OriginCommentNo ASC, CommentOrder ASC


--�׽�Ʈ
EXEC USP_SelectCommentByBoardNo 150


--*******************************DeleteComment Procedure ***************************
-- Flag�� �����ϰ� ������ ���� ����
ALTER PROCEDURE USP_DeleteComment
	@P_CommentID INT
	, @P_CommentPassword VARCHAR(50)
	, @P_CommentLevel INT

AS

SET NOCOUNT OFF

DECLARE @rowCount INT
DECLARE @originCommentNo INT


BEGIN TRAN

-- ���� 0�̸� �÷��� OriginCommentNo = CommentID & CommentFlag 0 �� �� Ȯ��
	-- ������ CommentFlag �� ����
	-- ������ FinalFlag �� 1�� ����
SELECT @originCommentNo = OriginCommentNo FROM Comments_TB WHERE CommentID = @P_CommentID

IF(@P_CommentLevel = 0)
	BEGIN
		PRINT '@P_CommentLevel = 0'
		SELECT CommentID From Comments_TB WHERE OriginCommentNo = @P_CommentID AND CommentFlag = 0 AND CommentLevel >= 1
		SET @rowCount = @@ROWCOUNT PRINT '@rowCount : ' PRINT @rowCount PRINT '��'

		IF(@rowCount > 0)
		BEGIN
			PRINT '@rowCount > 0'
			UPDATE Comments_TB
			SET CommentFlag = 1
			WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
			
			 PRINT @@ROWCOUNT PRINT 'CommentFlag�� ������Ʈ'
		END
		
		ELSE
		BEGIN
			PRINT '@rowCount �� 0, FinalFlag�� �����ϱ�'
		UPDATE Comments_TB
			SET CommentFlag = 1, FinalFlag = 1
			WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
			PRINT @@ROWCOUNT PRINT '�� �� �������'
		END
	END

-- ���� 0�ƴϸ�(1 �̻��̸�) CommentFlag & FinalFlag��� 1�� ����
	-- OriginCommentNo ���� �� �߿� CommentFlag 0�� �� 
ELSE

	BEGIN
	
	PRINT '���� 1 �̻��� ��� ������Ʈ'
	UPDATE Comments_TB
	SET CommentFlag = 1, FinalFlag = 1
	WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
	PRINT 'CommentFlag & FinalFlag ������Ʈ ��' PRINT @@ROWCOUNT PRINT '��/'
	

	SELECT CommentID FROM Comments_TB WHERE OriginCommentNo = @originCommentNo AND CommentFlag = 0 AND CommentLevel >= 1
	SET @rowCount = @@ROWCOUNT  PRINT '@rowCount : ' PRINT @rowCount PRINT '��'
	
	IF(@rowCount = 0)
		BEGIN
			PRINT '@rowCount�� 0�̸� ����0�� OriginComment�� FinalFlag 1�� ������Ʈ'
			UPDATE Comments_TB
			SET FinalFlag = 1
			WHERE CommentID = @originCommentNo
			PRINT @ROWCOUNT
		END
	
	
	END

COMMIT TRAN

--�׽�Ʈ
EXEC USP_DeleteComment 83,'12345', 0
SELECT CommentID, PWDCOMPARE('12345', CommentPassword) AS T FROM Comments_TB where CommentID = 80

--*******************************DeleteComment With BoardNo Procedure ***************************
-- �Խñ� ���� �� �� �ش� boardNo�� Comment ������ ����

ALTER PROCEDURE USP_DeleteCommentWithBoardNo
	@P_BoardNo INT
	

AS
BEGIN TRAN
	DELETE Comments_TB WHERE BoardNo = @P_BoardNo
COMMIT TRAN

--�׽�Ʈ
EXEC USP_DeleteCommentWithBoardNo 61

--********************************Comment���� �������� (BoardDetail ���������� ���)***************************************
ALTER PROCEDURE USP_SelectCommentCountWithBoardNo
	@P_BoardNo INT
	, @CmtCount INT OUTPUT
AS

	SELECT @CmtCount = Count(FinalFlag) FROM Comments_TB WHERE BoardNo = @P_BoardNo AND FinalFlag = 0

	PRINT @CmtCount
		RETURN @CmtCount

--�׽�Ʈ
EXEC USP_SelectCommentCountWithBoardNo 150, 1
