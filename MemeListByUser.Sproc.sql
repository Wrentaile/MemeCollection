IF OBJECT_ID ( 'MemeListByUser', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE MemeListByUser;
END;
GO

CREATE PROCEDURE MemeListByUser (
	@UserID			AS INT
)
AS
BEGIN
	SELECT	C.MemeCollectionID, C.MemeUserID, C.Title, C.ImageURL, C.MemeDescription, C.MemeCategoryID,
			G.CategoryName AS MemeCategory
		FROM MemeCollection AS C
			INNER JOIN MemeCategory AS G				ON C.MemeCategoryID = G.MemeCategoryID
		WHERE C.MemeUserID = @UserID AND C.ActiveRecord <> 0;
END