-- DB 생성 (local)
-- 주의! Azure DB 생성할 때는 사양 설정을 위해서 portal에서 하기
IF DB_ID (N'BoardAppDb') IS NOT NULL  
DROP DATABASE BoardAppDb;  
GO  
CREATE DATABASE BoardAppDb  
COLLATE Korean_Wansung_CI_AS ;  
GO


--===========================테이블 생성==============================-
-- Board 테이블 생성
CREATE TABLE Boards (
	 BoardNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY -- 자동증가 (시작할 숫자값Seed, 증가할 숫자값)
	,BoardTitle VARCHAR(20) NOT NULL
	, BoardContent TEXT NOT NULL
	, BoardWriter VARCHAR(10) NOT NULL
	, CreatedDate DATETIME NOT NULL
	, ViewCount INT NOT NULL DEFAULT 0
)

-- 수정사항
-- BoardTitle VARCHAR(20) => VARCHAR(40)
ALTER TABLE Boards ALTER COLUMN BoardTitle VARCHAR(255) NOT NULL
ALTER TABLE Boards ALTER COLUMN BoardWriter VARCHAR(50) NOT NULL


--File 테이블 생성
CREATE TABLE Files_TB (
	 FileID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, FileSaveName VARCHAR(255) NOT NULL
	, FilePath VARCHAR(255) NOT NULL
	, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
	)


--댓글(Comment) 테이블 생성
CREATE TABLE Comments_TB (
	CommentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
	, OriginCommentNo INT NOT NULL
	, CommentLevel INT NOT NULL DEFAULT 1
	, CommentOrder INT NOT NULL DEFAULT 0
	, CommentWriter VARCHAR(50) NOT NULL
	, CommentContent TEXT NOT NULL
	, CommentCreatedDate DATETIME NOT NULL
)


-- ======================프로시저=================================
-- Select Procedure 생성
ALTER PROCEDURE USP_SelectBoardList

AS

SELECT 
	BoardNo
	, BoardTitle
	, BoardWriter
	, CONVERT (CHAR(10), CreatedDate, 23) AS CreatedDate
	, ViewCount
	, ROW_NUMBER() OVER(ORDER BY BoardNo) AS ROWNUM
FROM Boards
ORDER BY BoardNo DESC

-- 실행
EXEC dbo.USP_SelectBoardList


-- Detail Procedure 생성/수정
ALTER PROCEDURE USP_SelectBoardListByNo
	@P_BoardNo INT

AS 

SET NOCOUNT ON

DECLARE @err INT
DECLARE @rowCount INT

SELECT
	BoardNo
	, BoardTitle
	, BoardContent
	, BoardWriter
	, CreatedDate
	, ViewCount
FROM Boards
WHERE BoardNo = @P_BoardNo

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
  EXEC dbo.USP_SelectBoardListByNo 1


-- Add Procedure 생성/수정
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



select * from Boards






-- Delete Procedure 생성
ALTER PROCEDURE USP_DeleteBoard
	@P_BoardNo INT

AS
DELETE Boards WHERE BoardNo = @P_BoardNo

-- 실행
EXEC USP_DeleteBoard 1


--UPDATE PROCEDURE 생성
ALTER PROCEDURE USP_UpdateBoard
	@P_BoardNo INT
	, @P_BoardTitle VARCHAR(255)
	, @P_BoardContent TEXT

AS

UPDATE Boards
	SET BoardTitle = @P_BoardTitle
	, BoardContent = @P_BoardContent
	, CreatedDate = GETDATE()
	WHERE BoardNo = @P_BoardNo 

-- 실행
EXEC USP_UpdateBoard 13, '공지사항 입니다', '공지 내용입니다'

select * from Boards


--게시물 개수 가져오는 Procedure
ALTER PROCEDURE USP_SelectRowCount
@count int OUTPUT
AS

SELECT DISTINCT @count = MAX(idx.ROWS)
FROM SYSINDEXES AS idx
INNER JOIN SYSOBJECTS AS obj
ON (idx.id = obj.id)
WHERE (obj.type = 'U') AND (obj.name = 'Boards')
PRINT @count

-- 실행
exec USP_SelectRowCount 1



-- Paging을 위한 Select Procedure 생성
ALTER PROCEDURE USP_SelectBoard
	@P_START INT
	,@P_END INT
AS

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY BoardNo) AS ROWNUM
	, BoardNo
	, BoardTitle
	, BoardWriter
	, CONVERT (CHAR(10), CreatedDate, 23) AS CreatedDate
	, ViewCount
	FROM Boards) T1
WHERE ROWNUM between @P_START AND @P_END
ORDER BY BoardNo DESC

-- 실행
EXEC dbo.USP_SelectBoard 3, 7



