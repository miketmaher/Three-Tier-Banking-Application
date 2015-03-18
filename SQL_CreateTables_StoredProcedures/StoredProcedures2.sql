CREATE PROCEDURE spRemoveUser
	@UserName NVARCHAR(50)
AS
	DELETE FROM tblUsers
	WHERE UserName = @UserName
GO