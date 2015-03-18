

CREATE PROCEDURE [dbo].[spReturnUserNames]
AS
SELECT UserName FROM tblUsers
GO



CREATE PROCEDURE [dbo].[spGetUserLog]
AS
SELECT UserName, LastLogin, FullName, IsAdmin FROM tblUsers

GO

CREATE PROCEDURE [dbo].[spResetPassword]
	@Admin NVARCHAR(50),
	@UserName NVARCHAR(50)
AS
	UPDATE tblUsers
	SET UserPassword = '227138210201486117020921476164717419415722817523321861'
	WHERE UserName = @UserName
GO

CREATE PROCEDURE [dbo].[spAddUser]
	@UserName NVARCHAR(50),
	@Password NVARCHAR(256),
	@FullName NVARCHAR(50),
	@IsAdmin BIT,
	@UserID INT OUTPUT
AS
	INSERT INTO tblUsers (UserName,
						 UserPassword,
						 FullName,
						 IsAdmin)
	VALUES (@UserName,
			@Password,
			@FullName,
			@IsAdmin)
	SELECT @UserID = @@IDENTITY


GO