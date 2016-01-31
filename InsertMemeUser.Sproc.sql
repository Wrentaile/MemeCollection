-- Create sproc to insert a new user
IF OBJECT_ID ( 'InsertMemeUser', 'P' ) IS NOT NULL
BEGIN
    DROP PROCEDURE InsertMemeUser;
END;
GO

CREATE PROCEDURE InsertMemeUser 
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
		DECLARE @Update AS TABLE
		(
			Response  NVARCHAR(4000)
		)

		INSERT INTO @Update EXECUTE UpdateMemeUser @NewUserName, @NewUserPassword, @NewSecurityQuestion,@NewSecurityAnswer;
		SET @Message = (SELECT TOP 1 Response FROM @Update);
	END
	ELSE
	BEGIN
		BEGIN TRY
			INSERT INTO MemeUsers (UserName, UserPassword, SecurityQuestion, SecurityAnswer)
				VALUES (@NewUserName, @NewUserPassword, @NewSecurityQuestion, @NewSecurityAnswer);

			SET @Message = 'User Created';
		END TRY
		BEGIN CATCH
			SELECT @Message = ERROR_MESSAGE();
		END CATCH
	END
	
	SELECT @Message AS Response;
END;
GO