-- Create sproc to insert a new user
IF OBJECT_ID ( 'InsertMeme', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE InsertMeme;
END;
GO

CREATE PROCEDURE InsertMeme 
(	@MemeUserID			INT,
	@Title				NVARCHAR(50),
	@ImageURL			NVARCHAR(250),
	@MemeDescription	NVARCHAR(1000),
	@MemeCategoryID		INT
)
AS
BEGIN
	IF EXISTS (SELECT MemeCollectionID FROM MemeCollection WHERE MemeUserID = @MemeUserID AND ImageURL = @ImageURL)
	BEGIN
		DECLARE @MemeCollectionID	AS INT
		SELECT @MemeCollectionID = MemeCollectionID FROM MemeCollection WHERE MemeUserID = @MemeUserID AND ImageURL = @ImageURL
		EXECUTE UpdateMeme @MemeCollectionID, @Title, @MemeDescription, @MemeCategoryID;		
	END
	ELSE
	BEGIN
		INSERT INTO MemeCollection (MemeUserID, Title, ImageURL, MemeDescription, MemeCategoryID)
			VALUES (@MemeUserID, @Title, @ImageURL, @MemeDescription, @MemeCategoryID);
	END
END;
GO