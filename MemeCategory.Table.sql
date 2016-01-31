-- Create table to hold users
IF NOT EXISTS (SELECT object_id FROM sys.tables WHERE name = 'MemeCategory')
BEGIN 
	CREATE TABLE MemeCategory
	(
		MemeCategoryID		INT IDENTITY(1,1),
		CategoryName		NVARCHAR(50) NOT NULL,
		CreationDate		DATETIME NOT NULL DEFAULT(GETUTCDATE()),
		ActiveRecord		BIT NOT NULL DEFAULT(1),
		PRIMARY KEY (MemeCategoryID)
	);
END
GO
