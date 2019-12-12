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


-- 테스트
EXEC USP_InsertComment 154, 0, 0, 0, '테스터', '네번째댓글(1)'
EXEC USP_InsertComment 154, 0, 0, 0, 'Tester', '네번째댓글(2)'
EXEC USP_InsertComment 154, 33, 33, 1, '댓글', 'RE: 네번째댓글(1)에 댓글'
EXEC USP_InsertComment 154, 34, 34, 1, '댓글', 'RE: 네번째댓글(2)에 댓글'
EXEC USP_InsertComment 154, 35, 33, 2, '대댓글', 'RE: RE: 네번째댓글(1)에 대댓글'
EXEC USP_InsertComment 154, 36, 34, 2, '대댓글', 'RE: RE: 네번째댓글(2)의 대댓글'
EXEC USP_InsertComment 2000, 35, 33, 2, '대댓글', 'RE: RE: 네번째댓글(1)에 대댓글(2)'

Select * from Comments_TB WHERE BoardNo = 154 Order By OriginCommentNo ASC, CommentOrder ASC 


	--@P_BoardNo INT
	--, @P_OriginCommentNo INT
	--, @P_ParentCommentID INT --부모글의 CommentID, 원글인 경우는 0으로 parameter 받고 자기자신 CommentID로 Set
	--, @P_CommentLevel INT
	--, @P_CommentWriter VARCHAR(50)
	--, @P_CommentContent TEXT
	--, @P_CommentPassword VARBINARY(100)

EXEC USP_InsertComment 152, 0, 0, 0, 'A', '레벨1인댓글(1)', 1234
EXEC USP_InsertComment 152, 0, 0, 0, 'B', '레벨1인댓글(2)', 1234
EXEC USP_InsertComment 152, 41, 41, 1, 'A-A', '레벨1인댓글(1)의 댓글(1)', 1234
EXEC USP_InsertComment 152, 41, 43, 2, 'A-A-a', '레벨1인댓글(1)의 댓글(1)에 단 댓글입니다', 1234
EXEC USP_InsertComment 152, 41, 43, 2, 'A-A-b', '레벨1인댓글(1)의 댓글(1)에 단 댓글입니다(2)', 1234
EXEC USP_InsertComment 152, 42, 42, 1, 'B-B', 'B에게 단 댓글', 1234

EXEC USP_InsertComment 153, 0, 0, 0, 'SS', 'test', 1234



--*******************************SelectCommentList By BoardNo Procedure : 최신글이 아래로 ***************************
-- 나중에 수정 할 것 : level 0 댓글의 하위 댓글이 없으면 가져오지 않기
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

--테스트
EXEC USP_SelectCommentByBoardNo 154


--*******************************DeleteComment Procedure ***************************


--작성중
SELECT A.CommentID, COUNT(B.OriginCommentNo) AS CNT
FROM Comments_TB AS A 
LEFT JOIN Comments_TB AS B
ON A.CommentID = B.OriginCommentNo
WHERE B.CommentFlag = 0 
GROUP BY A.CommentID HAVING COUNT(B.OriginCommentNo) > 0

