
-- ======================Board ���ν���=================================

-- ********************************* Select Procedure ����*************************
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



---- ����
--EXEC dbo.USP_SelectBoardList





-- Detail Procedure ����/����
ALTER PROCEDURE USP_SelectBoardListByNo
	@P_BoardNo INT

AS 

SET NOCOUNT ON

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
FROM Boards AS A
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



-- ����
EXEC USP_InsertBoard 'identity', 'test' ,'identity'



select * from Boards






--**************************************Delete Procedure ����*********************************
ALTER PROCEDURE USP_DeleteBoard
	@P_BoardNo INT

AS
DELETE Boards WHERE BoardNo = @P_BoardNo

-- ����
EXEC USP_DeleteBoard 1


--*************************************UPDATE PROCEDURE ����************************************
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

-- ����
EXEC USP_UpdateBoard 13, '�������� �Դϴ�', '���� �����Դϴ�'

select * from Boards


--*****************************************�Խù� ���� �������� Procedure***************************
ALTER PROCEDURE USP_SelectRowCount
@count int OUTPUT
AS

SELECT DISTINCT @count = MAX(idx.ROWS)
FROM SYSINDEXES AS idx
INNER JOIN SYSOBJECTS AS obj
ON (idx.id = obj.id)
WHERE (obj.type = 'U') AND (obj.name = 'Boards')
PRINT @count

-- ����
exec USP_SelectRowCount 1



--*****************************Paging�� ���� Select Procedure ����*************************
ALTER PROCEDURE USP_SelectBoard
	@P_START INT
	,@P_END INT
AS

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY BoardNo DESC) AS ROWNUM
	, A.BoardNo
	, A.BoardTitle
	, A.BoardWriter
	, CONVERT (CHAR(10), A.CreatedDate, 23) AS CreatedDate
	, A.ViewCount
	, (SELECT COUNT(*) FROM Comments_TB WHERE BoardNo = A.BoardNo AND FinalFlag = 0) AS CommentCTN
	
	FROM Boards AS A) T1
WHERE ROWNUM between @P_START AND @P_END
ORDER BY BoardNo DESC


-- ����
EXEC dbo.USP_SelectBoard 3, 7



EXEC USP_SelectCommentByBoardNo 150
SELECT @@ROWCOUNT