USE [master]
GO
/****** Object:  Database [Assets]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE DATABASE [Assets]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'E-Unity', FILENAME = N'D:\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\Assets.mdf' , SIZE = 8064KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'E-Unity_log', FILENAME = N'D:\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\Assets_log.ldf' , SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Assets] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Assets].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Assets] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Assets] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Assets] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Assets] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Assets] SET ARITHABORT OFF 
GO
ALTER DATABASE [Assets] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Assets] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Assets] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Assets] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Assets] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Assets] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Assets] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Assets] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Assets] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Assets] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Assets] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Assets] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Assets] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Assets] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Assets] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Assets] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Assets] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Assets] SET RECOVERY FULL 
GO
ALTER DATABASE [Assets] SET  MULTI_USER 
GO
ALTER DATABASE [Assets] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Assets] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Assets] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Assets] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Assets] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Assets] SET QUERY_STORE = OFF
GO
USE [Assets]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Assets]
GO
/****** Object:  User [saAsset]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE USER [saAsset] FOR LOGIN [saAsset] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [saAsset]
GO
/****** Object:  Schema [AT]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE SCHEMA [AT]
GO
/****** Object:  Schema [ATSET]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE SCHEMA [ATSET]
GO
/****** Object:  Schema [GSET]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE SCHEMA [GSET]
GO
/****** Object:  Schema [GTBL]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE SCHEMA [GTBL]
GO
/****** Object:  Schema [SEC]    Script Date: 11/05/2026 1:22:38 PM ******/
CREATE SCHEMA [SEC]
GO
/****** Object:  UserDefinedFunction [AT].[fnLastInventoryDateByItem]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [AT].[fnLastInventoryDateByItem]
(
	@AssetID int
)
RETURNS Date
AS
BEGIN
	-- Declare the return variable here
	DECLARE @LastInventoryDate Date

	-- Add the T-SQL statements to compute the return value here
	SELECT Top 1 @LastInventoryDate = InventoryStartDate FROM AT.Inventories WHERE InventoryID In (SELECT Top 1 InventoryID From AT.InventoriesDetails WHERE AssetID=@AssetID ORDER BY InventoryID Desc)

	-- Return the result of the function
	RETURN @LastInventoryDate

END


GO
/****** Object:  Table [AT].[Assets]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Assets](
	[AssetID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [smallint] NOT NULL,
	[AssetCode] [nvarchar](15) NOT NULL,
	[AssetImage] [image] NULL,
	[AssetDesc] [nvarchar](50) NOT NULL,
	[LocationID] [smallint] NOT NULL,
	[LocDetailID] [smallint] NOT NULL,
	[GroupID] [smallint] NOT NULL,
	[CategoryID] [smallint] NOT NULL,
	[Donation] [bit] NOT NULL,
	[ContactID] [int] NULL,
	[PurchaseOrderNo] [nvarchar](10) NULL,
	[PurchaseDate] [date] NULL,
	[PurchasePrice] [float] NOT NULL,
	[PurchaseCurCode] [char](3) NOT NULL,
	[InServiceDate] [date] NOT NULL,
	[InvoiceNo] [nvarchar](10) NULL,
	[InvoiceDate] [date] NULL,
	[AccountingEntryDate] [date] NULL,
	[AccountingEntryJVNo] [nvarchar](10) NULL,
	[BarcodeNumber] [nvarchar](20) NULL,
	[SerialNumber] [nvarchar](50) NULL,
	[StatusID] [tinyint] NULL,
	[StatusDate] [date] NULL,
	[Remark] [nvarchar](100) NULL,
	[InstalledAt] [nvarchar](50) NULL,
 CONSTRAINT [PK_Assets] PRIMARY KEY CLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Assets] UNIQUE NONCLUSTERED 
(
	[AssetCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AT].[Attachments]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Attachments](
	[AttID] [int] IDENTITY(1,1) NOT NULL,
	[AssetID] [int] NOT NULL,
	[Attachment] [varbinary](max) NOT NULL,
	[AttDesc] [nvarchar](50) NOT NULL,
	[AttFileName] [nvarchar](255) NOT NULL,
	[AttFileExt] [nchar](5) NOT NULL,
	[Remark] [nvarchar](100) NULL,
 CONSTRAINT [PK_Attachments] PRIMARY KEY CLUSTERED 
(
	[AttID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AT].[Depreciations]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Depreciations](
	[DepID] [int] IDENTITY(1,1) NOT NULL,
	[DepreciationDate] [date] NOT NULL,
	[Remark] [nvarchar](100) NULL,
	[CreatedByUserID] [smallint] NOT NULL,
	[CreatedByFullName] [nvarchar](100) NOT NULL,
	[CreatedByDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Depreciations] PRIMARY KEY CLUSTERED 
(
	[DepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Depreciations] UNIQUE NONCLUSTERED 
(
	[DepreciationDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[DepreciationsDetails]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[DepreciationsDetails](
	[DepDetailID] [int] IDENTITY(1,1) NOT NULL,
	[DepID] [int] NOT NULL,
	[AssetID] [int] NOT NULL,
	[DepreciationRate] [tinyint] NOT NULL,
	[DepreciationValue] [float] NOT NULL,
	[NetBookValue] [float] NOT NULL,
	[PurchasePrice] [float] NOT NULL,
	[PurchaseCurCode] [char](3) NOT NULL,
	[AccountingEntryDate] [date] NULL,
	[AccountingEntryJVNo] [nvarchar](10) NULL,
	[GroupID] [smallint] NOT NULL,
	[CategoryID] [smallint] NOT NULL,
 CONSTRAINT [PK_DepreciationsDetails] PRIMARY KEY CLUSTERED 
(
	[DepDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[Inventories]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Inventories](
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryStartDate] [date] NOT NULL,
	[InventoryEndDate] [date] NULL,
	[Remark] [nvarchar](100) NULL,
	[StartCreatedByUserID] [smallint] NOT NULL,
	[StartCreatedByFullName] [nvarchar](100) NOT NULL,
	[StartCreatedByDateTime] [datetime] NOT NULL,
	[EndCreatedByUserID] [smallint] NULL,
	[EndCreatedByFullName] [nvarchar](100) NULL,
	[EndCreatedByDateTime] [datetime] NULL,
 CONSTRAINT [PK_Inventories] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Inventories] UNIQUE NONCLUSTERED 
(
	[InventoryStartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[InventoriesDetails]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[InventoriesDetails](
	[InvDetailID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryID] [int] NOT NULL,
	[AssetID] [int] NOT NULL,
	[IsAvailable] [bit] NOT NULL,
	[AssetCode] [nvarchar](15) NOT NULL,
	[AssetDesc] [nvarchar](50) NOT NULL,
	[Relocated] [bit] NOT NULL,
	[RelocatedLocationID] [smallint] NULL,
	[RelocatedLocDetailID] [smallint] NULL,
	[CompanyID] [smallint] NOT NULL,
	[LocationID] [smallint] NOT NULL,
	[LocDetailID] [smallint] NOT NULL,
	[GroupID] [smallint] NOT NULL,
	[CategoryID] [smallint] NOT NULL,
	[BarcodeNumber] [nvarchar](20) NULL,
	[SerialNumber] [nvarchar](50) NULL,
	[Remark] [nvarchar](100) NULL,
	[CreatedDate] [date] NOT NULL,
 CONSTRAINT [PK_InventoriesDetails] PRIMARY KEY CLUSTERED 
(
	[InvDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[Maintenances]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Maintenances](
	[MaintID] [int] IDENTITY(1,1) NOT NULL,
	[AssetID] [int] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[SupplierContactID] [int] NOT NULL,
	[Cost] [float] NOT NULL,
	[CurCode] [char](3) NOT NULL,
	[Remark] [nvarchar](100) NULL,
 CONSTRAINT [PK_Maintenances] PRIMARY KEY CLUSTERED 
(
	[MaintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[StatusHistory]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[StatusHistory](
	[StatusHistID] [int] IDENTITY(1,1) NOT NULL,
	[AssetID] [int] NOT NULL,
	[StatusID] [tinyint] NOT NULL,
	[StatusDate] [date] NOT NULL,
	[StatusDesc] [nvarchar](50) NULL,
	[StatusContactID] [int] NULL,
	[StatusSalePrice] [float] NOT NULL,
	[StatusSaleCurCode] [char](3) NULL,
	[CreatedByUserID] [smallint] NOT NULL,
	[CreatedByFullName] [nvarchar](100) NOT NULL,
	[CreatedByDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_StatusHistory] PRIMARY KEY CLUSTERED 
(
	[StatusHistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[Warranties]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Warranties](
	[WarntID] [int] IDENTITY(1,1) NOT NULL,
	[AssetID] [int] NOT NULL,
	[WarrantyDesc] [nvarchar](50) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[Remark] [nvarchar](100) NULL,
 CONSTRAINT [PK_Warranties] PRIMARY KEY CLUSTERED 
(
	[WarntID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[CategoryTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[CategoryTypes](
	[CategoryID] [smallint] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[GroupID] [smallint] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Categories] UNIQUE NONCLUSTERED 
(
	[Category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[GroupTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[GroupTypes](
	[GroupID] [smallint] IDENTITY(101,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Acronym] [nvarchar](5) NOT NULL,
	[DepreciationRate] [tinyint] NOT NULL,
	[AccountNo] [nvarchar](20) NULL,
	[AccountingExclusion] [bit] NOT NULL,
	[CountryID] [smallint] NULL,
 CONSTRAINT [PK_GroupTypes] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_GroupTypes] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[LocationDetails]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[LocationDetails](
	[LocDetailID] [smallint] IDENTITY(101,1) NOT NULL,
	[LocationID] [smallint] NOT NULL,
	[Floor] [nvarchar](10) NOT NULL,
	[Zone] [nvarchar](10) NULL,
	[Room] [nvarchar](10) NULL,
 CONSTRAINT [PK_LocationDetails] PRIMARY KEY CLUSTERED 
(
	[LocDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[LocationTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[LocationTypes](
	[LocationID] [smallint] IDENTITY(101,1) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[CompanyID] [smallint] NOT NULL,
 CONSTRAINT [PK_LocationTypes] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_LocationTypes] UNIQUE NONCLUSTERED 
(
	[Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[Settings]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[Settings](
	[SetID] [tinyint] NOT NULL,
	[SetValue] [nvarchar](250) NOT NULL,
	[SetDescription] [nvarchar](100) NOT NULL,
	[SetType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[SetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[StatusTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[StatusTypes](
	[StatusID] [tinyint] NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_StatusTypes] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_StatusTypes] UNIQUE NONCLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail1]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[AddressDetail1](
	[AddressDetail1ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressDetail1] [nvarchar](50) NOT NULL,
	[CountryID] [char](2) NOT NULL,
 CONSTRAINT [PK_AddressDetail1] PRIMARY KEY CLUSTERED 
(
	[AddressDetail1ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_AddressDetail1] UNIQUE NONCLUSTERED 
(
	[AddressDetail1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail2]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[AddressDetail2](
	[AddressDetail2ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressDetail2] [nvarchar](50) NOT NULL,
	[AddressDetail1ID] [int] NOT NULL,
 CONSTRAINT [PK_AddressDetail2] PRIMARY KEY CLUSTERED 
(
	[AddressDetail2ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_AddressDetail2] UNIQUE NONCLUSTERED 
(
	[AddressDetail2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail3]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[AddressDetail3](
	[AddressDetail3ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressDetail3] [nvarchar](50) NOT NULL,
	[AddressDetail2ID] [int] NOT NULL,
 CONSTRAINT [PK_AddressDetail3] PRIMARY KEY CLUSTERED 
(
	[AddressDetail3ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[AddressTypes](
	[AddressTypeID] [smallint] IDENTITY(101,1) NOT NULL,
	[AddressType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AddressTypes] PRIMARY KEY CLUSTERED 
(
	[AddressTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Companies]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[Companies](
	[CompanyID] [smallint] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](100) NOT NULL,
	[CompanyAbbreviation] [nvarchar](10) NOT NULL,
	[CompanyPrmCurCode] [char](3) NOT NULL,
	[CompanyScdCurCode] [char](3) NOT NULL,
	[CountryID] [char](2) NOT NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Companies] UNIQUE NONCLUSTERED 
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[ContactTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[ContactTypes](
	[ContactTypeID] [tinyint] NOT NULL,
	[ContactType] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_ContactTypes] PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ContactTypes] UNIQUE NONCLUSTERED 
(
	[ContactType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Countries]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[Countries](
	[CountryID] [char](2) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Nationality] [nvarchar](50) NOT NULL,
	[ZipCode] [varchar](5) NULL,
	[Flag] [image] NOT NULL,
	[WorkingCountry] [bit] NOT NULL,
	[ActiveCountry] [bit] NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Currencies]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[Currencies](
	[CurCode] [char](3) NOT NULL,
	[CurName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[CurCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Currencies] UNIQUE NONCLUSTERED 
(
	[CurName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[CurrenciesRates]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[CurrenciesRates](
	[CurCode] [char](3) NOT NULL,
	[StartDate] [date] NOT NULL,
	[Rate] [float] NOT NULL,
 CONSTRAINT [PK_CurrenciesRates] PRIMARY KEY CLUSTERED 
(
	[CurCode] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[LogSeverity]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[LogSeverity](
	[LogSeverityID] [tinyint] NOT NULL,
	[LogSeverity] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_LogSeverity] PRIMARY KEY CLUSTERED 
(
	[LogSeverityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_LogSeverity] UNIQUE NONCLUSTERED 
(
	[LogSeverity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[LogSystem]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[LogSystem](
	[LogSystemID] [tinyint] NOT NULL,
	[LogSystem] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_LogSystem] PRIMARY KEY CLUSTERED 
(
	[LogSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_LogSystem] UNIQUE NONCLUSTERED 
(
	[LogSystem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[LogTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[LogTypes](
	[LogTypeID] [tinyint] NOT NULL,
	[LogType] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_LogTypes] PRIMARY KEY CLUSTERED 
(
	[LogTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_LogTypes] UNIQUE NONCLUSTERED 
(
	[LogType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Settings]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GSET].[Settings](
	[SetID] [tinyint] NOT NULL,
	[SetValue] [nvarchar](250) NOT NULL,
	[SetDescription] [nvarchar](100) NOT NULL,
	[SetType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Setting_1] PRIMARY KEY CLUSTERED 
(
	[SetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GTBL].[Contacts]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GTBL].[Contacts](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[ContactName] [nvarchar](100) NOT NULL,
	[ContactTypeID] [tinyint] NOT NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[ContactPersonEmail] [nvarchar](50) NULL,
	[FinancialContact] [nvarchar](100) NULL,
	[FinancialContactEmail] [nvarchar](50) NULL,
	[Address] [nvarchar](200) NOT NULL,
	[CountryID] [char](2) NOT NULL,
	[Telephone1] [varchar](16) NOT NULL,
	[Telephone2] [varchar](16) NULL,
	[Mobile1] [varchar](16) NULL,
	[Mobile2] [varchar](16) NULL,
	[Fax1] [varchar](16) NULL,
	[Fax2] [varchar](16) NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GTBL].[Logs]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GTBL].[Logs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [smallint] NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[DomainUser] [nvarchar](255) NOT NULL,
	[Computer] [nvarchar](255) NOT NULL,
	[SQLHostName] [nvarchar](255) NOT NULL,
	[SQLLoggedName] [nvarchar](255) NOT NULL,
	[SQLCurrentUser] [nvarchar](255) NOT NULL,
	[LogSystemID] [tinyint] NOT NULL,
	[LogSeverityID] [tinyint] NOT NULL,
	[LogTypeID] [tinyint] NOT NULL,
	[FormName] [nvarchar](255) NOT NULL,
	[MethodName] [nvarchar](255) NOT NULL,
	[LogDesc] [text] NOT NULL,
	[SentByEmail] [bit] NOT NULL,
 CONSTRAINT [PK_GTBL.Logs] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SEC].[Roles]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SEC].[Roles](
	[RoleID] [tinyint] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Roles] UNIQUE NONCLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SEC].[Users]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SEC].[Users](
	[UserID] [smallint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[UserPassword] [varbinary](512) NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[RoleID] [tinyint] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SEC].[UsersPermissions]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SEC].[UsersPermissions](
	[UserID] [smallint] NOT NULL,
	[CountryID] [char](2) NOT NULL,
	[CompanyID] [smallint] NOT NULL,
 CONSTRAINT [PK_UsersPermissions] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[CountryID] ASC,
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AT].[Assets] ADD  CONSTRAINT [DF_Assets_Donation]  DEFAULT ((0)) FOR [Donation]
GO
ALTER TABLE [AT].[Assets] ADD  CONSTRAINT [DF_Assets_PurchasePrice]  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [AT].[DepreciationsDetails] ADD  CONSTRAINT [DF_DepreciationsDetails_DepRate]  DEFAULT ((0)) FOR [DepreciationRate]
GO
ALTER TABLE [AT].[DepreciationsDetails] ADD  CONSTRAINT [DF_DepreciationsDetails_DepValue]  DEFAULT ((0)) FOR [DepreciationValue]
GO
ALTER TABLE [AT].[DepreciationsDetails] ADD  CONSTRAINT [DF_DepreciationsDetails_NetBookValue]  DEFAULT ((0)) FOR [NetBookValue]
GO
ALTER TABLE [AT].[DepreciationsDetails] ADD  CONSTRAINT [DF_DepreciationsDetails_PurchasePrice]  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [AT].[InventoriesDetails] ADD  CONSTRAINT [DF_InventoriesDetails_IsAvailable]  DEFAULT ((0)) FOR [IsAvailable]
GO
ALTER TABLE [AT].[InventoriesDetails] ADD  CONSTRAINT [DF_InventoriesDetails_Relocated]  DEFAULT ((0)) FOR [Relocated]
GO
ALTER TABLE [AT].[InventoriesDetails] ADD  CONSTRAINT [DF_InventoriesDetails_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [AT].[Maintenances] ADD  CONSTRAINT [DF_Maintenances_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [AT].[StatusHistory] ADD  CONSTRAINT [DF_StatusHistory_StatusSalePrice]  DEFAULT ((0)) FOR [StatusSalePrice]
GO
ALTER TABLE [ATSET].[GroupTypes] ADD  CONSTRAINT [DF_GroupTypes_DepreciationRate]  DEFAULT ((0)) FOR [DepreciationRate]
GO
ALTER TABLE [ATSET].[GroupTypes] ADD  CONSTRAINT [DF_GroupTypes_AccountingExclusion]  DEFAULT ((0)) FOR [AccountingExclusion]
GO
ALTER TABLE [ATSET].[GroupTypes] ADD  CONSTRAINT [DF_GroupTypes_CountryID]  DEFAULT ((1)) FOR [CountryID]
GO
ALTER TABLE [ATSET].[Settings] ADD  CONSTRAINT [DF_Settings_SetType]  DEFAULT ('General') FOR [SetType]
GO
ALTER TABLE [GSET].[Countries] ADD  CONSTRAINT [DF_Countries_ActiveHR]  DEFAULT ((0)) FOR [WorkingCountry]
GO
ALTER TABLE [GSET].[Countries] ADD  CONSTRAINT [DF_Countries_ActiveCountry]  DEFAULT ((0)) FOR [ActiveCountry]
GO
ALTER TABLE [GSET].[CurrenciesRates] ADD  CONSTRAINT [DF_CurrenciesRates_Rate]  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [GSET].[Settings] ADD  CONSTRAINT [DF_Settings_SetType]  DEFAULT ('General') FOR [SetType]
GO
ALTER TABLE [GTBL].[Contacts] ADD  CONSTRAINT [DF_Table_1_ContactTypeId]  DEFAULT ((1)) FOR [ContactTypeID]
GO
ALTER TABLE [GTBL].[Contacts] ADD  CONSTRAINT [DF_Table_1_CountryId]  DEFAULT ('LB') FOR [CountryID]
GO
ALTER TABLE [GTBL].[Logs] ADD  CONSTRAINT [DF_GTBL.Logs_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [GTBL].[Logs] ADD  CONSTRAINT [DF_GTBL.Logs_SendByEmail]  DEFAULT ((0)) FOR [SentByEmail]
GO
ALTER TABLE [SEC].[Users] ADD  CONSTRAINT [DF_Users_RoleID]  DEFAULT ((1)) FOR [RoleID]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_Categories] FOREIGN KEY([CategoryID])
REFERENCES [ATSET].[CategoryTypes] ([CategoryID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_Categories]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_Companies]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_Contacts] FOREIGN KEY([ContactID])
REFERENCES [GTBL].[Contacts] ([ContactID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_Contacts]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_Currencies] FOREIGN KEY([PurchaseCurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_Currencies]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_GroupTypes] FOREIGN KEY([GroupID])
REFERENCES [ATSET].[GroupTypes] ([GroupID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_GroupTypes]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_LocationDetails] FOREIGN KEY([LocDetailID])
REFERENCES [ATSET].[LocationDetails] ([LocDetailID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_LocationDetails]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_LocationTypes] FOREIGN KEY([LocationID])
REFERENCES [ATSET].[LocationTypes] ([LocationID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_LocationTypes]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_StatusTypes] FOREIGN KEY([StatusID])
REFERENCES [ATSET].[StatusTypes] ([StatusID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_StatusTypes]
GO
ALTER TABLE [AT].[Attachments]  WITH CHECK ADD  CONSTRAINT [FK_Attachments_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
ON DELETE CASCADE
GO
ALTER TABLE [AT].[Attachments] CHECK CONSTRAINT [FK_Attachments_Assets]
GO
ALTER TABLE [AT].[Depreciations]  WITH CHECK ADD  CONSTRAINT [FK_Depreciations_Users] FOREIGN KEY([CreatedByUserID])
REFERENCES [SEC].[Users] ([UserID])
GO
ALTER TABLE [AT].[Depreciations] CHECK CONSTRAINT [FK_Depreciations_Users]
GO
ALTER TABLE [AT].[DepreciationsDetails]  WITH CHECK ADD  CONSTRAINT [FK_DepreciationsDetails_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
GO
ALTER TABLE [AT].[DepreciationsDetails] CHECK CONSTRAINT [FK_DepreciationsDetails_Assets]
GO
ALTER TABLE [AT].[DepreciationsDetails]  WITH CHECK ADD  CONSTRAINT [FK_DepreciationsDetails_CategoryTypes] FOREIGN KEY([CategoryID])
REFERENCES [ATSET].[CategoryTypes] ([CategoryID])
GO
ALTER TABLE [AT].[DepreciationsDetails] CHECK CONSTRAINT [FK_DepreciationsDetails_CategoryTypes]
GO
ALTER TABLE [AT].[DepreciationsDetails]  WITH CHECK ADD  CONSTRAINT [FK_DepreciationsDetails_Currencies] FOREIGN KEY([PurchaseCurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [AT].[DepreciationsDetails] CHECK CONSTRAINT [FK_DepreciationsDetails_Currencies]
GO
ALTER TABLE [AT].[DepreciationsDetails]  WITH CHECK ADD  CONSTRAINT [FK_DepreciationsDetails_Depreciations] FOREIGN KEY([DepID])
REFERENCES [AT].[Depreciations] ([DepID])
GO
ALTER TABLE [AT].[DepreciationsDetails] CHECK CONSTRAINT [FK_DepreciationsDetails_Depreciations]
GO
ALTER TABLE [AT].[DepreciationsDetails]  WITH CHECK ADD  CONSTRAINT [FK_DepreciationsDetails_GroupTypes] FOREIGN KEY([GroupID])
REFERENCES [ATSET].[GroupTypes] ([GroupID])
GO
ALTER TABLE [AT].[DepreciationsDetails] CHECK CONSTRAINT [FK_DepreciationsDetails_GroupTypes]
GO
ALTER TABLE [AT].[Inventories]  WITH CHECK ADD  CONSTRAINT [FK_Inventories_Users] FOREIGN KEY([StartCreatedByUserID])
REFERENCES [SEC].[Users] ([UserID])
GO
ALTER TABLE [AT].[Inventories] CHECK CONSTRAINT [FK_Inventories_Users]
GO
ALTER TABLE [AT].[Inventories]  WITH CHECK ADD  CONSTRAINT [FK_Inventories_Users1] FOREIGN KEY([EndCreatedByUserID])
REFERENCES [SEC].[Users] ([UserID])
GO
ALTER TABLE [AT].[Inventories] CHECK CONSTRAINT [FK_Inventories_Users1]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_Assets]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_CategoryTypes] FOREIGN KEY([CategoryID])
REFERENCES [ATSET].[CategoryTypes] ([CategoryID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_CategoryTypes]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_Companies]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_GroupTypes] FOREIGN KEY([GroupID])
REFERENCES [ATSET].[GroupTypes] ([GroupID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_GroupTypes]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_Inventories] FOREIGN KEY([InventoryID])
REFERENCES [AT].[Inventories] ([InventoryID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_Inventories]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_LocationDetails] FOREIGN KEY([LocDetailID])
REFERENCES [ATSET].[LocationDetails] ([LocDetailID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_LocationDetails]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_LocationDetails1] FOREIGN KEY([RelocatedLocDetailID])
REFERENCES [ATSET].[LocationDetails] ([LocDetailID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_LocationDetails1]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_LocationTypes] FOREIGN KEY([LocationID])
REFERENCES [ATSET].[LocationTypes] ([LocationID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_LocationTypes]
GO
ALTER TABLE [AT].[InventoriesDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoriesDetails_LocationTypes1] FOREIGN KEY([RelocatedLocationID])
REFERENCES [ATSET].[LocationTypes] ([LocationID])
GO
ALTER TABLE [AT].[InventoriesDetails] CHECK CONSTRAINT [FK_InventoriesDetails_LocationTypes1]
GO
ALTER TABLE [AT].[Maintenances]  WITH CHECK ADD  CONSTRAINT [FK_Maintenances_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
ON DELETE CASCADE
GO
ALTER TABLE [AT].[Maintenances] CHECK CONSTRAINT [FK_Maintenances_Assets]
GO
ALTER TABLE [AT].[Maintenances]  WITH CHECK ADD  CONSTRAINT [FK_Maintenances_Contacts] FOREIGN KEY([SupplierContactID])
REFERENCES [GTBL].[Contacts] ([ContactID])
GO
ALTER TABLE [AT].[Maintenances] CHECK CONSTRAINT [FK_Maintenances_Contacts]
GO
ALTER TABLE [AT].[Maintenances]  WITH CHECK ADD  CONSTRAINT [FK_Maintenances_Currencies] FOREIGN KEY([CurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [AT].[Maintenances] CHECK CONSTRAINT [FK_Maintenances_Currencies]
GO
ALTER TABLE [AT].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
GO
ALTER TABLE [AT].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Assets]
GO
ALTER TABLE [AT].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Contacts] FOREIGN KEY([StatusContactID])
REFERENCES [GTBL].[Contacts] ([ContactID])
GO
ALTER TABLE [AT].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Contacts]
GO
ALTER TABLE [AT].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Currencies] FOREIGN KEY([StatusSaleCurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [AT].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Currencies]
GO
ALTER TABLE [AT].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_StatusTypes] FOREIGN KEY([StatusID])
REFERENCES [ATSET].[StatusTypes] ([StatusID])
GO
ALTER TABLE [AT].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_StatusTypes]
GO
ALTER TABLE [AT].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Users] FOREIGN KEY([CreatedByUserID])
REFERENCES [SEC].[Users] ([UserID])
GO
ALTER TABLE [AT].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Users]
GO
ALTER TABLE [AT].[Warranties]  WITH CHECK ADD  CONSTRAINT [FK_Warranties_Assets] FOREIGN KEY([AssetID])
REFERENCES [AT].[Assets] ([AssetID])
ON DELETE CASCADE
GO
ALTER TABLE [AT].[Warranties] CHECK CONSTRAINT [FK_Warranties_Assets]
GO
ALTER TABLE [ATSET].[CategoryTypes]  WITH CHECK ADD  CONSTRAINT [FK_Categories_GroupTypes] FOREIGN KEY([GroupID])
REFERENCES [ATSET].[GroupTypes] ([GroupID])
GO
ALTER TABLE [ATSET].[CategoryTypes] CHECK CONSTRAINT [FK_Categories_GroupTypes]
GO
ALTER TABLE [ATSET].[LocationDetails]  WITH CHECK ADD  CONSTRAINT [FK_LocationDetails_LocationTypes] FOREIGN KEY([LocationID])
REFERENCES [ATSET].[LocationTypes] ([LocationID])
ON DELETE CASCADE
GO
ALTER TABLE [ATSET].[LocationDetails] CHECK CONSTRAINT [FK_LocationDetails_LocationTypes]
GO
ALTER TABLE [ATSET].[LocationTypes]  WITH CHECK ADD  CONSTRAINT [FK_LocationTypes_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [ATSET].[LocationTypes] CHECK CONSTRAINT [FK_LocationTypes_Companies]
GO
ALTER TABLE [GSET].[AddressDetail1]  WITH CHECK ADD  CONSTRAINT [FK_AddressDetail1_Countries] FOREIGN KEY([CountryID])
REFERENCES [GSET].[Countries] ([CountryID])
GO
ALTER TABLE [GSET].[AddressDetail1] CHECK CONSTRAINT [FK_AddressDetail1_Countries]
GO
ALTER TABLE [GSET].[AddressDetail2]  WITH CHECK ADD  CONSTRAINT [FK_AddressDetail2_AddressDetail1] FOREIGN KEY([AddressDetail1ID])
REFERENCES [GSET].[AddressDetail1] ([AddressDetail1ID])
GO
ALTER TABLE [GSET].[AddressDetail2] CHECK CONSTRAINT [FK_AddressDetail2_AddressDetail1]
GO
ALTER TABLE [GSET].[AddressDetail3]  WITH CHECK ADD  CONSTRAINT [FK_AddressDetail3_AddressDetail2] FOREIGN KEY([AddressDetail2ID])
REFERENCES [GSET].[AddressDetail2] ([AddressDetail2ID])
GO
ALTER TABLE [GSET].[AddressDetail3] CHECK CONSTRAINT [FK_AddressDetail3_AddressDetail2]
GO
ALTER TABLE [GSET].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [GSET].[Companies] CHECK CONSTRAINT [FK_Companies_Companies]
GO
ALTER TABLE [GSET].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Countries] FOREIGN KEY([CountryID])
REFERENCES [GSET].[Countries] ([CountryID])
GO
ALTER TABLE [GSET].[Companies] CHECK CONSTRAINT [FK_Companies_Countries]
GO
ALTER TABLE [GSET].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Currencies1] FOREIGN KEY([CompanyScdCurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [GSET].[Companies] CHECK CONSTRAINT [FK_Companies_Currencies1]
GO
ALTER TABLE [GSET].[CurrenciesRates]  WITH CHECK ADD  CONSTRAINT [FK_CurrenciesRates_Currencies] FOREIGN KEY([CurCode])
REFERENCES [GSET].[Currencies] ([CurCode])
GO
ALTER TABLE [GSET].[CurrenciesRates] CHECK CONSTRAINT [FK_CurrenciesRates_Currencies]
GO
ALTER TABLE [GTBL].[Contacts]  WITH CHECK ADD  CONSTRAINT [FK_Contacts_ContactTypes] FOREIGN KEY([ContactTypeID])
REFERENCES [GSET].[ContactTypes] ([ContactTypeID])
GO
ALTER TABLE [GTBL].[Contacts] CHECK CONSTRAINT [FK_Contacts_ContactTypes]
GO
ALTER TABLE [GTBL].[Contacts]  WITH CHECK ADD  CONSTRAINT [FK_Contacts_Countries] FOREIGN KEY([CountryID])
REFERENCES [GSET].[Countries] ([CountryID])
GO
ALTER TABLE [GTBL].[Contacts] CHECK CONSTRAINT [FK_Contacts_Countries]
GO
ALTER TABLE [GTBL].[Logs]  WITH CHECK ADD  CONSTRAINT [FK_Logs_LogSeverity] FOREIGN KEY([LogSeverityID])
REFERENCES [GSET].[LogSeverity] ([LogSeverityID])
GO
ALTER TABLE [GTBL].[Logs] CHECK CONSTRAINT [FK_Logs_LogSeverity]
GO
ALTER TABLE [GTBL].[Logs]  WITH CHECK ADD  CONSTRAINT [FK_Logs_LogSystem] FOREIGN KEY([LogSystemID])
REFERENCES [GSET].[LogSystem] ([LogSystemID])
GO
ALTER TABLE [GTBL].[Logs] CHECK CONSTRAINT [FK_Logs_LogSystem]
GO
ALTER TABLE [GTBL].[Logs]  WITH CHECK ADD  CONSTRAINT [FK_Logs_LogTypes] FOREIGN KEY([LogTypeID])
REFERENCES [GSET].[LogTypes] ([LogTypeID])
GO
ALTER TABLE [GTBL].[Logs] CHECK CONSTRAINT [FK_Logs_LogTypes]
GO
ALTER TABLE [SEC].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles] FOREIGN KEY([RoleID])
REFERENCES [SEC].[Roles] ([RoleID])
GO
ALTER TABLE [SEC].[Users] CHECK CONSTRAINT [FK_Users_Roles]
GO
ALTER TABLE [SEC].[UsersPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UsersPermissions_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [SEC].[UsersPermissions] CHECK CONSTRAINT [FK_UsersPermissions_Companies]
GO
ALTER TABLE [SEC].[UsersPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UsersPermissions_Countries] FOREIGN KEY([CountryID])
REFERENCES [GSET].[Countries] ([CountryID])
GO
ALTER TABLE [SEC].[UsersPermissions] CHECK CONSTRAINT [FK_UsersPermissions_Countries]
GO
ALTER TABLE [SEC].[UsersPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UsersPermissions_Users] FOREIGN KEY([UserID])
REFERENCES [SEC].[Users] ([UserID])
GO
ALTER TABLE [SEC].[UsersPermissions] CHECK CONSTRAINT [FK_UsersPermissions_Users]
GO
/****** Object:  StoredProcedure [AT].[rstpAssetsList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[rstpAssetsList]
(	
	@LocationID smallint,
	@CompanyID smallint,
	@CategoryID smallint,
	@GroupID smallint,
	@LocationDetailID smallint,
	@AccountingExclusion bit
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT      AT.Assets.AssetID, GSET.Companies.CompanyAbbreviation, AT.Assets.AssetCode, AT.Assets.AssetDesc, ATSET.CategoryTypes.Category, ATSET.GroupTypes.GroupName,
				ATSET.LocationTypes.Location, 
				ATSET.LocationDetails.[Floor], ATSET.LocationDetails.Room, ATSET.LocationDetails.Zone,AT.Assets.InServiceDate,
				ATSET.StatusTypes.[Status], AT.Assets.StatusDate, AT.fnLastInventoryDateByItem(At.Assets.AssetID) as LastInventoryDateByItem,
				AT.Assets.BarcodeNumber, AT.Assets.SerialNumber
	FROM        AT.Assets LEFT OUTER JOIN
                ATSET.LocationTypes ON AT.Assets.LocationID = ATSET.LocationTypes.LocationID LEFT OUTER JOIN
				ATSET.LocationDetails ON AT.Assets.LocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
				ATSET.StatusTypes ON AT.Assets.StatusID = ATSET.StatusTypes.StatusID LEFT OUTER JOIN
				ATSET.CategoryTypes ON AT.Assets.CategoryID = ATSET.CategoryTypes.CategoryID LEFT OUTER JOIN
				ATSET.GroupTypes ON AT.Assets.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
                GSET.Companies ON AT.Assets.CompanyID = GSET.Companies.CompanyID
	WHERE		AT.Assets.LocationID = CASE @LocationID When -1 Then AT.Assets.LocationID Else @LocationID END
			AND AT.Assets.CompanyID = CASE @CompanyID When -1 Then AT.Assets.CompanyID Else @CompanyID END
			AND AT.Assets.LocDetailID = CASE @LocationDetailID When -1 Then AT.Assets.LocDetailID Else @LocationDetailID END
			AND AT.Assets.GroupID = CASE @GroupID When -1 Then AT.Assets.GroupID Else @GroupID END
			AND AT.Assets.CategoryID = CASE @CategoryID When -1 Then AT.Assets.CategoryID Else @CategoryID END
			AND ATSET.GroupTypes.AccountingExclusion = CASE WHEN @AccountingExclusion= 1 Then 0 Else ATSET.GroupTypes.AccountingExclusion END

END




GO
/****** Object:  StoredProcedure [AT].[rstpAssetsListInventory]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[rstpAssetsListInventory]
(	
	@InventoryID int,
	@LocationID smallint,
	@CompanyID smallint,
	@CategoryID smallint,
	@GroupID smallint,
	@LocationDetailID smallint,
	@AccountingExclusion bit
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT		AT.InventoriesDetails.AssetID, AT.InventoriesDetails.IsAvailable, AT.InventoriesDetails.AssetCode, AT.InventoriesDetails.AssetDesc, AT.InventoriesDetails.Remark, ATSET.LocationTypes.Location AS RelocatedLocation, 
				ATSET.LocationDetails.Floor AS RelocatedFloor, ATSET.LocationDetails.Zone AS RelocatedZone, ATSET.LocationDetails.Room AS RelocatedRoom, AT.InventoriesDetails.Relocated, LocationTypes_1.Location, 
				LocationDetails_1.Floor, LocationDetails_1.Zone, LocationDetails_1.Room, AT.InventoriesDetails.LocationID, ATSET.GroupTypes.GroupName
	FROM		AT.InventoriesDetails LEFT OUTER JOIN
				ATSET.GroupTypes ON AT.InventoriesDetails.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
				ATSET.LocationDetails ON AT.InventoriesDetails.RelocatedLocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
				ATSET.LocationTypes ON AT.InventoriesDetails.RelocatedLocationID = ATSET.LocationTypes.LocationID LEFT OUTER JOIN
				ATSET.LocationDetails AS LocationDetails_1 ON AT.InventoriesDetails.LocDetailID = LocationDetails_1.LocDetailID LEFT OUTER JOIN
				ATSET.LocationTypes AS LocationTypes_1 ON AT.InventoriesDetails.LocationID = LocationTypes_1.LocationID
	WHERE		AT.InventoriesDetails.InventoryID = @InventoryID 
			AND AT.InventoriesDetails.LocationID = CASE @LocationID When -1 Then AT.InventoriesDetails.LocationID Else @LocationID END
			AND AT.InventoriesDetails.CompanyID = CASE @CompanyID When -1 Then AT.InventoriesDetails.CompanyID Else @CompanyID END
			AND AT.InventoriesDetails.LocDetailID = CASE @LocationDetailID When -1 Then AT.InventoriesDetails.LocDetailID Else @LocationDetailID END
			AND AT.InventoriesDetails.GroupID = CASE @GroupID When -1 Then AT.InventoriesDetails.GroupID Else @GroupID END
			AND AT.InventoriesDetails.CategoryID = CASE @CategoryID When -1 Then AT.InventoriesDetails.CategoryID Else @CategoryID END
			AND ATSET.GroupTypes.AccountingExclusion = CASE WHEN @AccountingExclusion= 1 Then 0 Else ATSET.GroupTypes.AccountingExclusion END

END




GO
/****** Object:  StoredProcedure [AT].[rstpAssetsNotDepreciated]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[rstpAssetsNotDepreciated]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT      AT.Assets.AssetID, AT.Assets.AssetCode, AT.Assets.AssetDesc, AT.Assets.Donation, 
				PriceExist = CASE AT.Assets.PurchasePrice When 0 Then 'N' Else 'Y' END, 
				AcctEntryDateExist = CASE WHEN AT.Assets.AccountingEntryDate IS NULL Then 'N' Else 'Y' END, 
				AT.Assets.GroupID, ATSET.LocationTypes.Location, 
                ATSET.LocationDetails.Floor, ATSET.LocationDetails.Zone, ATSET.LocationDetails.Room, ATSET.GroupTypes.GroupName, ATSET.CategoryTypes.Category
	FROM        AT.Assets LEFT OUTER JOIN
                ATSET.CategoryTypes ON AT.Assets.CategoryID = ATSET.CategoryTypes.CategoryID LEFT OUTER JOIN
                ATSET.GroupTypes ON AT.Assets.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
                ATSET.LocationDetails ON AT.Assets.LocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
                ATSET.LocationTypes ON AT.Assets.LocationID = ATSET.LocationTypes.LocationID
	WHERE		PurchasePrice = 0 OR AccountingEntryDate IS NULL
END




GO
/****** Object:  StoredProcedure [AT].[rstpDepreciation]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[rstpDepreciation]
(
	@DepID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  AT.Depreciations.DepID, AT.Depreciations.DepreciationDate, AT.Depreciations.Remark, AT.Depreciations.CreatedByFullName, AT.Depreciations.CreatedByDateTime, AT.Assets.AssetCode, AT.Assets.AssetDesc, 
            AT.DepreciationsDetails.DepreciationRate, AT.DepreciationsDetails.DepreciationValue, AT.DepreciationsDetails.NetBookValue, AT.DepreciationsDetails.AccountingEntryDate, 
            AT.DepreciationsDetails.AccountingEntryJVNo
	FROM    AT.Assets RIGHT OUTER JOIN
            AT.DepreciationsDetails ON AT.Assets.AssetID = AT.DepreciationsDetails.AssetID LEFT OUTER JOIN
            AT.Depreciations ON AT.DepreciationsDetails.DepID = AT.Depreciations.DepID
	WHERE	AT.DepreciationsDetails.DepID = @DepID
END




GO
/****** Object:  StoredProcedure [AT].[stpAssetsD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsD]
(
	@AssetID int
)
AS
	SET NOCOUNT OFF;
	DELETE FROM [AT].[Assets] WHERE [AssetID] = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpAssetsDepreciationHistory]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpAssetsDepreciationHistory] 
(
	@AssetID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT      AT.DepreciationsDetails.DepDetailID, AT.Depreciations.DepreciationDate, AT.DepreciationsDetails.DepreciationRate, AT.DepreciationsDetails.DepreciationValue, AT.DepreciationsDetails.NetBookValue, 
                ATSET.GroupTypes.GroupName, ATSET.CategoryTypes.Category, AT.DepreciationsDetails.PurchasePrice, AT.DepreciationsDetails.PurchaseCurCode, AT.DepreciationsDetails.AccountingEntryDate, 
                AT.DepreciationsDetails.AccountingEntryJVNo, AT.Depreciations.CreatedByFullName, AT.Depreciations.CreatedByDateTime
	FROM        AT.DepreciationsDetails LEFT OUTER JOIN
                ATSET.CategoryTypes ON AT.DepreciationsDetails.CategoryID = ATSET.CategoryTypes.CategoryID LEFT OUTER JOIN
                ATSET.GroupTypes ON AT.DepreciationsDetails.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
                AT.Depreciations ON AT.DepreciationsDetails.DepID = AT.Depreciations.DepID
	WHERE		AssetID = @AssetID
	ORDER BY	AT.Depreciations.DepreciationDate DESC

END




GO
/****** Object:  StoredProcedure [AT].[stpAssetsI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsI]
(
	@CompanyID smallint,
	@AssetCode nvarchar(15),
	@AssetImage image,
	@AssetDesc nvarchar(50),
	@LocationID smallint,
	@LocDetailID smallint,
	@GroupID smallint,
	@CategoryID smallint,
	@Donation bit,
	@ContactID int,
	@PurchaseOrderNo nvarchar(10),
	@PurchaseDate date,
	@PurchasePrice float,
	@PurchaseCurCode char(3),
	@InServiceDate date,
	@InvoiceNo nvarchar(10),
	@InvoiceDate date,
	@AccountingEntryDate date,
	@AccountingEntryJVNo nvarchar(10),
	@BarcodeNumber nvarchar(20),
	@SerialNumber nvarchar(50),
	@Remark nvarchar(100),
	@InstalledAt nvarchar(50)
)
AS
	SET NOCOUNT OFF;

	INSERT INTO [AT].[Assets] ([CompanyID], [AssetCode], [AssetImage], [AssetDesc], [LocationID], [LocDetailID], [GroupID], [CategoryID], [Donation],[ContactID],	
							   [PurchaseOrderNo], [PurchaseDate], [PurchasePrice], [PurchaseCurCode], [InServiceDate], [InvoiceNo], [InvoiceDate], 
							   [AccountingEntryDate], [AccountingEntryJVNo], [BarcodeNumber], [SerialNumber], [Remark], [InstalledAt])
					   VALUES (@CompanyID, @AssetCode, @AssetImage, @AssetDesc, @LocationID, @LocDetailID, @GroupID, @CategoryID, @Donation, @ContactID, 
							   @PurchaseOrderNo, @PurchaseDate, @PurchasePrice, @PurchaseCurCode, @InServiceDate, @InvoiceNo, @InvoiceDate, 
							   @AccountingEntryDate, @AccountingEntryJVNo, @BarcodeNumber, @SerialNumber, @Remark, @InstalledAt);
	
	SELECT SCOPE_IDENTITY()


GO
/****** Object:  StoredProcedure [AT].[stpAssetsInventoryHistory]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpAssetsInventoryHistory] 
(
	@AssetID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT      AT.InventoriesDetails.InvDetailID, AT.InventoriesDetails.InventoryID, AT.InventoriesDetails.AssetID, AT.InventoriesDetails.IsAvailable, AT.InventoriesDetails.AssetCode, AT.InventoriesDetails.AssetDesc, 
                AT.InventoriesDetails.Relocated, ATSET.LocationTypes.Location AS RelocatedLocation, ATSET.LocationDetails.Floor AS RelocatedFloor, ATSET.LocationDetails.Zone AS RelocatedZone, 
                ATSET.LocationDetails.Room AS RelocatedRoom, AT.InventoriesDetails.BarcodeNumber, AT.InventoriesDetails.SerialNumber, 
                AT.InventoriesDetails.Remark, AT.InventoriesDetails.CreatedDate, GSET.Companies.CompanyAbbreviation, LocationTypes_1.Location, LocationDetails_1.Floor, LocationDetails_1.Zone, LocationDetails_1.Room, 
                ATSET.GroupTypes.GroupName, ATSET.CategoryTypes.Category 
	FROM        AT.InventoriesDetails LEFT OUTER JOIN
                ATSET.LocationDetails ON AT.InventoriesDetails.RelocatedLocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
                ATSET.LocationTypes ON AT.InventoriesDetails.RelocatedLocationID = ATSET.LocationTypes.LocationID LEFT OUTER JOIN
                ATSET.LocationTypes AS LocationTypes_1 ON AT.InventoriesDetails.LocationID = LocationTypes_1.LocationID LEFT OUTER JOIN
                ATSET.LocationDetails AS LocationDetails_1 ON AT.InventoriesDetails.LocDetailID = LocationDetails_1.LocDetailID LEFT OUTER JOIN
                GSET.Companies ON AT.InventoriesDetails.CompanyID = GSET.Companies.CompanyID LEFT OUTER JOIN
                ATSET.GroupTypes ON AT.InventoriesDetails.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
                ATSET.CategoryTypes ON AT.InventoriesDetails.CategoryID = ATSET.CategoryTypes.CategoryID
	WHERE		AssetID = @AssetID
	ORDER BY InventoryID

END




GO
/****** Object:  StoredProcedure [AT].[stpAssetsList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsList]
AS
	SET NOCOUNT ON;

	SELECT      AT.Assets.AssetID, AT.Assets.CompanyID, GSET.Companies.CompanyAbbreviation, AT.Assets.AssetCode, AT.Assets.AssetDesc,ATSET.CategoryTypes.Category, 
				ATSET.LocationTypes.Location, 
				ATSET.LocationDetails.[Floor],ATSET.LocationDetails.Room,ATSET.LocationDetails.Zone,
				AT.Assets.StatusID, ATSET.StatusTypes.[Status],
				AT.Assets.BarcodeNumber, AT.Assets.SerialNumber,
				AT.Assets.PurchaseOrderNo, AT.Assets.InvoiceNo 
	FROM        AT.Assets LEFT OUTER JOIN
                ATSET.LocationTypes ON AT.Assets.LocationID = ATSET.LocationTypes.LocationID LEFT OUTER JOIN
				ATSET.LocationDetails ON AT.Assets.LocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
				ATSET.StatusTypes ON AT.Assets.StatusID = ATSET.StatusTypes.StatusID LEFT OUTER JOIN
				ATSET.CategoryTypes ON AT.Assets.CategoryID = ATSET.CategoryTypes.CategoryID LEFT OUTER JOIN
                GSET.Companies ON AT.Assets.CompanyID = GSET.Companies.CompanyID
	ORDER BY	AssetCode



GO
/****** Object:  StoredProcedure [AT].[stpAssetsS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsS]
(
	@AssetID int
)
AS
	SET NOCOUNT ON;

	SELECT * FROM AT.Assets
	WHERE AssetID = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpAssetsStatusRemove]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsStatusRemove]
(
	@StatusID tinyint,
	@StatusDate	date,
	@StatusContactID int,
	@StatusSalePrice float,
	@StatusSaleCurCode char(3),
	@StatusDesc nvarchar(50),
	@CreatedByUserID smallint,
	@CreatedByFullName nvarchar(100),
	@CreatedByDateTime datetime,
	@AssetID int
)
AS
	SET NOCOUNT OFF;
	UPDATE [AT].[Assets] SET [StatusID] = NULL,
							 [StatusDate] = NULL
	WHERE [AssetID] = @AssetID

	INSERT INTO [AT].[StatusHistory] (AssetID, StatusID, StatusDate, StatusDesc, [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], CreatedByUserID, CreatedByFullName, CreatedByDateTime)
							  Values (@AssetID, @StatusID, @StatusDate, @StatusDesc,  @StatusContactID, @StatusSalePrice, @StatusSaleCurCode, @CreatedByUserID, @CreatedByFullName,  @CreatedByDateTime)




GO
/****** Object:  StoredProcedure [AT].[stpAssetsStatusU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsStatusU]
(
	@AssetStatusID tinyint,
	@AssetStatusDate date,
	@StatusID tinyint,
	@StatusDate	date,
	@StatusContactID int,
	@StatusSalePrice float,
	@StatusSaleCurCode char(3),
	@StatusDesc nvarchar(50),
	@CreatedByUserID smallint,
	@CreatedByFullName nvarchar(100),
	@CreatedByDateTime datetime,
	@AssetID int
)
AS
	SET NOCOUNT OFF;
	UPDATE [AT].[Assets] SET [StatusID] = @AssetStatusID,
							 [StatusDate] = @AssetStatusDate
	WHERE [AssetID] = @AssetID

	INSERT INTO [AT].[StatusHistory] (AssetID, StatusID, StatusDate, StatusDesc, [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], CreatedByUserID, CreatedByFullName, CreatedByDateTime)
							  Values (@AssetID, @StatusID, @StatusDate, @StatusDesc,  @StatusContactID, @StatusSalePrice, @StatusSaleCurCode, @CreatedByUserID, @CreatedByFullName,  @CreatedByDateTime)




GO
/****** Object:  StoredProcedure [AT].[stpAssetsU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAssetsU]
(
	@CompanyID smallint,
	@AssetCode nvarchar(15),
	@AssetImage image,
	@AssetDesc nvarchar(50),
	@LocationID smallint,
	@LocDetailID smallint,
	@GroupID smallint,
	@CategoryID smallint,
	@Donation bit,
	@ContactID int,
	@PurchaseOrderNo nvarchar(10),
	@PurchaseDate date,
	@PurchasePrice float,
	@PurchaseCurCode char(3),
	@InServiceDate date,
	@InvoiceNo nvarchar(10),
	@InvoiceDate date,
	@AccountingEntryDate date,
	@AccountingEntryJVNo nvarchar(10),
	@BarcodeNumber nvarchar(20),
	@SerialNumber nvarchar(50),
	@Remark nvarchar(100),
	@InstalledAt nvarchar(50),
	@AssetID int
)
AS
	SET NOCOUNT OFF;
	UPDATE [AT].[Assets] SET [CompanyID] = @CompanyID, 
							 [AssetCode] = @AssetCode, 
							 [AssetImage] = @AssetImage, 
							 [AssetDesc] = @AssetDesc,
							 [LocationID] = @LocationID, 
							 [LocDetailID] = @LocDetailID,
							 [GroupID] = @GroupID,
							 [CategoryID] = @CategoryID, 
							 [Donation] = @Donation,
							 [ContactID] = @ContactID,
							 [PurchaseOrderNo] = @PurchaseOrderNo, 
							 [PurchaseDate] = @PurchaseDate, 
							 [PurchasePrice] = @PurchasePrice, 
							 [PurchaseCurCode] = @PurchaseCurCode, 
							 [InServiceDate] = @InServiceDate, 
							 [InvoiceNo] = @InvoiceNo, 
							 [InvoiceDate] = @InvoiceDate, 
							 [AccountingEntryDate]= @AccountingEntryDate,
							 [AccountingEntryJVNo] = @AccountingEntryJVNo,
							 [BarcodeNumber] = @BarcodeNumber, 
							 [SerialNumber] = @SerialNumber, 
							 [Remark] = @Remark,
							 [InstalledAt] = @InstalledAt
	WHERE [AssetID] = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpAttachmentsD]
(
	@Original_AttID int,
	@Original_AssetID int,
	@Original_AttDesc nvarchar(50),
	@Original_AttFileName nvarchar(255),
	@Original_AttFileExt nchar(5),
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
	DELETE FROM [AT].[Attachments] WHERE (([AttID] = @Original_AttID) AND ([AssetID] = @Original_AssetID) AND ([AttDesc] = @Original_AttDesc) AND ([AttFileName] = @Original_AttFileName) AND ([AttFileExt] = @Original_AttFileExt) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)))




GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpAttachmentsI]
(
	@AssetID int,
	@Attachment varbinary(MAX),
	@AttDesc nvarchar(50),
	@AttFileName nvarchar(255),
	@AttFileExt nchar(5),
	@Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
	INSERT INTO [AT].[Attachments] ([AssetID], [Attachment], [AttDesc], [AttFileName], [AttFileExt], [Remark]) VALUES (@AssetID, @Attachment, @AttDesc, @AttFileName, @AttFileExt, @Remark);
	
	SELECT AttID, AssetID, Attachment, AttDesc, AttFileName, AttFileExt, Remark FROM AT.Attachments WHERE (AttID = SCOPE_IDENTITY())




GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpAttachmentsS]
(
	@AssetID int
)
AS
	SET NOCOUNT ON;
	SELECT AttID, AssetID, Attachment, AttDesc, AttFileName, AttFileExt, Remark FROM AT.Attachments
	WHERE  AssetID = @AssetID




GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpAttachmentsU]
(
	@AssetID int,
	@Attachment varbinary(MAX),
	@AttDesc nvarchar(50),
	@AttFileName nvarchar(255),
	@AttFileExt nchar(5),
	@Remark nvarchar(100),
	@Original_AttID int,
	@Original_AssetID int,
	@Original_AttDesc nvarchar(50),
	@Original_AttFileName nvarchar(255),
	@Original_AttFileExt nchar(5),
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100),
	@AttID int
)
AS
	SET NOCOUNT OFF;
	UPDATE [AT].[Attachments] SET [AssetID] = @AssetID, [Attachment] = @Attachment, [AttDesc] = @AttDesc, [AttFileName] = @AttFileName, [AttFileExt] = @AttFileExt, [Remark] = @Remark WHERE (([AttID] = @Original_AttID) AND ([AssetID] = @Original_AssetID) AND ([AttDesc] = @Original_AttDesc) AND ([AttFileName] = @Original_AttFileName) AND ([AttFileExt] = @Original_AttFileExt) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)));
	
	SELECT AttID, AssetID, Attachment, AttDesc, AttFileName, AttFileExt, Remark FROM AT.Attachments WHERE (AttID = @AttID)




GO
/****** Object:  StoredProcedure [AT].[stpDepreciationLastDelete]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpDepreciationLastDelete]
(
	@DepreciationDate date output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	SET @DepreciationDate = (SELECT TOP 1 DepreciationDate From AT.Depreciations ORDER BY DepreciationDate DESC)
		
	DELETE FROM AT.DepreciationsDetails WHERE DepID = (SELECT DepID FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate)
	DELETE FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate

END




GO
/****** Object:  StoredProcedure [AT].[stpGetAssetCodeList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetAssetCodeList]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT AssetID,AssetCode,CategoryID,CompanyID,LocationID,GroupID,LocDetailID FROM AT.Assets
	ORDER BY AssetID

END




GO
/****** Object:  StoredProcedure [AT].[stpGetDepreciation]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetDepreciation]
AS
	SET NOCOUNT ON;

	SELECT DepID, DepreciationDate FROM AT.Depreciations
	ORDER BY DepreciationDate DESC



GO
/****** Object:  StoredProcedure [AT].[stpGetDepreciationLastDate]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpGetDepreciationLastDate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM AT.Depreciations ORDER BY DepreciationDate DESC
END




GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryFinishInfo]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpGetInventoryFinishInfo]
(
	@InventoryID int
)
AS
	SET NOCOUNT ON;

	SELECT TOP 1	InventoryID, 
					InventoryEndDate,
					InventoryStartDate,
					Relocated = ISNULL((SELECT COUNT(*) FROM AT.InventoriesDetails WHERE Relocated = 1 and InventoryID = @InventoryID),0),
					NotAvailable = ISNULL((SELECT COUNT(*) FROM AT.InventoriesDetails WHERE IsAvailable = 0 and InventoryID = @InventoryID),0),
					AssetsCount = ISNULL((SELECT COUNT(*) FROM AT.InventoriesDetails WHERE InventoryID = @InventoryID),0)
	FROM			AT.Inventories
	WHERE			InventoryID = @InventoryID
	ORDER BY		InventoryID




GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryInfo]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpGetInventoryInfo]
AS
	SET NOCOUNT ON;

	SELECT   InventoryID, CONVERT(varchar, InventoryStartDate, 103) + ' - ' + ISNULL(CONVERT(varchar, InventoryEndDate, 103),'Open Inventory') as Inventory  FROM AT.Inventories
	ORDER BY InventoryID DESC




GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryLastDate]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpGetInventoryLastDate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM AT.Inventories ORDER BY InventoryStartDate DESC
END




GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryMode]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpGetInventoryMode]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNULL(COUNT(*),0) FROM AT.Inventories 
	WHERE InventoryEndDate IS NULL

END




GO
/****** Object:  StoredProcedure [AT].[stpInventoriesDetailsList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoriesDetailsList]
(
	@InventoryID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT      AT.InventoriesDetails.InvDetailID, AT.InventoriesDetails.InventoryID, AT.InventoriesDetails.AssetID, AT.InventoriesDetails.IsAvailable, AT.InventoriesDetails.AssetCode, AT.InventoriesDetails.AssetDesc, 
                AT.InventoriesDetails.Relocated, ATSET.LocationTypes.Location AS RelocatedLocation, ATSET.LocationDetails.Floor AS RelocatedFloor, ATSET.LocationDetails.Zone AS RelocatedZone, 
                ATSET.LocationDetails.Room AS RelocatedRoom, AT.InventoriesDetails.BarcodeNumber, AT.InventoriesDetails.SerialNumber, 
                AT.InventoriesDetails.Remark, AT.InventoriesDetails.CreatedDate, GSET.Companies.CompanyAbbreviation, LocationTypes_1.Location, LocationDetails_1.Floor, LocationDetails_1.Zone, LocationDetails_1.Room, 
                ATSET.GroupTypes.GroupName, ATSET.CategoryTypes.Category 
	FROM        AT.InventoriesDetails LEFT OUTER JOIN
                ATSET.LocationDetails ON AT.InventoriesDetails.RelocatedLocDetailID = ATSET.LocationDetails.LocDetailID LEFT OUTER JOIN
                ATSET.LocationTypes ON AT.InventoriesDetails.RelocatedLocationID = ATSET.LocationTypes.LocationID LEFT OUTER JOIN
                ATSET.LocationTypes AS LocationTypes_1 ON AT.InventoriesDetails.LocationID = LocationTypes_1.LocationID LEFT OUTER JOIN
                ATSET.LocationDetails AS LocationDetails_1 ON AT.InventoriesDetails.LocDetailID = LocationDetails_1.LocDetailID LEFT OUTER JOIN
                GSET.Companies ON AT.InventoriesDetails.CompanyID = GSET.Companies.CompanyID LEFT OUTER JOIN
                ATSET.GroupTypes ON AT.InventoriesDetails.GroupID = ATSET.GroupTypes.GroupID LEFT OUTER JOIN
                ATSET.CategoryTypes ON AT.InventoriesDetails.CategoryID = ATSET.CategoryTypes.CategoryID
	WHERE		InventoryID = @InventoryID

END




GO
/****** Object:  StoredProcedure [AT].[stpInventoryGeneratedList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryGeneratedList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM AT.Inventories
	ORDER BY InventoryStartDate ASC
END




GO
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailable]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryIsAvailable]
(
	@InvDetailID int,
	@IsAvailable bit
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE AT.InventoriesDetails Set IsAvailable = @IsAvailable WHERE InvDetailID = @InvDetailID

END




GO
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailableAllAssets]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryIsAvailableAllAssets]
(
	@InventoryID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    SET NOCOUNT ON;
    UPDATE AT.InventoriesDetails Set IsAvailable = 1 WHERE InventoryID = @InventoryID

	SELECT @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailableByAssetCode]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryIsAvailableByAssetCode]
(
	@AssetCode nvarchar(15),
	@InventoryID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
    UPDATE AT.InventoriesDetails Set IsAvailable = 1 
	WHERE AssetCode = @AssetCode and InventoryID = @InventoryID

END




GO
/****** Object:  StoredProcedure [AT].[stpInventoryRelocatedS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryRelocatedS]
(
	@InvDetailID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	Relocated, RelocatedLocationID, RelocatedLocDetailID, Remark 
	FROM	AT.InventoriesDetails
	WHERE	InvDetailID = @InvDetailID

END




GO
/****** Object:  StoredProcedure [AT].[stpInventoryRelocatedU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpInventoryRelocatedU]
(
	@InvDetailID int,
	@RelocatedLocationID smallint,
	@RelocatedLocDetailID smallint,
	@Remark nvarchar(100),
	@Relocated bit
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE AT.InventoriesDetails Set RelocatedLocationID = @RelocatedLocationID,
									 RelocatedLocDetailID = @RelocatedLocDetailID,
									 Relocated = @Relocated,
									 Remark = @Remark
	
	WHERE InvDetailID = @InvDetailID

END




GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpMaintenancesD]
(
	@Original_MaintID int,
	@Original_AssetID int,
	@Original_FromDate date,
	@Original_ToDate date,
	@Original_SupplierContactID int,
	@Original_Cost float,
	@Original_CurCode char(3),
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [AT].[Maintenances] WHERE (([MaintID] = @Original_MaintID) AND ([AssetID] = @Original_AssetID) AND ([FromDate] = @Original_FromDate) AND ([ToDate] = @Original_ToDate) AND ([SupplierContactID] = @Original_SupplierContactID) AND ([Cost] = @Original_Cost) AND ([CurCode] = @Original_CurCode) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)))



GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpMaintenancesI]
(
	@AssetID int,
	@FromDate date,
	@ToDate date,
	@SupplierContactID int,
	@Cost float,
	@CurCode char(3),
	@Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [AT].[Maintenances] ([AssetID], [FromDate], [ToDate], [SupplierContactID], [Cost], [CurCode], [Remark]) VALUES (@AssetID, @FromDate, @ToDate, @SupplierContactID, @Cost, @CurCode, @Remark);
	
SELECT MaintID, AssetID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark FROM AT.Maintenances WHERE (MaintID = SCOPE_IDENTITY())



GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpMaintenancesS]
(
	@AssetId int
)
AS
	SET NOCOUNT ON;
	SELECT MaintID, AssetID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark FROM AT.Maintenances
	WHERE	AssetID = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpMaintenancesU]
(
	@AssetID int,
	@FromDate date,
	@ToDate date,
	@SupplierContactID int,
	@Cost float,
	@CurCode char(3),
	@Remark nvarchar(100),
	@Original_MaintID int,
	@Original_AssetID int,
	@Original_FromDate date,
	@Original_ToDate date,
	@Original_SupplierContactID int,
	@Original_Cost float,
	@Original_CurCode char(3),
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100),
	@MaintID int
)
AS
	SET NOCOUNT OFF;
UPDATE [AT].[Maintenances] SET [AssetID] = @AssetID, [FromDate] = @FromDate, [ToDate] = @ToDate, [SupplierContactID] = @SupplierContactID, [Cost] = @Cost, [CurCode] = @CurCode, [Remark] = @Remark WHERE (([MaintID] = @Original_MaintID) AND ([AssetID] = @Original_AssetID) AND ([FromDate] = @Original_FromDate) AND ([ToDate] = @Original_ToDate) AND ([SupplierContactID] = @Original_SupplierContactID) AND ([Cost] = @Original_Cost) AND ([CurCode] = @Original_CurCode) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)));
	
SELECT MaintID, AssetID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark FROM AT.Maintenances WHERE (MaintID = @MaintID)



GO
/****** Object:  StoredProcedure [AT].[stpProDepreciation]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpProDepreciation]
(
	@DepreciationDate date,
	@CreatedByUserID smallint,
	@CreatedByFullName nvarchar(100),
	@CreatedByDateTime datetime,
	@Remark nvarchar(100),
	@RowEffected int output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (SELECT COUNT(*) From AT.Depreciations WHERE DepreciationDate = @DepreciationDate) > 0 
	Begin
		DELETE FROM AT.DepreciationsDetails WHERE DepID = (SELECT DepID FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate)
		DELETE FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate
	End

	Declare @DepID int

    INSERT INTO AT.Depreciations(DepreciationDate, Remark, CreatedByUserID, CreatedByFullName, CreatedByDateTime) 
						 Values (@DepreciationDate, @Remark, @CreatedByUserID, @CreatedByFullName, @CreatedByDateTime)

	SET @DepID = (SELECT SCOPE_IDENTITY())

	INSERT INTO AT.DepreciationsDetails (DepID, AssetID, DepreciationRate, 
										 DepreciationValue, 
										 NetBookValue,
										 PurchasePrice, PurchaseCurCode,
										 AccountingEntryJVNo, AccountingEntryDate,
										 GroupID, CategoryID)
								SELECT   @DepID, AT.Assets.AssetID, ATSET.GroupTypes.DepreciationRate,
										 Round((PurchasePrice * ATSET.GroupTypes.DepreciationRate / 100) * (DateDiff(D,AccountingEntryDate,@DepreciationDate)+1) / 365,2), 
										 Round(PurchasePrice - ((PurchasePrice * ATSET.GroupTypes.DepreciationRate / 100) * (DateDiff(D,AccountingEntryDate,@DepreciationDate)+1) / 365),2),
										 AT.Assets.PurchasePrice, AT.Assets.PurchaseCurCode,
										 AT.Assets.AccountingEntryJVNo, AT.Assets.AccountingEntryDate,
										 AT.Assets.GroupID, AT.Assets.CategoryID
								FROM	 AT.Assets LEFT OUTER JOIN
										 ATSET.GroupTypes ON AT.Assets.GroupID = ATSET.GroupTypes.GroupID
								WHERE    (StatusID Is Null Or StatusID = 8)
									AND  AccountingEntryDate < @DepreciationDate
									AND  PurchasePrice > 0
									AND  (
											AssetID IN (SELECT AssetID From AT.DepreciationsDetails WHERE NetBookValue > 0 AND DepID IN (SELECT Top 1 DepID FROM AT.Depreciations WHERE DepID <> @DepID ORDER BY DepreciationDate DESC))
										    OR
											Not AssetID IN (SELECT AssetID From AT.DepreciationsDetails)
										 )
											  

	UPDATE AT.DepreciationsDetails SET NetBookValue = 0 WHERE NetBookValue < 0

	SET @RowEffected = (SELECT COUNT(*) FROM AT.DepreciationsDetails WHERE DepID = @DepID)
END




GO
/****** Object:  StoredProcedure [AT].[stpProInventoryEnd]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpProInventoryEnd]
(
	@InventoryID int,
	@InventoryEndDate date,
	@CreatedByUserID smallint,
	@CreatedByFullName nvarchar(100),
	@CreatedByDateTime datetime
)
AS
	SET NOCOUNT ON;

	UPDATE	AT.Assets SET LocationID = InvD.RelocatedLocationID, LocDetailID = InvD.RelocatedLocDetailID
	FROM	AT.Assets Ast Inner Join AT.InventoriesDetails InvD On Ast.AssetID = InvD.AssetID
	WHERE	InvD.Relocated = 1 AND InvD.InventoryID = @InventoryID

	UPDATE	AT.Assets SET StatusID = 6, StatusDate = @InventoryEndDate
	FROM	AT.Assets Ast Inner Join AT.InventoriesDetails InvD On Ast.AssetID = InvD.AssetID
	WHERE	InvD.IsAvailable = 0 AND InvD.InventoryID = @InventoryID

	INSERT INTO [AT].[StatusHistory] (AssetID, StatusID, StatusDate, StatusDesc, [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], CreatedByUserID, CreatedByFullName, CreatedByDateTime)
							  SELECT  AssetID, 6, @InventoryEndDate, 'Not found during Inventory',  NULL, 0, NULL, @CreatedByUserID, @CreatedByFullName,  @CreatedByDateTime
							  FROM	  AT.InventoriesDetails 
							  WHERE	  AT.InventoriesDetails.IsAvailable = 0 AND AT.InventoriesDetails.InventoryID = @InventoryID

	UPDATE	AT.Inventories SET InventoryEndDate = @InventoryEndDate,
							   EndCreatedByUserID = @CreatedByUserID,
							   EndCreatedByFullName = @CreatedByFullName,
							   EndCreatedByDateTime = @CreatedByDateTime
	WHERE	InventoryID = @InventoryID





GO
/****** Object:  StoredProcedure [AT].[stpProInventoryStart]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpProInventoryStart]
(
	@InventoryStartDate date,
	@StartCreatedByUserID smallint,
	@StartCreatedByFullName nvarchar(100),
	@StartCreatedByDateTime datetime,
	@Remark nvarchar(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @InventoryID int

    INSERT INTO AT.Inventories (InventoryStartDate, Remark, StartCreatedByUserID,StartCreatedByFullName,StartCreatedByDateTime) 
						Values (@InventoryStartDate,@Remark, @StartCreatedByUserID,@StartCreatedByFullName,@StartCreatedByDateTime)

	SET @InventoryID = (SELECT SCOPE_IDENTITY())

	INSERT INTO AT.InventoriesDetails ( InventoryID, AssetID, IsAvailable, AssetCode, AssetDesc,
										Relocated, RelocatedLocationID, RelocatedLocDetailID,
										CompanyID, LocationID, LocDetailID, GroupID, CategoryID,
										BarcodeNumber, SerialNumber, Remark )
								SELECT  @InventoryID, AssetID, 0, AssetCode, AssetDesc,
										0, NULL, NULL,
										CompanyID, LocationID, LocDetailID, GroupID, CategoryID,
										BarcodeNumber, SerialNumber, NULL
								FROM	AT.Assets
								WHERE   StatusID Is Null 

	SELECT @@ROWCOUNT
END




GO
/****** Object:  StoredProcedure [AT].[stpProInventoryStartRefresh]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [AT].[stpProInventoryStartRefresh]
(
	@InventoryID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO AT.InventoriesDetails ( InventoryID, AssetID, IsAvailable, AssetCode, AssetDesc,
										Relocated, RelocatedLocationID, RelocatedLocDetailID,
										CompanyID, LocationID, LocDetailID, GroupID, CategoryID,
										BarcodeNumber, SerialNumber, Remark )
								SELECT  @InventoryID, AssetID, 0, AssetCode, AssetDesc,
										0, NULL, NULL,
										CompanyID, LocationID, LocDetailID, GroupID, CategoryID,
										BarcodeNumber, SerialNumber, NULL
								FROM	AT.Assets
								WHERE   StatusID Is Null And Not AssetID In (SELECT AssetID From AT.InventoriesDetails WHERE InventoryID = @InventoryID)
END




GO
/****** Object:  StoredProcedure [AT].[stpStatusHistoryS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpStatusHistoryS]
(
	@AssetID int
)
AS
	SET NOCOUNT ON;
	SELECT	AT.StatusHistory.StatusHistID, AT.StatusHistory.AssetID, AT.StatusHistory.StatusID, AT.StatusHistory.StatusDate, AT.StatusHistory.StatusDesc, GTBL.Contacts.ContactName, AT.StatusHistory.StatusSalePrice, 
			AT.StatusHistory.StatusSaleCurCode, AT.StatusHistory.CreatedByUserID, AT.StatusHistory.CreatedByFullName, AT.StatusHistory.CreatedByDateTime
	FROM    AT.StatusHistory LEFT OUTER JOIN
            GTBL.Contacts ON AT.StatusHistory.StatusContactID = GTBL.Contacts.ContactID
	WHERE	AssetID = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpWarrantiesD]
(
	@Original_WarntID int,
	@Original_AssetID int,
	@Original_WarrantyDesc nvarchar(50),
	@Original_FromDate date,
	@Original_ToDate date,
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [AT].[Warranties] WHERE (([WarntID] = @Original_WarntID) AND ([AssetID] = @Original_AssetID) AND ([WarrantyDesc] = @Original_WarrantyDesc) AND ([FromDate] = @Original_FromDate) AND ([ToDate] = @Original_ToDate) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)))



GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpWarrantiesI]
(
	@AssetID int,
	@WarrantyDesc nvarchar(50),
	@FromDate date,
	@ToDate date,
	@Remark nvarchar(100)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [AT].[Warranties] ([AssetID], [WarrantyDesc], [FromDate], [ToDate], [Remark]) VALUES (@AssetID, @WarrantyDesc, @FromDate, @ToDate, @Remark);
	
SELECT WarntID, AssetID, WarrantyDesc, FromDate, ToDate, Remark FROM AT.Warranties WHERE (WarntID = SCOPE_IDENTITY())



GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpWarrantiesS]
(
	@AssetId int
)
AS
	SET NOCOUNT ON;
	SELECT	WarntID, AssetID, WarrantyDesc, FromDate, ToDate, Remark FROM AT.Warranties
	WHERE	AssetID = @AssetID



GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpWarrantiesU]
(
	@AssetID int,
	@WarrantyDesc nvarchar(50),
	@FromDate date,
	@ToDate date,
	@Remark nvarchar(100),
	@Original_WarntID int,
	@Original_AssetID int,
	@Original_WarrantyDesc nvarchar(50),
	@Original_FromDate date,
	@Original_ToDate date,
	@IsNull_Remark Int,
	@Original_Remark nvarchar(100),
	@WarntID int
)
AS
	SET NOCOUNT OFF;
UPDATE [AT].[Warranties] SET [AssetID] = @AssetID, [WarrantyDesc] = @WarrantyDesc, [FromDate] = @FromDate, [ToDate] = @ToDate, [Remark] = @Remark WHERE (([WarntID] = @Original_WarntID) AND ([AssetID] = @Original_AssetID) AND ([WarrantyDesc] = @Original_WarrantyDesc) AND ([FromDate] = @Original_FromDate) AND ([ToDate] = @Original_ToDate) AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark)));
	
SELECT WarntID, AssetID, WarrantyDesc, FromDate, ToDate, Remark FROM AT.Warranties WHERE (WarntID = @WarntID)



GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesD]
(
	@Original_CategoryID smallint,
	@Original_Category nvarchar(50),
	@Original_GroupID smallint
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ATSET].[CategoryTypes] WHERE (([CategoryID] = @Original_CategoryID) AND ([Category] = @Original_Category) AND ([GroupID] = @Original_GroupID))




GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesI]
(
	@Category nvarchar(50),
	@GroupID smallint
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ATSET].[CategoryTypes] ([Category], [GroupID]) VALUES (@Category, @GroupID);
	
SELECT CategoryID, Category, GroupID FROM ATSET.CategoryTypes WHERE (CategoryID = SCOPE_IDENTITY())




GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesS]
AS
	SET NOCOUNT ON;
SELECT CategoryID, Category, GroupID FROM ATSET.CategoryTypes




GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesU]
(
	@Category nvarchar(50),
	@GroupID smallint,
	@Original_CategoryID smallint,
	@Original_Category nvarchar(50),
	@Original_GroupID smallint,
	@CategoryID smallint
)
AS
	SET NOCOUNT OFF;
UPDATE [ATSET].[CategoryTypes] SET [Category] = @Category, [GroupID] = @GroupID WHERE (([CategoryID] = @Original_CategoryID) AND ([Category] = @Original_Category) AND ([GroupID] = @Original_GroupID));
	
SELECT CategoryID, Category, GroupID FROM ATSET.CategoryTypes WHERE (CategoryID = @CategoryID)




GO
/****** Object:  StoredProcedure [ATSET].[stpGetAssetCode]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetAssetCode]
(
	@Generate bit,
	@AssetCode nvarchar(15) output
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @AssetCodeAcronym nvarchar(5) = (SELECT TOP 1 SetValue From ATSET.Settings WHERE SetID = 1)
	DECLARE @AssetCodeLength tinyint = ISNULL((SELECT TOP 1 SetValue From ATSET.Settings WHERE SetID = 2),0)
	DECLARE @AssetCodeCounter int = (SELECT TOP 1 SetValue From ATSET.Settings WHERE SetID = 3)

	If @AssetCodeLength > 10
		Set @AssetCodeLength = 10

	If Len(@AssetCodeAcronym) > 5 
		Set @AssetCodeAcronym = SubString(@AssetCodeAcronym,1,5)
	
	SET @AssetCode = (@AssetCodeAcronym + REPLICATE('0', @AssetCodeLength - LEN(Cast(@AssetCodeCounter as varchar(15)))) + CAST(@AssetCodeCounter + 1 as varchar(15)))	

	If @Generate = 1 Update ATSET.Settings Set SetValue = SetValue + 1 WHERE SetID = 3
END




GO
/****** Object:  StoredProcedure [ATSET].[stpGetCategoryTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetCategoryTypes]
AS
	SET NOCOUNT ON;

	SELECT * FROM ATSET.CategoryTypes
	ORDER BY Category



GO
/****** Object:  StoredProcedure [ATSET].[stpGetGroupTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetGroupTypes]
AS
	SET NOCOUNT ON;

	SELECT GroupID, GroupName, Acronym, DepreciationRate FROM ATSET.GroupTypes
	ORDER BY GroupName



GO
/****** Object:  StoredProcedure [ATSET].[stpGetLocationDetails]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetLocationDetails]
AS
	SET NOCOUNT ON;
	SELECT * FROM ATSET.LocationDetails
	ORDER BY Floor



GO
/****** Object:  StoredProcedure [ATSET].[stpGetLocationTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetLocationTypes]
AS
	SET NOCOUNT ON;
	SELECT LocationID, Location FROM ATSET.LocationTypes
	ORDER BY Location



GO
/****** Object:  StoredProcedure [ATSET].[stpGetSettings]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetSettings]
AS
	SET NOCOUNT OFF;

	SELECT * FROM ATSET.Settings
	ORDER BY SetID



GO
/****** Object:  StoredProcedure [ATSET].[stpGetStatusTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetStatusTypes]
AS
	SET NOCOUNT ON;

	SELECT StatusID,[Status] FROM ATSET.StatusTypes
	ORDER BY StatusID



GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGroupTypesD]
(
	@Original_GroupID smallint,
	@Original_GroupName nvarchar(50),
	@Original_Acronym nvarchar(5),
	@Original_DepreciationRate tinyint,
	@IsNull_AccountNo Int,
	@Original_AccountNo nvarchar(20),
	@Original_AccountingExclusion bit
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ATSET].[GroupTypes] WHERE (([GroupID] = @Original_GroupID) AND ([GroupName] = @Original_GroupName) AND ([Acronym] = @Original_Acronym) AND ([DepreciationRate] = @Original_DepreciationRate) AND ((@IsNull_AccountNo = 1 AND [AccountNo] IS NULL) OR ([AccountNo] = @Original_AccountNo)) AND ([AccountingExclusion] = @Original_AccountingExclusion))
GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGroupTypesI]
(
	@GroupName nvarchar(50),
	@Acronym nvarchar(5),
	@DepreciationRate tinyint,
	@AccountNo nvarchar(20),
	@AccountingExclusion bit
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ATSET].[GroupTypes] ([GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion]) VALUES (@GroupName, @Acronym, @DepreciationRate, @AccountNo, @AccountingExclusion);
	
SELECT GroupID, GroupName, Acronym, DepreciationRate, AccountNo, AccountingExclusion FROM ATSET.GroupTypes WHERE (GroupID = SCOPE_IDENTITY())
GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGroupTypesS]
AS
	SET NOCOUNT ON;
SELECT GroupID, GroupName, Acronym, DepreciationRate, AccountNo, AccountingExclusion FROM ATSET.GroupTypes
GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGroupTypesU]
(
	@GroupName nvarchar(50),
	@Acronym nvarchar(5),
	@DepreciationRate tinyint,
	@AccountNo nvarchar(20),
	@AccountingExclusion bit,
	@Original_GroupID smallint,
	@Original_GroupName nvarchar(50),
	@Original_Acronym nvarchar(5),
	@Original_DepreciationRate tinyint,
	@IsNull_AccountNo Int,
	@Original_AccountNo nvarchar(20),
	@Original_AccountingExclusion bit,
	@GroupID smallint
)
AS
	SET NOCOUNT OFF;
UPDATE [ATSET].[GroupTypes] SET [GroupName] = @GroupName, [Acronym] = @Acronym, [DepreciationRate] = @DepreciationRate, [AccountNo] = @AccountNo, [AccountingExclusion] = @AccountingExclusion WHERE (([GroupID] = @Original_GroupID) AND ([GroupName] = @Original_GroupName) AND ([Acronym] = @Original_Acronym) AND ([DepreciationRate] = @Original_DepreciationRate) AND ((@IsNull_AccountNo = 1 AND [AccountNo] IS NULL) OR ([AccountNo] = @Original_AccountNo)) AND ([AccountingExclusion] = @Original_AccountingExclusion));
	
SELECT GroupID, GroupName, Acronym, DepreciationRate, AccountNo, AccountingExclusion FROM ATSET.GroupTypes WHERE (GroupID = @GroupID)
GO
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationDetailD]
(
	@LocDetailID smallint
)
AS
	SET NOCOUNT OFF;
	DELETE FROM [ATSET].[LocationDetails] WHERE [LocDetailID] = @LocDetailID



GO
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationDetailI]
(
	@LocationID smallint,
	@Floor nvarchar(20),
	@Zone nvarchar(20),
	@Room nvarchar(20)
)
AS
	SET NOCOUNT OFF;
	INSERT INTO [ATSET].[LocationDetails] ([LocationID], [Floor], [Zone], [Room]) VALUES (@LocationID, @Floor, @Zone, @Room);
	SELECT SCOPE_IDENTITY()




GO
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationDetailS]
(
	@LocationID smallint
)
AS
	SET NOCOUNT ON;
	SELECT LocDetailID, LocationID, Floor, Zone, Room FROM ATSET.LocationDetails
	WHERE LocationID = @LocationID



GO
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationDetailU]
(
	@Floor nvarchar(20),
	@Zone nvarchar(20),
	@Room nvarchar(20),
	@LocDetailID smallint
)
AS
	SET NOCOUNT OFF;
	UPDATE [ATSET].[LocationDetails] SET [Floor] = @Floor, 
										 [Zone] = @Zone, 
										 [Room] = @Room 
	WHERE [LocDetailID] = @LocDetailID
	




GO
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationTypesD]
(
	@LocationID smallint
)
AS
	SET NOCOUNT OFF;
	DELETE FROM [ATSET].[LocationTypes] WHERE [LocationID] = @LocationID



GO
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationTypesI]
(
	@Location nvarchar(50)
)
AS
	SET NOCOUNT OFF;

	INSERT INTO [ATSET].[LocationTypes] ([Location]) VALUES (@Location);
	SELECT SCOPE_IDENTITY()



GO
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpLocationTypesU]
(
	@Location nvarchar(50),
	@LocationID smallint
)
AS
	SET NOCOUNT OFF;
	UPDATE [ATSET].[LocationTypes] SET [Location] = @Location 
	WHERE [LocationID] = @LocationID
	




GO
/****** Object:  StoredProcedure [ATSET].[stpSettingsU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpSettingsU]
(
	@SetID tinyint,
	@SetValue nvarchar(250)
)
AS
	SET NOCOUNT OFF;

	UPDATE	[ATSET].[Settings] SET [SetValue] = @SetValue
	WHERE	SetID = @SetID




GO
/****** Object:  StoredProcedure [GSET].[stpBanksD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpBanksD]
(
	@BankID smallint
)
AS
	SET NOCOUNT OFF;
	DELETE FROM [GSET].[Banks] WHERE [BankID] = @BankID




GO
/****** Object:  StoredProcedure [GSET].[stpBanksI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpBanksI]
(
	@BankName nvarchar(100),
	@AccountNo nvarchar(50),
	@Branch nvarchar(50)
)
AS
	SET NOCOUNT OFF;
	INSERT INTO [GSET].[Banks] ([BankName], [AccountNo], [Branch]) VALUES (@BankName, @AccountNo, @Branch);
	
	SELECT SCOPE_IDENTITY()




GO
/****** Object:  StoredProcedure [GSET].[stpBanksList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpBanksList]
AS
	SET NOCOUNT ON;
	SELECT BankID, BankName, AccountNo, Branch FROM GSET.Banks 
	ORDER BY BankName, AccountNo




GO
/****** Object:  StoredProcedure [GSET].[stpBanksS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpBanksS]
(
	@BankID smallint
)
AS
	SET NOCOUNT ON;
	SELECT BankID, BankName, AccountNo, Branch FROM GSET.Banks
	WHERE BankID = @BankID




GO
/****** Object:  StoredProcedure [GSET].[stpBanksU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpBanksU]
(
	@BankName nvarchar(100),
	@AccountNo nvarchar(50),
	@Branch nvarchar(50),
	@BankID smallint
)
AS
	SET NOCOUNT OFF;
	UPDATE [GSET].[Banks] SET	[BankName] = @BankName, 
								[AccountNo] = @AccountNo, 
								[Branch] = @Branch 
	WHERE [BankID] = @BankID




GO
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail1]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetAddressDetail1]
AS
	SET NOCOUNT ON;
	SELECT * FROM GSET.AddressDetail1
	ORDER BY AddressDetail1



GO
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail2]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetAddressDetail2]
AS
	SET NOCOUNT ON;
	SELECT * FROM GSET.AddressDetail2
	ORDER BY AddressDetail2



GO
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail3]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetAddressDetail3]
AS
	SET NOCOUNT ON;
	SELECT * FROM GSET.AddressDetail3
	ORDER BY AddressDetail3



GO
/****** Object:  StoredProcedure [GSET].[stpGetAddressTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetAddressTypes]
AS
	SET NOCOUNT ON;
	SELECT AddressTypeID, AddressType FROM GSET.AddressTypes
	ORDER BY AddressType



GO
/****** Object:  StoredProcedure [GSET].[stpGetBanks]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetBanks]
AS
	SET NOCOUNT ON;
	SELECT BankID,BankName,AccountNo FROM GSET.Banks
	ORDER BY BankName



GO
/****** Object:  StoredProcedure [GSET].[stpGetCities]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetCities]
AS
	SET NOCOUNT ON;
	SELECT CityID,City,CountryID FROM GSET.Cities
	ORDER BY City




GO
/****** Object:  StoredProcedure [GSET].[stpGetCompanies]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetCompanies]
AS
	SET NOCOUNT ON;
	SELECT CompanyID,CompanyName,CompanyAbbreviation,CompanyPrmCurcode,CompanyScdCurCode,FormalHRCurCode,Offshore FROM GSET.Companies
	ORDER BY CompanyName



GO
/****** Object:  StoredProcedure [GSET].[stpGetContactTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GSET].[stpGetContactTypes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM GSET.ContactTypes 
	ORDER BY ContactType
END




GO
/****** Object:  StoredProcedure [GSET].[stpGetCountries]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetCountries]
AS
	SET NOCOUNT ON;
	SELECT CountryID, Country, Nationality, ZipCode, Flag FROM GSET.Countries
	ORDER BY Country



GO
/****** Object:  StoredProcedure [GSET].[stpGetCurrencies]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetCurrencies]
AS
	SET NOCOUNT ON;
	SELECT CurCode FROM GSET.Currencies
	ORDER BY CurCode



GO
/****** Object:  StoredProcedure [GSET].[stpGetLogSeverity]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetLogSeverity]
AS
	SET NOCOUNT ON;
	SELECT	LogSeverityID,LogSeverity FROM GSET.LogSeverity
	ORDER BY LogSeverityID



GO
/****** Object:  StoredProcedure [GSET].[stpGetLogSystem]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetLogSystem]
AS
	SET NOCOUNT ON;
	SELECT	LogSystemID,LogSystem FROM GSET.LogSystem
	ORDER BY LogSystem



GO
/****** Object:  StoredProcedure [GSET].[stpGetLogTypes]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetLogTypes]
AS
	SET NOCOUNT ON;
	SELECT	LogTypeID,LogType FROM GSET.LogTypes
	ORDER BY LogType



GO
/****** Object:  StoredProcedure [GSET].[stpGetSettings]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetSettings]
AS
	SET NOCOUNT ON;
	SELECT * FROM GSET.Settings
	ORDER BY SetID



GO
/****** Object:  StoredProcedure [GSET].[stpGetWorkingCountry]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpGetWorkingCountry]
AS
	SET NOCOUNT ON;

	SELECT CountryID,Country FROM GSET.Countries
	WHERE WorkingCountry = 1
	ORDER BY Country



GO
/****** Object:  StoredProcedure [GSET].[stpSettingsU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpSettingsU]
(
	@SetID tinyint,
	@SetValue nvarchar(250)
)
AS
	SET NOCOUNT OFF;

	UPDATE	[GSET].[Settings] SET [SetValue] = @SetValue
	WHERE	SetID = @SetID




GO
/****** Object:  StoredProcedure [GTBL].[stpContactsD]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpContactsD]
(
	@ContactID int
)
AS
	SET NOCOUNT OFF;

	DELETE FROM [GTBL].[Contacts] 
	WHERE [ContactID] = @ContactID



GO
/****** Object:  StoredProcedure [GTBL].[stpContactsI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpContactsI]
(
	@ContactName nvarchar(100),
	@ContactTypeID tinyint,
	@ContactPerson nvarchar(100),
	@ContactPersonEmail nvarchar(50),
	@FinancialContact nvarchar(100),
	@FinancialContactEmail nvarchar(50),
	@Address nvarchar(200),
	@CountryID char(2),
	@Telephone1 varchar(16),
	@Telephone2 varchar(16),
	@Mobile1 varchar(16),
	@Mobile2 varchar(16),
	@Fax1 varchar(16),
	@Fax2 varchar(16),
	@Remark nvarchar(500)
)
AS
	SET NOCOUNT OFF;
	INSERT INTO [GTBL].[Contacts] ([ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (@ContactName, @ContactTypeID, @ContactPerson, @ContactPersonEmail, @FinancialContact, @FinancialContactEmail, @Address, @CountryID, @Telephone1, @Telephone2, @Mobile1, @Mobile2, @Fax1, @Fax2, @Remark);
	
	SELECT SCOPE_IDENTITY()



GO
/****** Object:  StoredProcedure [GTBL].[stpContactsList]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpContactsList]
AS
	SET NOCOUNT ON;

	SELECT      GTBL.Contacts.ContactID, GTBL.Contacts.ContactName, GTBL.Contacts.ContactTypeID, GTBL.Contacts.ContactPerson,
				GSET.Countries.Country, GTBL.Contacts.Telephone1, GTBL.Contacts.Mobile1
	FROM        GTBL.Contacts LEFT OUTER JOIN
				GSET.Countries ON GTBL.Contacts.CountryID = GSET.Countries.CountryID
	ORDER BY GTBL.Contacts.ContactName ASC



GO
/****** Object:  StoredProcedure [GTBL].[stpContactsS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpContactsS]
(
	@ContactID int
)
AS
	SET NOCOUNT ON;
	
	SELECT *
	FROM	GTBL.Contacts
	WHERE	ContactID = @ContactID



GO
/****** Object:  StoredProcedure [GTBL].[stpContactsU]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpContactsU]
(
	@ContactName nvarchar(100),
	@ContactTypeID tinyint,
	@ContactPerson nvarchar(100),
	@ContactPersonEmail nvarchar(50),
	@FinancialContact nvarchar(100),
	@FinancialContactEmail nvarchar(50),
	@Address nvarchar(200),
	@CountryID char(2),
	@Telephone1 varchar(16),
	@Telephone2 varchar(16),
	@Mobile1 varchar(16),
	@Mobile2 varchar(16),
	@Fax1 varchar(16),
	@Fax2 varchar(16),
	@Remark nvarchar(500),
	@ContactID int
)
AS
	SET NOCOUNT OFF;

	UPDATE [GTBL].[Contacts] SET	[ContactName] = @ContactName, 
									[ContactTypeID] = @ContactTypeID, 
									[ContactPerson] = @ContactPerson, 
									[ContactPersonEmail] = @ContactPersonEmail, 
									[FinancialContact] = @FinancialContact, 
									[FinancialContactEmail] = @FinancialContactEmail, 
									[Address] = @Address, 
									[CountryID] = @CountryID, 
									[Telephone1] = @Telephone1, 
									[Telephone2] = @Telephone2, 
									[Mobile1] = @Mobile1, 
									[Mobile2] = @Mobile2, 
									[Fax1] = @Fax1, 
									[Fax2] = @Fax2, 
									[Remark] = @Remark 
	WHERE [ContactID] = @ContactID
	



GO
/****** Object:  StoredProcedure [GTBL].[stpGetContacts]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GTBL].[stpGetContacts]
AS
	SET NOCOUNT ON;
	
	SELECT	ContactID, ContactName, ContactTypeID
	FROM	GTBL.Contacts
	ORDER	By ContactName



GO
/****** Object:  StoredProcedure [GTBL].[stpLogI]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GTBL].[stpLogI]
(
	@UserID smallint,
	@FullName nvarchar(100),
	@DateTime datetime,
	@Computer nvarchar(255),
	@DomainUser nvarchar(255),
	@LogSystemID tinyint,
	@LogSeverityID tinyint,
	@LogTypeID tinyint,
	@FormName nvarchar(255),
	@MethodName nvarchar(255),
	@LogDesc text,
	@SentByEmail bit
)
AS
	SET NOCOUNT OFF;
	INSERT INTO [GTBL].[Logs] ([UserID], [FullName], [DateTime], 
							   [DomainUser], [Computer], 
							   [SQLHostName],[SQLLoggedName], [SQLCurrentUser],
							   [LogSystemID], [LogSeverityID], [LogTypeID], 
							   [FormName], [MethodName], 
							   [LogDesc], [SentByEmail]) 
						VALUES (@UserID, @FullName, @DateTime, 
							   @DomainUser, @Computer, 
							   HOST_NAME(), SUSER_NAME(), CURRENT_USER, 
							   @LogSystemID, @LogSeverityID, @LogTypeID, 
							   @FormName, @MethodName, 
							   @LogDesc, @SentByEmail);
	




GO
/****** Object:  StoredProcedure [GTBL].[stpLogS]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GTBL].[stpLogS]
AS
	SET NOCOUNT ON;
	SELECT * FROM GTBL.Logs
	ORDER BY [DateTime]




GO
/****** Object:  StoredProcedure [SEC].[stpGetLoginUser]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SEC].[stpGetLoginUser]
    @UserName  NVARCHAR(100),
    @Password  NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [UserID], [UserName], [FullName], [HR], [Asset], [Contact]
    FROM   [SEC].[Users]
    WHERE  [UserName]     = @UserName
      AND  [PasswordHash] = HASHBYTES('SHA2_256', @Password)
      AND  [PasswordHash] IS NOT NULL
END
GO
/****** Object:  StoredProcedure [SEC].[stpGetRoles]    Script Date: 11/05/2026 1:22:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SEC].[stpGetRoles]
AS
	SET NOCOUNT ON;

	SELECT RoleID, [RoleName] FROM SEC.Roles
	ORDER BY [RoleName]



GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'GTBL', @level1type=N'TABLE',@level1name=N'Logs', @level2type=N'COLUMN',@level2name=N'LogSystemID'
GO
USE [master]
GO
ALTER DATABASE [Assets] SET  READ_WRITE 
GO
