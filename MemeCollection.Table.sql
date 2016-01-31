-- Create table to hold users
IF NOT EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeCollection')
BEGIN 
	CREATE TABLE MemeCollection
	(
		MemeCollectionID	INT IDENTITY(1,1),
		MemeUserID			INT NOT NULL,
		Title				NVARCHAR(50) NOT NULL,
		ImageURL			NVARCHAR(250) NOT NULL,
		MemeDescription		NVARCHAR(1000) NULL,
		MemeCategoryID		INT NOT NULL,
		CreationDate		DATETIME NOT NULL DEFAULT(GETUTCDATE()),
		ActiveRecord		BIT NOT NULL DEFAULT(1),
		PRIMARY KEY (MemeCollectionID)
	);
END
GO

-- Index the User ID
IF EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeCollection')
	AND NOT EXISTS (SELECT object_id FROM sys.indexes WHERE name = 'MemeCollectionMemeUserID')
BEGIN
	CREATE INDEX MemeCollectionMemeUserID ON MemeCollection (MemeUserID);
END
GO

-- Index the Category ID
IF EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeCollection')
	AND NOT EXISTS (SELECT object_id FROM sys.indexes WHERE name = 'MemeCollectionMemeCategoryID')
BEGIN
	CREATE INDEX MemeCollectionMemeCategoryID ON MemeCollection (MemeCategoryID);
END
GO
