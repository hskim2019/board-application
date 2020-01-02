--****************************************Attachment Procedure***************************************


--****************Attachment Add Procedure************************

CREATE PROCEDURE USP_InsertAttachment
	@P_BoardNo INT
	, @P_AttachmentPath VARCHAR(255)
	
AS
SET NOCOUNT OFF

BEGIN TRAN
INSERT INTO Attachment_TB
	(BoardNo, AttachmentPath)
VALUES (@P_BoardNo, @P_AttachmentPath)

COMMIT TRAN



--****************Attachment Select Procedure************************
CREATE PROCEDURE USP_SelectAttachment
	@P_BoardNo INT

	AS

SELECT AttachmentID, AttachmentPath
FROM Attachment_TB
WHERE BoardNo = @P_BoardNo


--****************Attachment Select Procedure************************
ALTER PROCEDURE USP_CountAttachmentByBoardNo
	@P_BoardNo INT
	, @AttachmentCount INT OUTPUT

AS
SELECT @AttachmentCount = COUNT(AttachmentID)
FROM Attachment_TB
WHERE BoardNo = @P_BoardNo

PRINT @AttachmentCount
RETURN @AttachmentCount


--****************Attachment SelectByBoardNo Procedure************************
ALTER PROCEDURE USP_SelectAttachmentByAttachmentNo
	@P_AttachmentNo INT

AS
SELECT AttachmentPath 
FROM Attachment_TB 
WHERE AttachmentID = @P_AttachmentNo




--****************AttachedFIle Delete Procedure************************
CREATE PROCEDURE USP_DeleteAttachment
	@P_BoardNo INT

AS

BEGIN TRAN
DELETE Attachment_TB WHERE BoardNo = @P_BoardNo
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
