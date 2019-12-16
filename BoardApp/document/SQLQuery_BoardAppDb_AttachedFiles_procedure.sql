--****************************************AttachedFile Procedure***************************************


--****************AttachedFIle Add Procedure************************

ALTER PROCEDURE USP_InsertAttachedFile
	@P_BoardNo INT
	, @P_AttachedFileName VARCHAR(255)
	, @P_AttachedFileContent VARBINARY
	
AS

BEGIN TRAN
INSERT INTO AttachedFiles_TB
	(BoardNo, AttachedFileName, AttachedFileContent)
VALUES (@P_BoardNo, @P_AttachedFileName, @P_AttachedFileContent)

COMMIT TRAN

--테스트
EXEC USP_InsertAttachedFile 72, 'testFile', 010201


--****************AttachedFIle Detail Procedure************************
ALTER PROCEDURE USP_SelectAttachedFileContentWithBoardNo
	@P_BoardNo INT

	AS

SELECT AttachedFileName, AttachedFileContent
FROM AttachedFiles_TB
WHERE BoardNo = @P_BoardNo

--테스트
EXEC USP_SelectAttachedFileContentWithBoardNo 72