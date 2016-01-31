-- Create sproc to update a user
IF OBJECT_ID ( 'UpdateMemeUser', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE UpdateMemeUser;
END;
GO

CREATE PROCEDURE UpdateMemeUser 
(	@NewUserName			AS NVARCHAR(50),
	@NewUserPassword		AS NVARCHAR(50),
	@NewSecurityQuestion	AS SMALLINT,
	@NewSecurityAnswer		AS NVARCHAR(50)
)
AS
BEGIN
	DECLARE @Message		AS NVARCHAR(4000)

	IF EXISTS (SELECT MemeUserID FROM MemeUsers WHERE UserName = @NewUserName)
	BEGIN
		BEGIN TRY
			UPDATE MemeUsers SET UserPassword = @NewUserPassword,
								 SecurityQuestion = @NewSecurityQuestion,
								 SecurityAnswer = @NewSecurityAnswer,
								 ActiveRecord = 0
				WHERE UserName = @NewUserName;
	
			SET @Message = 'User updated.';
		END TRY
		BEGIN CATCH
			SELECT @Message = ERROR_MESSAGE();
		END CATCH
	END
	ELSE
	BEGIN
		SET @Message = 'User not found.';
	END

	SELECT @Message AS Response;
END
GO