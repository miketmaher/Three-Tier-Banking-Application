USE [DBSCreditUnion]
GO

/****** Object:  Table [dbo].[tblAccounts]    Script Date: 12/03/2015 12:14:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAccounts](
	[AccountNumber] [int] IDENTITY(10000000,1) NOT NULL,
	[AccountType] [nvarchar](50) NOT NULL,
	[SortCode] [int] NOT NULL,
	[Balance] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OverDraftLimit] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblAccounts]  WITH CHECK ADD  CONSTRAINT [FK_CustomersAccount] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[tblCustomers] ([CustomerID])
GO

ALTER TABLE [dbo].[tblAccounts] CHECK CONSTRAINT [FK_CustomersAccount]
GO


-----------------------------------------------------------


USE [DBSCreditUnion]
GO

/****** Object:  Table [dbo].[tblCustomers]    Script Date: 12/03/2015 12:15:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCustomers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[AddressLine1] [nvarchar](50) NOT NULL,
	[AddressLine2] [nvarchar](50) NULL,
	[City] [nvarchar](50) NOT NULL,
	[County] [nvarchar](50) NOT NULL,
	[OnlineCustomer] [bit] NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[CustomerPassword] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


------------------------------------------------------------------------

USE [DBSCreditUnion]
GO

/****** Object:  Table [dbo].[tblTransactionTable]    Script Date: 12/03/2015 12:16:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTransactionTable](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionType] [nvarchar](50) NOT NULL,
	[TransactionAmount] [int] NOT NULL,
	[TransactionDateTime] [datetime] NOT NULL,
	[TransactionReference] [nvarchar](1) NOT NULL,
	[TransactionAccountNumber] [int] NOT NULL,
	[DestinationAccountNumber] [int] NULL,
	[TransactionDescription] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


------------------------------------------------------------------------------


USE [DBSCreditUnion]
GO

/****** Object:  Table [dbo].[tblUsers]    Script Date: 12/03/2015 12:16:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblUsers](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[UserPassword] [nvarchar](256) NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[LastLogin] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


