SELECT 
	CommentID
	, BoardNo
	, OriginCommentNo
	, CommentLevel
	, CommentOrder
	, CommentWriter
	, CommentContent
	, CONVERT (CHAR(10), CommentCreatedDate, 23) AS CreatedDate
	FROM Comments_TB
	WHERE BoardNo = 154
	ORDER BY OriginCommentNo ASC, CommentOrder ASC


-- **********************Comment Insert ���ν��� (1) : �ֽű��� ����
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





--*********************Comment Insert ���ν��� (2): �ֽű��� �Ʒ���
-- ADD ���ν��� (�ۼ���)
ALTER PROCEDURE USP_InsertComment
	@P_BoardNo INT
	, @P_CommentID INT
	, @P_OriginCommentNo INT
	, @P_CommentLevel INT
	, @P_CommentWriter VARCHAR(50)
	, @P_CommentContent TEXT

AS

DECLARE @ID INT
DECLARE @originCommentOrder INT
DECLARE @minCommentOrder INT
DECLARE @originCommentLevel INT

--BEGIN TRAN

INSERT INTO Comments_TB
	(BoardNo, OriginCommentNo, CommentLevel, CommentWriter, CommentContent, CommentCreatedDate)
VALUES(@P_BoardNo, @P_OriginCommentNo, @P_CommentLevel, @P_CommentWriter, @P_CommentContent, GETDATE())

SET @ID = SCOPE_IDENTITY()

-- ����� �ڱ� �ڽ��� OriginCommentNo�� 0���� �ԷµǹǷ� OriginCommentNo = CommentID�� ������Ʈ
IF(@P_OriginCommentNo = 0)
	BEGIN
	 UPDATE Comments_TB
		SET OriginCommentNo = @ID WHERE CommentID = @ID
	END


IF(@P_CommentID != 0) -- �θ���� CommentOrderã��
SELECT @originCommentOrder = CommentOrder FROM Comments_TB WHERE CommentID = @P_CommentID
SELECT @originCommentLevel = CommentLevel FROM Comments_TB WHERE CommentID = @P_CommentID

PRINT @originCommentOrder


	SELECT @minCommentOrder = MIN(CommentOrder) FROM Comments_TB
		WHERE OriginCommentNo = @P_OriginCommentNo
		AND CommentOrder > @originCommentOrder
		AND CommentLevel <= @originCommentLevel

		IF(@minCommentOrder = NULL)
		BEGIN
		-- @originCommentOrder ���� +1 
		UPDATE Comments_TB SET CommentOrder = @originCommentOrder + 1 WHERE CommentID = @P_CommentID
		END

		ELSE
		BEGIN
		UPDATE Comments_TB SET CommentOrder = @minCommentOrder + 1 WHERE CommentID = @P_CommentID
		UPDATE Comments_TB SET CommentOrder = CommentOrder + 1 
			WHERE OriginCommentNo = @originCommentOrder AND CommentOrder >= @minCommentOrder
		END
		
COMMIT TRAN




select * from Comments_TB
	--@P_BoardNo INT
	--, @P_CommentID INT
	--, @P_OriginCommentNo INT
	--, @P_CommentLevel INT
	--, @P_CommentWriter VARCHAR(50)
	--, @P_CommentContent TEXT

EXEC USP_InsertComment 154, 0, 0, 0, '�׽���', '�׹�°���'
EXEC USP_InsertComment 154, 14, 14, 1, '���', 'RE: �׹�°����Ǵ���'
EXEC USP_InsertComment 154, 14, 14, 1, '���2', 'RE: �׹�°����Ǵ���2'
EXEC USP_InsertComment 154, 18, 14, 2, '����', 'RE: RE: �׹�°����Ǵ����Ǵ��'
EXEC USP_InsertComment 154, 19, 14, 2, '����', 'RE: RE: �׹�°�����Ǵ���2�Ǵ��'
