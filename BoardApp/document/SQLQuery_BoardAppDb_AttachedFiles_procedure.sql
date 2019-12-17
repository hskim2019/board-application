--****************************************AttachedFile Procedure***************************************


--****************AttachedFIle Add Procedure************************

ALTER PROCEDURE USP_InsertAttachedFile
	@P_BoardNo INT
	, @P_AttachedFileName VARCHAR(255)
	, @P_AttachedFileContent VARBINARY(MAX)
	
AS

BEGIN TRAN
INSERT INTO AttachedFiles_TB
	(BoardNo, AttachedFileName, AttachedFileContent)
VALUES (@P_BoardNo, @P_AttachedFileName, @P_AttachedFileContent)

COMMIT TRAN

--테스트
EXEC USP_InsertAttachedFile 195, 'test.txt', 101011000000100010010101001000


--****************AttachedFIle Detail Procedure************************
CREATE PROCEDURE USP_SelectAttachedFileContentWithBoardNo
	@P_BoardNo INT

	AS

SELECT AttachedFileName, AttachedFileContent
FROM AttachedFiles_TB
WHERE BoardNo = @P_BoardNo

--테스트
EXEC USP_SelectAttachedFileContentWithBoardNo 177

--****************AttachedFIle Delete Procedure************************
CREATE PROCEDURE USP_DeleteAttachedFile
	@P_BoardNo INT

AS

BEGIN TRAN
DELETE AttachedFiles_TB WHERE BoardNo = @P_BoardNo
COMMIT TRAN

--테스트
EXEC USP_DeleteAttachedFile 177

--****************AttachedFIle Update Procedure************************
ALTER PROCEDURE USP_UpdateAttachedFile
	@P_BoardNo INT
	, @P_AttachedFileName VARCHAR(255)
	, @P_AttachedFileContent VARBINARY(MAX)

AS 

DECLARE @check INT

BEGIN TRAN

SELECT @check = BoardNo from AttachedFiles_TB WHERE BoardNo = @P_BoardNo
PRINT @check PRINT'개'

IF(@check = 0)
	BEGIN 
	PRINT 'A'
	INSERT INTO AttachedFiles_TB
		(BoardNo, AttachedFileName, AttachedFileContent)
	VALUES (@P_BoardNo, @P_AttachedFileName, @P_AttachedFileContent)
	END
ELSE
	BEGIN
	PRINT 'B'
	UPDATE AttachedFiles_TB
	SET AttachedFileName = @P_AttachedFileName
	, AttachedFileContent = @P_AttachedFileContent
	WHERE BoardNo = @P_BoardNo 
	END
COMMIT TRAN

EXEC USP_UpdateAttachedFile 195, 'a', 0101

