-- DB ���� (local)
-- ����! Azure DB ������ ���� ��� ������ ���ؼ� portal���� �ϱ�
IF DB_ID (N'BoardAppDb') IS NOT NULL  
DROP DATABASE BoardAppDb;  
GO  
CREATE DATABASE BoardAppDb  
COLLATE Korean_Wansung_CI_AS ;  
GO


--===========================���̺� ����==============================-
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
ALTER TABLE Boards ALTER COLUMN BoardTitle VARCHAR(255) NOT NULL
ALTER TABLE Boards ALTER COLUMN BoardWriter VARCHAR(50) NOT NULL



--���(Comment) ���̺� ����
CREATE TABLE Comments_TB (
	CommentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
	, OriginCommentNo INT NOT NULL DEFAULT 0
	, ParentCommentNo INT NOT NULL DEFAULT 0
	, CommentLevel INT NOT NULL DEFAULT 0
	, CommentOrder INT NOT NULL DEFAULT 0
	, CommentWriter VARCHAR(50) NOT NULL
	, CommentContent TEXT NOT NULL
	, CommentCreatedDate DATETIME NOT NULL
	, CommentFlag INT NOT NULL DEFAULT 0
	, CommentPassword VARBINARY(100) NOT NULL DEFAULT 1111
	, FinalFlag INT NOT NULL DEFAULT 0
)

-- ��������
ALTER TABLE Comments_TB ADD CONSTRAINT DF_CommentOrder DEFAULT 0 FOR OriginCommentNo
ALTER TABLE Comments_TB DROP CONSTRAINT DF__Comments___Comme__60A75C0F
ALTER TABLE Comments_TB ADD CONSTRAINT DF_CommentsLevel DEFAULT 0 FOR CommentLevel
ALTER TABLE Comments_TB ADD CommentFlag INT NOT NULL DEFAULT 0
ALTER TABLE Comments_TB ADD ParentCommentNo INT NOT NULL DEFAULT 0
--ALTER TABLE Comments_TB ADD CommentPassword VARBINARY(MAX) NOT NULL DEFAULT 1111
ALTER TABLE Comments_TB ADD FinalFlag INT NOT NULL DEFAULT 0

ALTER TABLE Comments_TB ALTER COLUMN CommentPassword VARBINARY(100)


--File ���̺� ����
CREATE TABLE Files_TB (
	 FileID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, FileSaveName VARCHAR(255) NOT NULL
	, FilePath VARCHAR(255) NOT NULL
	, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
	)


--DB�� Contents Binary�� �����ϴ� File���̺� ����
CREATE TABLE AttachedFiles_TB (
	AttachedFileID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, AttachedFileName VARCHAR(255) NOT NULL
	, AttachedFileContent VARBINARY NOT NULL
	, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
)

ALTER TABLE AttachedFiles_TB ALTER COLUMN AttachedFileContent VARBINARY(MAX) NOT NULL

--Multi Attachment �����ϴ� File ���̺�
CREATE TABLE Attachment_TB (
AttachmentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
, AttachmentPath VARCHAR(255) NOT NULL
, BoardNo INT NOT NULL FOREIGN KEY REFERENCES Boards(BoardNo)
)