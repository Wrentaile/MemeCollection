-- Create table to hold users
IF NOT EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeUsers')
BEGIN 
	CREATE TABLE MemeUsers
	(
		MemeUserID			INT IDENTITY(1,1),
		UserName			NVARCHAR(50) NOT NULL,
		UserPassword		NVARCHAR(50) NOT NULL,
		SecurityQuestion	SMALLINT NOT NULL,
		SecurityAnswer		NVARCHAR(50) NOT NULL,
		CreationDate		DATETIME NOT NULL DEFAULT(GETUTCDATE()),
		ActiveRecord		BIT NOT NULL DEFAULT(1),
		PRIMARY KEY (MemeUserID)
	);
END
GO

-- Index the user name to make it easier to find the password and ID
IF EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeUsers')
	AND NOT EXISTS (SELECT object_id FROM sys.indexes WHERE name = 'MemeUserNameIndex')
BEGIN
	CREATE UNIQUE INDEX MemeUserNameIndex ON MemeUsers (UserName);
END
GO