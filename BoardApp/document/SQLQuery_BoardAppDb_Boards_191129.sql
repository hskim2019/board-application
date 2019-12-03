-- DB ���� (local)
IF DB_ID (N'BoardAppDb') IS NOT NULL  
DROP DATABASE BoardAppDb;  
GO  
CREATE DATABASE BoardAppDb  
COLLATE Korean_Wansung_CI_AS ;  
GO

-- Board ���̺� ����
CREATE TABLE Boards (
	 BoardNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY -- �ڵ����� (������ ���ڰ�Seed, ������ ���ڰ�)
	,BoardTitle VARCHAR(20) NOT NULL
	, BoardContent TEXT NOT NULL
	, BoardWriter VARCHAR(10) NOT NULL
	, CreatedDate DATETIME NOT NULL
	, ViewCount INT NOT NULL DEFAULT 0
)

-- ��������
-- BoardTitle VARCHAR(20) => VARCHAR(40)
ALTER TABLE Boards ALTER COLUMN BoardTitle VARCHAR(40) NOT NULL


-- Select Procedure ����
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

-- ����
EXEC dbo.USP_SelectBoardList


-- Detail Procedure ����/����
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


-- ����
  EXEC dbo.USP_SelectBoardListByNo 1


-- Add Procedure ����/����
ALTER PROCEDURE USP_InsertBoard
	@P_BoardTitle VARCHAR(40)
	, @P_BoardContent TEXT
	, @P_BoardWriter VARCHAR(20)

AS


INSERT INTO Boards
	(BoardTitle, BoardContent, BoardWriter, CreatedDate)
VALUES (@P_BoardTitle, @P_BoardContent, @P_BoardWriter, GETDATE())

SELECT SCOPE_IDENTITY() AS SEQ



-- ����
EXEC USP_InsertBoard 'identity', 'test' ,'identity'



select * from Boards






-- Delete Procedure ����
ALTER PROCEDURE USP_DeleteBoard
	@P_BoardNo INT

AS
DELETE Boards WHERE BoardNo = @P_BoardNo

-- ����
EXEC USP_DeleteBoard 1


--UPDATE PROCEDURE ����
CREATE PROCEDURE USP_UpdateBoard
	@P_BoardNo INT
	, @P_BoardTitle VARCHAR(40)
	, @P_BoardContent TEXT

AS

UPDATE Boards
	SET BoardTitle = @P_BoardTitle
	, BoardContent = @P_BoardContent
	, CreatedDate = GETDATE()
	WHERE BoardNo = @P_BoardNo 

-- ����
EXEC USP_UpdateBoard 13, '�������� �Դϴ�', '���� �����Դϴ�'

select * from Boards