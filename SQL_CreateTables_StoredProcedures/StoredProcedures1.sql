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

------------------------------------------------------------

CREATE PROCEDURE [dbo].[spChangePassword]
	@OldPassword NVARCHAR(256),
	@NewPassword NVARCHAR(256)
AS
	UPDATE tblUsers
	SET UserPassword = @NewPassword
	WHERE UserPassword = @OldPassword

GO

------------------------------------------------------------

CREATE PROCEDURE [dbo].[spCreateAccount]
	@AccountType NVARCHAR(50),
	@SortCode INT,
	@InitialBalance INT,
	@OverDraft INT,
	@CustomerID INT,
	@AccountNumber INT OUTPUT
AS
	INSERT INTO tblAccounts (AccountType,
							 SortCode,
							 Balance,
							 CustomerID,
							 OverDraftLimit)
	VALUES (@AccountType,
			@SortCode,
			@InitialBalance,
			@CustomerID,
			@OverDraft)
	SELECT @AccountNumber = @@IDENTITY
GO


------------------------------------------------------------

CREATE PROCEDURE [dbo].[spCreateCustomer]
	@FirstName NVARCHAR(50),
	@Surname NVARCHAR(50),
	@Email NVARCHAR(50),
	@Phone NVARCHAR(50),
	@AddressLine1 NVARCHAR(50),
	@AddressLine2 NVARCHAR(50),
	@City NVARCHAR(50),
	@County NVARCHAR(50),
	@CustomerID INT OUTPUT,
	@OnlineCustomer BIT
AS
	INSERT INTO tblCustomers (FirstName,
							  Surname,
							  Email,
							  Phone,
							  AddressLine1,
							  AddressLine2,
							  City,
							  County,
							  OnlineCustomer)
	VALUES (@FirstName,
			@Surname,
			@Email,
			@Phone,
			@AddressLine1,
			@AddressLine2,
			@City,
			@County,
			@OnlineCustomer)
	SELECT @CustomerID = /*@@IDENTITY*/ CustomerID FROM tblCustomers

GO


--------------------------------------------------------------------------


CREATE PROC [dbo].[spDeposit]
@CustomerID INTEGER,
@DepositAmount INTEGER,
@NewBalance INTEGER,
@Balance INTEGER
AS
UPDATE tblAccounts
SET Balance = @Balance + @DepositAmount
WHERE CustomerID = @CustomerID

GO


--------------------------------------------------------------------------


SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spDepositAmount]
@CustomerID INTEGER,
@DepositAmount INTEGER,
@NewBalance INTEGER,
@Balance INTEGER
AS
UPDATE tblAccounts
SET Balance = @Balance + @DepositAmount
WHERE CustomerID = @CustomerID

GO


---------------------------------------------------------------------------


CREATE PROC [dbo].[spDepositTransaction]
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@DepositTransactionAmount INT,
@TransactionTime DATETIME,
@DepositTransactionReference NVARCHAR(50),
@AccountNumber INT,
@TransactionDepositDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblDepositTransactions
(
TransactionType, 
DepositTransactionAmount,
TransactionTime,
DepositTransactionReference,
AccountNumber,
TransactionDepositDescription
)
VALUES
(
@TransactionType,
@DepositTransactionAmount,
@TransactionTime,
@DepositTransactionReference,
@AccountNumber,
@TransactionDepositDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END

GO


--------------------------------------------------------------------


CREATE PROC [dbo].[spGetAccInformation]
@AccountNumber INTEGER
AS
BEGIN
SET NOCOUNT ON
SELECT
a.AccountType,
a.Balance,
a.OverDraftLimit
FROM
tblAccounts a
WHERE
a.AccountNumber = @AccountNumber
END
GO


------------------------------------------------------------------------


CREATE PROC [dbo].[spGetAccountDetails]
@CustomerID INTEGER
AS
BEGIN
SET NOCOUNT ON
SELECT
a.FirstName,
a.Surname,
a.Email,
a.Phone,
a.AddressLine1,
a.AddressLine2,
a.City,
a.County
FROM
tblCustomers a
WHERE
a.CustomerID = @CustomerID
END

GO


--------------------------------------------------------------------------


CREATE PROC [dbo].[spGetCustomerInformation]
@CustomerID INTEGER
AS 
BEGIN
SET NOCOUNT ON
SELECT
a.Firstname,
a.Surname,
a.Email,
a.Phone,
a.AddressLine1,
a.AddressLine2,
a.City,
County
FROM 
tblCustomers a
WHERE
a.CustomerID = @CustomerID
END

GO


----------------------------------------------------------------------


CREATE PROC [dbo].[spGetDetailsForMainGrid]
AS
BEGIN
SELECT 
AccountNumber as [Account Number],
FirstName as [First Name],
Surname,
AddressLine1 as [Address],
AddressLine2 as [Address],
City,
County,
c.CustomerID
FROM
tblCustomers c
INNER JOIN tblAccounts
ON c.CustomerID = tblAccounts.CustomerID
END

GO


------------------------------------------------------------------------


CREATE PROC [dbo].[spLoadViewCustomer]
@AccountNumber INTEGER
AS 
BEGIN
SET NOCOUNT ON
SELECT Firstname, Surname, Email, Phone, AddressLine1, AddressLine2, City, County, AccountType, Balance, OverdraftLimit, AccountNumber
FROM
tblCustomers
INNER JOIN
tblAccounts
ON
tblCustomers.CustomerID = tblAccounts.CustomerID
WHERE
@AccountNumber = AccountNumber 
END
GO


------------------------------------------------------------

CREATE PROCEDURE [dbo].[spRecordTransaction]
	@TransactionType NVARCHAR(50),
	@Amount INT,
	@TransactionDate DATETIME,
	@Description NVARCHAR(256),
	@Reference NVARCHAR(50),
	@DestinationAccount INT,
	@DestinationSortCode INT,
	@AccountNumber INT
AS
	INSERT INTO tblTransactions(TransactionType,
								Amount,
								TransactionDate,
								TransactionDescription,
								TransactionReference,
								DestinationAccount,
								DestinationSortCode,
								AccountNumber)
	VALUES (@TransactionType,
			@Amount,
			@TransactionDate,
			@Description,
			@Reference,
			@DestinationAccount,
			@DestinationSortCode,
			@AccountNumber)
	IF @TransactionType = 'Deposit'
	UPDATE tblAccounts
	SET Balance = Balance + @Amount

	ELSE IF @TransactionType = 'Withdrawl'
	UPDATE tblAccounts
	SET Balance = Balance - @Amount

	ELSE IF @TransactionType = 'Transfer'
	UPDATE tblAccounts
	SET Balance = Balance - @Amount
	WHERE AccountNumber = @AccountNumber
	UPDATE tblAccounts
	SET Balance = Balance + @Amount
	WHERE AccountNumber = @DestinationAccount

GO


------------------------------------------------------------------


CREATE PROC [dbo].[spSearch]
@AccountNumber INTEGER
AS
BEGIN
SET NOCOUNT ON
SELECT
a.AccountNumber,
a.Balance
FROM
tblAccounts a
WHERE
a.AccountNumber = @AccountNumber
END

GO


--------------------------------------------------------------------


CREATE PROC [dbo].[spTransactionRecord]
(
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@TransactionAmount INT,
@TransactionDateTime DATETIME,
@TransactionReference NVARCHAR,
@TransactionAccountNumber INT,
@DestinationAccountNumber INT,
@TransactionDescription NVARCHAR(100)
)
AS
BEGIN
INSERT INTO tblTransactionTable
VALUES
(
@TransactionType,
@TransactionAmount,
@TransactionDateTime,
@TransactionReference,
@TransactionAccountNumber,
@DestinationAccountNumber,
@TransactionDescription
)
SELECT
@TransactionID = TransactionID FROM tblTransactionTable
END

GO


---------------------------------------------------------------------


CREATE PROC [dbo].[spTransferTransaction]
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@TransferTransactionAmount INT,
@TransactionTime DATETIME,
@TransferTransactionReference NVARCHAR(50),
@AccountNumber INT,
@DestinationAccountNumber INT,
@TransactionTransferDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblTransferTransactions
(
TransactionType, 
TransferTransactionAmount,
TransactionTime,
TransferTransactionReference,
AccountNumber,
DestinationAccountNumber,
TransactionTransferDescription
)
VALUES
(
@TransactionType,
@TransferTransactionAmount,
@TransactionTime,
@TransferTransactionReference,
@AccountNumber,
@DestinationAccountNumber,
@TransactionTransferDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END


GO


-----------------------------------------------------------------------------


CREATE PROC [dbo].[spUpdateBalance]
@AccountNumber INTEGER,
@Balance INTEGER
AS
BEGIN
SET NOCOUNT ON
UPDATE
tblAccounts
SET Balance = @Balance
WHERE
AccountNumber = @AccountNumber
END

GO


--------------------------------------------------------------------------------


CREATE PROC [dbo].[spUpdateCustomer]
@FirstName NVARCHAR(50),
@Surname NVARCHAR(50),
@Email NVARCHAR(50),
@Phone NVARCHAR(50),
@AddressLine1 NVARCHAR(50),
@AddressLine2 NVARCHAR(50),
@City NVARCHAR(50),
@County NVARCHAR(50),
@CustomerID INT
AS
BEGIN
UPDATE tblCustomers
SET
FirstName = @FirstName,
Surname = @Surname,
Email = @Email,
Phone = @Phone,
AddressLine1 = @AddressLine1,
AddressLine2 = @AddressLine2,
City = @City,
County = @County
WHERE CustomerID = @CustomerID
END

GO


----------------------------------------------------------------------------


CREATE PROC [dbo].[spUpdateFromTransfer]
@AccountNumber INTEGER,
@Balance INTEGER
AS
BEGIN
SET NOCOUNT ON
UPDATE
tblAccounts
SET Balance = @Balance
WHERE
AccountNumber = @AccountNumber
END


GO



-----------------------------------------------------------------------------


CREATE PROC [dbo].[spUpdateToTransfer]
@AccountNumber INTEGER,
@Balance INTEGER
AS
BEGIN
SET NOCOUNT ON
UPDATE
tblAccounts
SET Balance = @Balance
WHERE
AccountNumber = @AccountNumber
END


GO


----------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[spUserLogin]
	@UserName NVARCHAR(50),
	@Password NVARCHAR(256),
	@LastLogin DATETIME,
	@IsAdmin BIT OUTPUT
AS
	UPDATE tblUsers
	SET LastLogin = @LastLogin
	WHERE UserName = @UserName AND UserPassword = @Password
	SELECT @IsAdmin = IsAdmin FROM tblUsers
	WHERE UserName = @UserName AND UserPassword = @Password

GO


-----------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[spViewTransactions]
	@TransactionAccountNumber INT
AS
	SELECT 
	TransactionAccountNumber as [Account Number],
	TransactionID as [Transaction ID], 
	TransactionType as [Transaction Type],
	TransactionDateTime as [Date], 
	TransactionAmount as Amount, 
	TransactionDescription as [Description]
	FROM tblTransactionTable
	WHERE TransactionAccountNumber = @TransactionAccountNumber

GO


------------------------------------------------------------------------------------


CREATE PROC [dbo].[spWithdrawTransaction]
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@WithdrawTransactionAmount INT,
@TransactionTime DATETIME,
@WithdrawTransactionReference NVARCHAR(50),
@AccountNumber INT,
@TransactionWithdrawDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblWithdrawTransactions
(
TransactionType, 
WithdrawTransactionAmount,
TransactionTime,
WithdrawTransactionReference,
AccountNumber,
TransactionWithdrawDescription
)
VALUES
(
@TransactionType,
@WithdrawTransactionAmount,
@TransactionTime,
@WithdrawTransactionReference,
@AccountNumber,
@TransactionWithdrawDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END


GO



