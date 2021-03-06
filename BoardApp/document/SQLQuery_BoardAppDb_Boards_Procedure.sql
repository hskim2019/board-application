
-- ======================Board 프로시저=================================

-- ********************************* Select Procedure 생성*************************
--ALTER PROCEDURE USP_SelectBoardList

--AS

--SELECT 
--	A.BoardNo
--	, A.BoardTitle
--	, A.BoardWriter
--	, CONVERT (CHAR(10), A.CreatedDate, 23) AS CreatedDate
--	, A.ViewCount
--	, ROW_NUMBER() OVER(ORDER BY A.BoardNo) AS ROWNUM
--	, (SELECT COUNT(*) FROM Comments_TB WHERE BoardNo = A.BoardNo) AS CommentCTN
	
--FROM Boards AS A
--ORDER BY BoardNo DESC



---- 실행
--EXEC dbo.USP_SelectBoardList





-- Detail Procedure 생성/수정
ALTER PROCEDURE USP_SelectBoardListByNo
	@P_BoardNo INT

AS 

SET NOCOUNT OFF

DECLARE @err INT
DECLARE @rowCount INT

SELECT
	A.BoardNo
	, A.BoardTitle
	, A.BoardContent
	, A.BoardWriter
	, A.CreatedDate
	, A.ViewCount
	, (SELECT COUNT(*) FROM Comments_TB WHERE BoardNo = A.BoardNo AND FinalFlag = 0) AS CommentCTN
	, B.AttachedFileName
FROM Boards AS A
	LEFT JOIN AttachedFiles_TB AS B
	ON A.BoardNo = B.BoardNo
WHERE A.BoardNo = @P_BoardNo

SET @err = @@ERROR

IF @err <> 0
	RETURN

SELECT @rowCount= COUNT(*) FROM Boards WHERE BoardNo = @P_BoardNo

IF (@rowCount <= 0)
	 BEGIN
		PRINT N'no record'
	END
 ELSE
	BEGIN
	UPDATE Boards SET ViewCount += 1 WHERE BoardNo = @P_BoardNo
	END


-- 실행
  EXEC dbo.USP_SelectBoardListByNo 154



-- ***************************Add Procedure*******************************
ALTER PROCEDURE USP_InsertBoard
	@P_BoardTitle VARCHAR(255)
	, @P_BoardContent TEXT
	, @P_BoardWriter VARCHAR(50)
	, @id int output
AS


INSERT INTO Boards
	(BoardTitle, BoardContent, BoardWriter, CreatedDate)
VALUES (@P_BoardTitle, @P_BoardContent, @P_BoardWriter, GETDATE())

SET @id=SCOPE_IDENTITY()
      RETURN  @id



-- 실행
EXEC USP_InsertBoard 'identity', 'test' ,'identity'






--**************************************Delete Procedure 생성*********************************
ALTER PROCEDURE USP_DeleteBoard
	@P_BoardNo INT

AS
BEGIN TRAN
EXEC USP_DeleteCommentWithBoardNo @P_BoardNo
--EXEC USP_DeleteAttachedFile @P_BoardNo
EXEC USP_DeleteAttachment @P_BoardNo

DELETE Boards WHERE BoardNo = @P_BoardNo
COMMIT TRAN



--*************************************UPDATE PROCEDURE 생성************************************
ALTER PROCEDURE USP_UpdateBoard
	@P_BoardNo INT
	, @P_BoardTitle VARCHAR(255)
	, @P_BoardContent TEXT

AS
BEGIN TRAN
UPDATE Boards
	SET BoardTitle = @P_BoardTitle
	, BoardContent = @P_BoardContent
	, CreatedDate = GETDATE()
	WHERE BoardNo = @P_BoardNo 
COMMIT TRAN



--*****************************************게시물 개수 가져오는 Procedure***************************
ALTER PROCEDURE USP_SelectRowCount
@count int OUTPUT
AS

SELECT DISTINCT @count = MAX(idx.ROWS)
FROM SYSINDEXES AS idx
INNER JOIN SYSOBJECTS AS obj
ON (idx.id = obj.id)
WHERE (obj.type = 'U') AND (obj.name = 'Boards')
PRINT @count




--*****************************Paging을 위한 Select Procedure 생성*************************
ALTER PROCEDURE USP_SelectBoard
	@P_START INT
	,@P_END INT
AS

SELECT * 
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY BoardNo ASC) AS ROWNUM
	, ROW_NUMBER() OVER(ORDER BY BoardNo DESC) AS RN
	, A.BoardNo
	, A.BoardTitle
	, A.BoardWriter
	, CONVERT (CHAR(10), A.CreatedDate, 23) AS CreatedDate
	, A.ViewCount
	, (SELECT COUNT(*) FROM Comments_TB WHERE BoardNo = A.BoardNo AND FinalFlag = 0) AS CommentCTN
	--, (SELECT COUNT(*) FROM AttachedFiles_TB WHERE BoardNo = A.BoardNo) AS FileCTN
	, (SELECT COUNT(*) FROM Attachment_TB WHERE BoardNo = A.BoardNo) AS FileCTN
	FROM Boards AS A) AS T1
WHERE RN between @P_START AND @P_END
ORDER BY BoardNo DESC










