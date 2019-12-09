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


-- **********************Comment Insert 프로시저 (1) : 최신글이 위로
 -- CommentOrder는 부모글보다 하나씩 +
 -- 부모글 파라미터가 0이면 자기자신 commentID를 OriginCommentNo에 넣어주기
--INSERT INTO Comments_TB
--	(BoardNo, OriginCommentNo, CommentLevel, CommentWriter, CommentContent,CommentCreatedDate)
--VALUES (154, 3, 1, '홍길동', '3번의댓글3', GETDATE())

---- ADD 프로시저 (작성중)
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
--	 -- 원댓글 자기 자신은 OriginCommentNo가 0으로 입력되므로 OriginCommentNo = CommentID로 업데이트
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





--*********************Comment Insert 프로시저 (2): 최신글이 아래로
-- ADD 프로시저 (작성중)
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

-- 원댓글 자기 자신은 OriginCommentNo가 0으로 입력되므로 OriginCommentNo = CommentID로 업데이트
IF(@P_OriginCommentNo = 0)
	BEGIN
	 UPDATE Comments_TB
		SET OriginCommentNo = @ID WHERE CommentID = @ID
	END


IF(@P_CommentID != 0) -- 부모글의 CommentOrder찾기
SELECT @originCommentOrder = CommentOrder FROM Comments_TB WHERE CommentID = @P_CommentID
SELECT @originCommentLevel = CommentLevel FROM Comments_TB WHERE CommentID = @P_CommentID

PRINT @originCommentOrder


	SELECT @minCommentOrder = MIN(CommentOrder) FROM Comments_TB
		WHERE OriginCommentNo = @P_OriginCommentNo
		AND CommentOrder > @originCommentOrder
		AND CommentLevel <= @originCommentLevel

		IF(@minCommentOrder = NULL)
		BEGIN
		-- @originCommentOrder 보다 +1 
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

EXEC USP_InsertComment 154, 0, 0, 0, '테스터', '네번째댓글'
EXEC USP_InsertComment 154, 14, 14, 1, '댓글', 'RE: 네번째댓글의대댓글'
EXEC USP_InsertComment 154, 14, 14, 1, '댓글2', 'RE: 네번째댓글의대댓글2'
EXEC USP_InsertComment 154, 18, 14, 2, '대댓글', 'RE: RE: 네번째댓글의대댓글의댓글'
EXEC USP_InsertComment 154, 19, 14, 2, '대댓글', 'RE: RE: 네번째대댓글의대댓글2의댓글'
