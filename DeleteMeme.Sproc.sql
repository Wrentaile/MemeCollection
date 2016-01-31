-- Create sproc to insert a new user
IF OBJECT_ID ( 'DeleteMeme', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE DeleteMeme;
END;
GO

CREATE PROCEDURE DeleteMeme 
(	@MemeCollectionID	INT
)
AS
BEGIN
	UPDATE MemeCollection
		SET ActiveRecord = 0
		WHERE MemeCollectionID = @MemeCollectionID
END;
GO
		