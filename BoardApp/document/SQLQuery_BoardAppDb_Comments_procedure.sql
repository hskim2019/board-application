--=============================Comments_TB 프로시저================================

-- **********************Comment Insert 프로시저 (1) : 최신글이 위로*****************************
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





--*********************Comment Insert 프로시저 (2): 최신글이 아래로 ***************************************
ALTER PROCEDURE USP_InsertComment
	@P_BoardNo INT
	, @P_OriginCommentNo INT
	, @P_ParentCommentID INT --부모글의 CommentID, 원글인 경우는 0으로 parameter 받고 자기자신 CommentID로 Set
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

-- 레벨1인 댓글은 OriginCommentNo가 0으로 입력되므로 OriginCommentNo = CommentID로 업데이트
IF(@P_OriginCommentNo = 0)
	BEGIN
	 UPDATE Comments_TB
		SET OriginCommentNo = @ID WHERE CommentID = @ID

	SET @originCommentNo = @ID
	SET @P_ParentCommentID = @ID
		PRINT '1-1.@P_ParentCommentID를 자기자신으로 변경 :' PRINT @P_ParentCommentID
	END
ELSE
	BEGIN
	SET @originCommentNo = @P_OriginCommentNo
	PRINT '1-2.@originCommentNO는 :' PRINT @originCommentNo
	END

SELECT @originCommentOrder = ISNULL(CommentOrder, 0) FROM Comments_TB WHERE CommentID = @P_ParentCommentID
		PRINT '2.@originCommentOrder는: ' PRINT @originCommentOrder
SELECT @originCommentLevel = ISNULL(CommentLevel, 0) FROM Comments_TB WHERE CommentID = @P_ParentCommentID
		PRINT '3.@originCommentLevel는: ' PRINT @originCommentLevel
	
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
	   PRINT '5-1. @minCommentOrder가 0=' PRINT @minCommentOrder
	   PRINT '5-1. @maxCommentOrder는' PRINT @maxCommentOrder
   END 
   
   ELSE -- 0이 아니면 
   BEGIN
   PRINT '5-2. @minCommentOrder가 0 이상 :' PRINT @minCommentOrder
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




--*******************************SelectCommentList By BoardNo Procedure : 최신글이 아래로 ***************************
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



--*******************************DeleteComment Procedure ***************************
-- Flag만 변경하고 삭제는 하지 않음
ALTER PROCEDURE USP_DeleteComment
	@P_CommentID INT
	, @P_CommentPassword VARCHAR(50)
	, @P_CommentLevel INT

AS

SET NOCOUNT OFF

DECLARE @rowCount INT
DECLARE @originCommentNo INT


BEGIN TRAN

-- 레벨 0이면 컬럼에 OriginCommentNo = CommentID & CommentFlag 0 인 것 확인
	-- 있으면 CommentFlag 만 변경
	-- 없으면 FinalFlag 도 1로 변경
SELECT @originCommentNo = OriginCommentNo FROM Comments_TB WHERE CommentID = @P_CommentID

IF(@P_CommentLevel = 0)
	BEGIN
		PRINT '@P_CommentLevel = 0'
		SELECT CommentID From Comments_TB WHERE OriginCommentNo = @P_CommentID AND CommentFlag = 0 AND CommentLevel >= 1
		SET @rowCount = @@ROWCOUNT PRINT '@rowCount : ' PRINT @rowCount PRINT '개'

		IF(@rowCount > 0)
		BEGIN
			PRINT '@rowCount > 0'
			UPDATE Comments_TB
			SET CommentFlag = 1
			WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
			
			 PRINT @@ROWCOUNT PRINT 'CommentFlag만 업데이트'
		END
		
		ELSE
		BEGIN
			PRINT '@rowCount 가 0, FinalFlag도 변경하기'
		UPDATE Comments_TB
			SET CommentFlag = 1, FinalFlag = 1
			WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
			PRINT @@ROWCOUNT PRINT '개 행 영향받음'
		END
	END

-- 레벨 0아니면(1 이상이면) CommentFlag & FinalFlag모두 1로 변경
	-- OriginCommentNo 같은 것 중에 CommentFlag 0인 것 
ELSE

	BEGIN
	
	PRINT '레벨 1 이상인 댓글 업데이트'
	UPDATE Comments_TB
	SET CommentFlag = 1, FinalFlag = 1
	WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1
	PRINT 'CommentFlag & FinalFlag 업데이트 함' PRINT @@ROWCOUNT PRINT '개/'
	

	SELECT CommentID FROM Comments_TB WHERE OriginCommentNo = @originCommentNo AND CommentFlag = 0 AND CommentLevel >= 1
	SET @rowCount = @@ROWCOUNT  PRINT '@rowCount : ' PRINT @rowCount PRINT '개'
	
	IF(@rowCount = 0)
		BEGIN
			PRINT '@rowCount가 0이면 레벨0인 OriginComment의 FinalFlag 1로 업데이트'
			UPDATE Comments_TB
			SET FinalFlag = 1
			WHERE CommentID = @originCommentNo AND CommentFlag = 1
			PRINT @ROWCOUNT
		END
	
	
	END

COMMIT TRAN



--*******************************DeleteComment With BoardNo Procedure ***************************
-- 게시글 삭제 될 때 해당 boardNo로 Comment 있으면 삭제

ALTER PROCEDURE USP_DeleteCommentWithBoardNo
	@P_BoardNo INT
	

AS
BEGIN TRAN
	DELETE Comments_TB WHERE BoardNo = @P_BoardNo
COMMIT TRAN



--********************************Comment개수 가져오기 (BoardDetail 페이지에서 사용)***************************************
ALTER PROCEDURE USP_SelectCommentCountWithBoardNo
	@P_BoardNo INT
	, @CmtCount INT OUTPUT
AS

	SELECT @CmtCount = Count(FinalFlag) FROM Comments_TB WHERE BoardNo = @P_BoardNo AND FinalFlag = 0

	PRINT @CmtCount
		RETURN @CmtCount



--********************************Comment Update Procedure***************************************
-- 받을 파라미터 : 비밀번호, 내용, 댓글번호
ALTER PROCEDURE USP_UpdateComment
	@P_CommentID INT
	, @P_CommentContent TEXT
	, @P_CommentPassword VARCHAR(50)

AS
SET NOCOUNT OFF
	BEGIN TRAN

	UPDATE Comments_TB
	SET CommentContent = @P_CommentContent
	WHERE CommentID = @P_CommentID AND PWDCOMPARE(@P_CommentPassword, CommentPassword) = 1

	COMMIT TRAN



