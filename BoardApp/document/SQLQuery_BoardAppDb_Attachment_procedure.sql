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


--****************Attachment SelectByAttachmentNo Procedure************************
ALTER PROCEDURE USP_SelectAttachmentByAttachmentNo
	@P_AttachmentNo INT

AS
SELECT AttachmentPath 
FROM Attachment_TB 
WHERE AttachmentID = @P_AttachmentNo




--****************Attachment Delete Procedure************************
CREATE PROCEDURE USP_DeleteAttachment
	@P_BoardNo INT

AS

BEGIN TRAN
DELETE Attachment_TB WHERE BoardNo = @P_BoardNo
COMMIT TRAN


--****************Attachment Delete By AttachmentNo Procedure************************
ALTER PROCEDURE USP_DeleteAttachmentByAttachmentNo
	@P_AttachmentNo INT

AS
SET NOCOUNT OFF

BEGIN TRAN
DELETE Attachment_TB WHERE AttachmentID = @P_AttachmentNo
COMMIT TRAN

EXEC USP_DeleteAttachmentByAttachmentNo 23