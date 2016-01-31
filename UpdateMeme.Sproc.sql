-- Create sproc to insert a new user
IF OBJECT_ID ( 'UpdateMeme', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE UpdateMeme;
END;
GO

CREATE PROCEDURE UpdateMeme 
(	@MemeCollectionID	INT,
	@Title				NVARCHAR(50),
	@MemeDescription	NVARCHAR(1000),
	@MemeCategoryID		INT
)
AS
BEGIN
	UPDATE MemeCollection
		SET Title = @Title,
			MemeDescription = @MemeDescription,
			MemeCategoryID = @MemeCategoryID,
			ActiveRecord = 1
		WHERE MemeCollectionID = @MemeCollectionID
END;
GO
		