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



--****************AttachedFIle Detail Procedure************************
ALTER PROCEDURE USP_SelectAttachedFileContentWithBoardNo
	@P_BoardNo INT

	AS

SELECT AttachedFileName, AttachedFileContent
FROM AttachedFiles_TB
WHERE BoardNo = @P_BoardNo


--****************AttachedFIle Delete Procedure************************
ALTER PROCEDURE USP_DeleteAttachedFile
	@P_BoardNo INT

AS

BEGIN TRAN
DELETE AttachedFiles_TB WHERE BoardNo = @P_BoardNo
COMMIT TRAN


--****************AttachedFIle Update Procedure************************
ALTER PROCEDURE USP_UpdateAttachedFile
	@P_BoardNo INT
	, @P_AttachedFileName VARCHAR(255)
	, @P_AttachedFileContent VARBINARY(MAX)

AS 
SET NOCOUNT OFF
DECLARE @check INT

BEGIN TRAN

SELECT BoardNo from AttachedFiles_TB WHERE BoardNo = @P_BoardNo
SET @check = @@ROWCOUNT PRINT'°³'

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

EXEC USP_UpdateAttachedFile 88, 'test', 01020102
