USE [master]
GO
/****** Object:  Database [Assets]    Script Date: 09/07/2026 11:18:03 AM ******/
CREATE DATABASE [Assets]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'E-Unity', FILENAME = N'D:\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\Assets.mdf' , SIZE = 9088KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
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
/****** Object:  User [saAsset]    Script Date: 09/07/2026 11:18:03 AM ******/
CREATE USER [saAsset] FOR LOGIN [saAsset] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [saAsset]
GO
/****** Object:  Schema [AT]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [AT]
GO
/****** Object:  Schema [ATSET]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [ATSET]
GO
/****** Object:  Schema [GSET]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [GSET]
GO
/****** Object:  Schema [GTBL]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [GTBL]
GO
/****** Object:  Schema [NOTIF]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [NOTIF]
GO
/****** Object:  Schema [SEC]    Script Date: 09/07/2026 11:18:04 AM ******/
CREATE SCHEMA [SEC]
GO
/****** Object:  UserDefinedFunction [AT].[fnLastInventoryDateByItem]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [AT].[Assets]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Assets](
	[AssetID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [smallint] NOT NULL,
	[AssetCode] [nvarchar](20) NOT NULL,
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
	[BrandID] [smallint] NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[StatusID] [tinyint] NOT NULL,
	[StatusDate] [date] NULL,
	[Remark] [nvarchar](100) NULL,
	[InstalledAt] [nvarchar](50) NULL,
	[OwnerID] [tinyint] NOT NULL,
	[OwnerInfo] [nvarchar](50) NULL,
	[HREmpIDUsedBy] [nchar](10) NULL,
 CONSTRAINT [PK_Assets] PRIMARY KEY CLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AT].[Attachments]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Attachments](
	[AttID] [int] IDENTITY(1,1) NOT NULL,
	[AssetID] [int] NOT NULL,
	[AttDesc] [nvarchar](50) NOT NULL,
	[AttFileName] [nvarchar](255) NOT NULL,
	[AttFileExt] [nchar](5) NOT NULL,
	[Remark] [nvarchar](100) NULL,
	[FilePath] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Attachments] PRIMARY KEY CLUSTERED 
(
	[AttID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[Depreciations]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[CompanyID] [smallint] NULL,
 CONSTRAINT [PK_Depreciations] PRIMARY KEY CLUSTERED 
(
	[DepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[DepreciationsDetails]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [AT].[Inventories]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT].[Inventories](
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryStartDate] [date] NOT NULL,
	[InventoryEndDate] [date] NULL,
	[Remark] [nvarchar](100) NULL,
	[CompanyID] [smallint] NOT NULL,
	[StartCreatedByUserID] [smallint] NOT NULL,
	[StartCreatedByFullName] [nvarchar](100) NOT NULL,
	[StartCreatedByDateTime] [datetime] NOT NULL,
	[EndCreatedByUserID] [smallint] NULL,
	[EndCreatedByFullName] [nvarchar](100) NULL,
	[EndCreatedByDateTime] [datetime] NULL,
 CONSTRAINT [PK_Inventories] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[InventoriesDetails]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [AT].[Maintenances]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[AttID] [int] NULL,
 CONSTRAINT [PK_Maintenances] PRIMARY KEY CLUSTERED 
(
	[MaintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AT].[StatusHistory]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [AT].[Warranties]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[AttID] [int] NULL,
 CONSTRAINT [PK_Warranties] PRIMARY KEY CLUSTERED 
(
	[WarntID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[BrandTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[BrandTypes](
	[BrandID] [smallint] IDENTITY(1,1) NOT NULL,
	[BrandDesc] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_BrandTypes] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[CategoryTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[CategoryTypes](
	[CategoryID] [smallint] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[GroupTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[CountryID] [char](10) NOT NULL,
 CONSTRAINT [PK_GroupTypes] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[LocationDetails]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [ATSET].[LocationTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[OwnerTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ATSET].[OwnerTypes](
	[OwnerID] [tinyint] NOT NULL,
	[OwnerDesc] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_OwnerTypes] PRIMARY KEY CLUSTERED 
(
	[OwnerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ATSET].[Settings]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [ATSET].[StatusTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail1]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail2]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[AddressDetail3]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [GSET].[Companies]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[HRCompanyProfileID] [smallint] NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[ContactTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Countries]    Script Date: 09/07/2026 11:18:04 AM ******/
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
	[AssetCodeCounter] [int] NOT NULL,
	[HRConnect] [bit] NOT NULL,
	[HRDatabase] [nvarchar](50) NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Currencies]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[CurrenciesRates]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [GSET].[LogSeverity]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[LogSystem]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[LogTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GSET].[Settings]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [GTBL].[Contacts]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [GTBL].[Logs]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  Table [NOTIF].[NotificationLogs]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NOTIF].[NotificationLogs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](20) NOT NULL,
	[EntityID] [int] NOT NULL,
	[IntervalLabel] [nvarchar](30) NOT NULL,
	[SentAt] [datetime] NOT NULL,
 CONSTRAINT [PK_NotificationLogs] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [NOTIF].[Notifications]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NOTIF].[Notifications](
	[NotifID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [smallint] NOT NULL,
	[CompanyID] [smallint] NOT NULL,
	[Type] [nvarchar](20) NOT NULL,
	[EntityID] [int] NOT NULL,
	[AssetID] [int] NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[IsRead] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[NotifID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SEC].[Roles]    Script Date: 09/07/2026 11:18:04 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SEC].[Users]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SEC].[Users](
	[UserID] [smallint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[UserPassword] [varbinary](512) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[RoleID] [tinyint] NOT NULL,
	[EmailAddress] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SEC].[UsersPermissions]    Script Date: 09/07/2026 11:18:04 AM ******/
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
SET IDENTITY_INSERT [AT].[Assets] ON 
GO
INSERT [AT].[Assets] ([AssetID], [CompanyID], [AssetCode], [AssetImage], [AssetDesc], [LocationID], [LocDetailID], [GroupID], [CategoryID], [Donation], [ContactID], [PurchaseOrderNo], [PurchaseDate], [PurchasePrice], [PurchaseCurCode], [InServiceDate], [InvoiceNo], [InvoiceDate], [AccountingEntryDate], [AccountingEntryJVNo], [BarcodeNumber], [SerialNumber], [BrandID], [Model], [StatusID], [StatusDate], [Remark], [InstalledAt], [OwnerID], [OwnerInfo], [HREmpIDUsedBy]) VALUES (16, 13, N'CY-GZG-000001', NULL, N'dzxgdf', 109, 113, 109, 251, 0, NULL, NULL, NULL, 0, N'USD', CAST(N'2026-07-09' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, 2, N'dwg', 12, CAST(N'2026-07-09' AS Date), NULL, NULL, 1, NULL, N'2024001   ')
GO
SET IDENTITY_INSERT [AT].[Assets] OFF
GO
SET IDENTITY_INSERT [AT].[Inventories] ON 
GO
INSERT [AT].[Inventories] ([InventoryID], [InventoryStartDate], [InventoryEndDate], [Remark], [CompanyID], [StartCreatedByUserID], [StartCreatedByFullName], [StartCreatedByDateTime], [EndCreatedByUserID], [EndCreatedByFullName], [EndCreatedByDateTime]) VALUES (32, CAST(N'2026-07-09' AS Date), CAST(N'2026-07-09' AS Date), NULL, 13, 3, N'Ali Saker', CAST(N'2026-07-09T10:37:42.563' AS DateTime), 3, N'Ali Saker', CAST(N'2026-07-09T10:37:48.067' AS DateTime))
GO
SET IDENTITY_INSERT [AT].[Inventories] OFF
GO
SET IDENTITY_INSERT [AT].[InventoriesDetails] ON 
GO
INSERT [AT].[InventoriesDetails] ([InvDetailID], [InventoryID], [AssetID], [IsAvailable], [AssetCode], [AssetDesc], [Relocated], [RelocatedLocationID], [RelocatedLocDetailID], [CompanyID], [LocationID], [LocDetailID], [GroupID], [CategoryID], [BarcodeNumber], [SerialNumber], [Remark], [CreatedDate]) VALUES (1874, 32, 16, 1, N'CY-GZG-000001', N'dzxgdf', 0, NULL, NULL, 13, 109, 113, 109, 251, NULL, NULL, NULL, CAST(N'2026-07-09' AS Date))
GO
SET IDENTITY_INSERT [AT].[InventoriesDetails] OFF
GO
SET IDENTITY_INSERT [AT].[StatusHistory] ON 
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (101, 16, 11, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T09:37:37.013' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (102, 16, 5, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T09:37:47.670' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (103, 16, 12, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:36:37.927' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (104, 16, 1, CAST(N'2026-07-09' AS Date), N'k;lj', 5, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:44:27.580' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (105, 16, 0, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:44:30.687' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (106, 16, 1, CAST(N'2026-07-09' AS Date), NULL, 5, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:44:39.767' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (107, 16, 5, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:44:41.893' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (108, 16, 1, CAST(N'2026-07-09' AS Date), NULL, 5, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:45:53.967' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (109, 16, 3, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:45:59.727' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (110, 16, 4, CAST(N'2026-07-09' AS Date), NULL, 5, 0, N'EUR', 3, N'Ali Saker', CAST(N'2026-07-09T10:46:18.450' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (111, 16, 0, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:46:48.297' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (112, 16, 12, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:47:14.447' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (113, 16, 5, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:47:16.773' AS DateTime))
GO
INSERT [AT].[StatusHistory] ([StatusHistID], [AssetID], [StatusID], [StatusDate], [StatusDesc], [StatusContactID], [StatusSalePrice], [StatusSaleCurCode], [CreatedByUserID], [CreatedByFullName], [CreatedByDateTime]) VALUES (114, 16, 12, CAST(N'2026-07-09' AS Date), NULL, NULL, 0, NULL, 3, N'Ali Saker', CAST(N'2026-07-09T10:47:25.730' AS DateTime))
GO
SET IDENTITY_INSERT [AT].[StatusHistory] OFF
GO
SET IDENTITY_INSERT [ATSET].[BrandTypes] ON 
GO
INSERT [ATSET].[BrandTypes] ([BrandID], [BrandDesc]) VALUES (2, N'HP')
GO
INSERT [ATSET].[BrandTypes] ([BrandID], [BrandDesc]) VALUES (3, N'Lenovo')
GO
INSERT [ATSET].[BrandTypes] ([BrandID], [BrandDesc]) VALUES (1, N'Microsoft')
GO
SET IDENTITY_INSERT [ATSET].[BrandTypes] OFF
GO
SET IDENTITY_INSERT [ATSET].[CategoryTypes] ON 
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (204, N'2N')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (251, N'4 Seat of 3 drawers')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (13, N'AC')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (316, N'Access Card')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (317, N'Access Control')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (14, N'ACCESSESORIES')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (292, N'Adapter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (4, N'AVAYA PHONE')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (205, N'Barcode Reader')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (346, N'Basket')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (329, N'Battery')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (252, N'Big Cabinet')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (330, N'Blower')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (347, N'Board')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (12, N'BOX')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (253, N'Cabinet')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (254, N'Cabinet Drawer')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (255, N'Cabinet with Drawers')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (256, N'Cabinet with Safes')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (293, N'Cable')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (294, N'Cable Organizer')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (348, N'Calander')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (206, N'Calculator')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (349, N'Calendar')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (207, N'Camera')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (208, N'Central')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (9, N'CHAIR')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (350, N'Charger')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (351, N'Clock')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (331, N'Coffee Maker')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (209, N'Colored Printer')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (210, N'Communication Cradle')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (7, N'COMPUTER')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (211, N'Computer Server')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (212, N'Conference Phone')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (332, N'Control Ramp')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (295, N'Control Unit')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (213, N'Converter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (333, N'Cooler & Heater')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (257, N'Counter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (289, N'Cup Holder')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (352, N'Data Organizer')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (353, N'DBS Logo')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (296, N'DC UPS')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (258, N'Desk')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (260, N'Desk Dish Rack')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (259, N'Desk Ext')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (214, N'Dock Station')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (318, N'Door Control')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (319, N'Door Opener')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (261, N'Drawers')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (215, N'DVR')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (288, N'Eagle Safe')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (247, N'Ear Puds')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (334, N'electric heater')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (335, N'Electrical Plugs')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (336, N'Fan')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (320, N'Finger Print')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (321, N'Fire Alarm Button')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (322, N'Fire Extinguisher')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (297, N'Firewall')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (262, N'Fixed chair')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (354, N'Flag')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (355, N'Flower')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (10, N'FLOWERS')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (17, N'FURNITURE')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (356, N'Garbage Basket')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (323, N'Hand Punch')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (357, N'Hand Soap Container')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (216, N'Headset')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (324, N'Heart Attack')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (337, N'Heater')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (325, N'Helmet')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (358, N'Hold Calander')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (359, N'Holder')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (360, N'Hole Puncher')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (298, N'Hub')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (249, N'Ink')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (299, N'Internet Router & Microwave')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (263, N'Island Desk, Vista Bench 6 per melamine top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (264, N'Island, Bench for 6 per wood top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (265, N'IT Cabinet')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (338, N'Kettle')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (217, N'Keyboard')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (300, N'Keypad')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (339, N'Lamps')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (218, N'Laptop')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (219, N'Laptop Bag')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (345, N'leaps')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (220, N'LED light')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (266, N'Leg Stand')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (248, N'License')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (340, N'Light')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (267, N'Local Counter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (361, N'Logo')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (326, N'Magnetic Door Lock')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (362, N'Map')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (363, N'MasterGel')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (268, N'Meeting Desk')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (269, N'Meeting Table')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (221, N'Microphone')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (341, N'microwave')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (270, N'Mirror')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (5, N'MOBILE')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (271, N'modesty panel')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (222, N'Money Counter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (223, N'Money Counter Printer')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (272, N'Money Safe')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (224, N'Mouse')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (225, N'Mouse Pad')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (273, N'Moving Chair')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (301, N'Network Ports')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (302, N'Network Switch')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (303, N'Network USB Server')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (226, N'NVR')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (304, N'Pad')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (364, N'Paper Cutter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (365, N'Paper Hole Puncher')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (305, N'Patch Panel')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (227, N'PC')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (291, N'PDU')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (228, N'Phone')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (15, N'PHOTO ')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (366, N'Photo Frame')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (367, N'Picture')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (368, N'Plant')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (369, N'Plastic disk rack')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (16, N'PLEXI ')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (229, N'Power Bank')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (230, N'Print Server')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (6, N'PRINTER')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (231, N'Projector')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (232, N'Projector Board')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (233, N'Projector Lamp')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (234, N'Projector Wall')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (290, N'Rack')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (342, N'Refrigerator')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (250, N'Ribbon')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (370, N'Roll Tissues Container')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (274, N'Round meeting table melamine top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (306, N'Router')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (275, N'Safety BOX')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (235, N'SBC Avaya')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (371, N'Scotch Tape')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (8, N'SCREEN')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (236, N'Screen Holder')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (327, N'Sensor')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (276, N'Separator')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (328, N'Signature Stand')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (237, N'Sim Card')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (372, N'small flag')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (238, N'Small Screen')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (373, N'Soap Container')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (277, N'Sofa')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (374, N'Stampler')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (278, N'Stand')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (375, N'Stapler')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (376, N'Stapler Remover')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (307, N'Switch')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (11, N'TABLE')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (279, N'Table Board')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (239, N'Tablet')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (377, N'Tissue Box')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (378, N'Tissue container')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (379, N'Tissue Holder')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (380, N'Tissues BOX')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (381, N'Tissues Container')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (240, N'Toner')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (280, N'Top Desk')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (382, N'Tree')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (241, N'TV')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (19, N'UPS')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (308, N'UPS Router')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (309, N'UPS WIFI')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (245, N'USB Hub')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (244, N'USB Network Adapter')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (246, N'USB Storage')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (310, N'UTP')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (311, N'VGA Cable')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (312, N'VGA Convertor')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (313, N'VGA HUB Console')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (281, N'Vista Bench 2 per (Desk)')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (282, N'Vista Bench 4 per melamine top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (283, N'Vista desk white melamine top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (284, N'Vista desk white top')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (242, N'VoIP Centeral')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (383, N'wall calendar')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (384, N'Wall Picture')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (343, N'Water Cooler')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (344, N'water heater')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (285, N'White Desk')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (286, N'White desk crystal glass')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (314, N'Wifi')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (315, N'WI-FI')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (243, N'Wireless USB')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (385, N'Wood garbage basket')
GO
INSERT [ATSET].[CategoryTypes] ([CategoryID], [Category]) VALUES (287, N'Wooden Screen')
GO
SET IDENTITY_INSERT [ATSET].[CategoryTypes] OFF
GO
SET IDENTITY_INSERT [ATSET].[GroupTypes] ON 
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (101, N'COMPUTER & OFFICE MACHINERY', N'COM', 10, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (102, N'FURNITURE', N'FUR', 15, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (105, N'NETWORKING & IT INFRASTRUCTURE', N'NET', 10, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (106, N'SECURITY & SAFETY EQUIPMENT', N'SEC', 10, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (107, N'APPLIANCES & ELECTRONICS', N'APP', 10, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (108, N'OFFICE SUPPLIES & ACCESSORIES', N'SUP', 50, NULL, 0, N'LB        ')
GO
INSERT [ATSET].[GroupTypes] ([GroupID], [GroupName], [Acronym], [DepreciationRate], [AccountNo], [AccountingExclusion], [CountryID]) VALUES (109, N'test', N'elk', 20, N'', 0, N'CY        ')
GO
SET IDENTITY_INSERT [ATSET].[GroupTypes] OFF
GO
SET IDENTITY_INSERT [ATSET].[LocationDetails] ON 
GO
INSERT [ATSET].[LocationDetails] ([LocDetailID], [LocationID], [Floor], [Zone], [Room]) VALUES (113, 109, N'3', N'', N'')
GO
SET IDENTITY_INSERT [ATSET].[LocationDetails] OFF
GO
SET IDENTITY_INSERT [ATSET].[LocationTypes] ON 
GO
INSERT [ATSET].[LocationTypes] ([LocationID], [Location], [CompanyID]) VALUES (109, N'kl;h', 13)
GO
SET IDENTITY_INSERT [ATSET].[LocationTypes] OFF
GO
INSERT [ATSET].[OwnerTypes] ([OwnerID], [OwnerDesc]) VALUES (4, N'Borrowing')
GO
INSERT [ATSET].[OwnerTypes] ([OwnerID], [OwnerDesc]) VALUES (1, N'Company')
GO
INSERT [ATSET].[OwnerTypes] ([OwnerID], [OwnerDesc]) VALUES (3, N'Leasing')
GO
INSERT [ATSET].[OwnerTypes] ([OwnerID], [OwnerDesc]) VALUES (2, N'Renting')
GO
INSERT [ATSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (1, N'GZG', N'Asset Acronym, Max is 5', N'General')
GO
INSERT [ATSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (2, N'6', N'Asset Code Length, Min is 1 Max is 10', N'General')
GO
INSERT [ATSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (3, N'Country', N'Asset Acronym Start Setting', N'General')
GO
INSERT [ATSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (4, N'sdfasdf', N'Warranty Notification Start Setting', N'General')
GO
INSERT [ATSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (5, N'1 Week, 2 Days, 1 Day', N'Maintenace Notification Start Setting', N'General')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (0, N'Active')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (11, N'Decomission')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (3, N'Destroyed')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (1, N'Donated')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (12, N'In Stock')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (6, N'Lost')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (9, N'Return From Maintenance')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (7, N'Return To Supplier')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (4, N'Sold')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (5, N'Status Removed')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (2, N'Transferred')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (10, N'Under Inventory')
GO
INSERT [ATSET].[StatusTypes] ([StatusID], [Status]) VALUES (8, N'Under Maintenance')
GO
SET IDENTITY_INSERT [GSET].[Companies] ON 
GO
INSERT [GSET].[Companies] ([CompanyID], [CompanyName], [CompanyAbbreviation], [CompanyPrmCurCode], [CompanyScdCurCode], [CountryID], [HRCompanyProfileID]) VALUES (13, N'test', N'dd', N'LBP', N'USD', N'CY', 11)
GO
SET IDENTITY_INSERT [GSET].[Companies] OFF
GO
INSERT [GSET].[ContactTypes] ([ContactTypeID], [ContactType]) VALUES (99, N'All')
GO
INSERT [GSET].[ContactTypes] ([ContactTypeID], [ContactType]) VALUES (3, N'Contact')
GO
INSERT [GSET].[ContactTypes] ([ContactTypeID], [ContactType]) VALUES (1, N'Customer')
GO
INSERT [GSET].[ContactTypes] ([ContactTypeID], [ContactType]) VALUES (2, N'Supplier')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'00', N'ÞíÏ ÇáÏÑÓ', N'ÞíÏ ÇáÏÑÓ', N'000', 0xFFD8FFE000104A46494600010101006000600000FFE1005C4578696600004D4D002A00000008000403020002000000160000003E511000010000000101000000511100040000000100000EC3511200040000000100000EC30000000050686F746F73686F70204943432070726F66696C6500FFE20C584943435F50524F46494C4500010100000C484C696E6F021000006D6E74725247422058595A2007CE00020009000600310000616373704D5346540000000049454320735247420000000000000000000000010000F6D6000100000000D32D4850202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001163707274000001500000003364657363000001840000006C77747074000001F000000014626B707400000204000000147258595A00000218000000146758595A0000022C000000146258595A0000024000000014646D6E640000025400000070646D6464000002C400000088767565640000034C0000008676696577000003D4000000246C756D69000003F8000000146D6561730000040C0000002474656368000004300000000C725452430000043C0000080C675452430000043C0000080C625452430000043C0000080C7465787400000000436F70797269676874202863292031393938204865776C6574742D5061636B61726420436F6D70616E790000646573630000000000000012735247422049454336313936362D322E31000000000000000000000012735247422049454336313936362D322E31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000058595A20000000000000F35100010000000116CC58595A200000000000000000000000000000000058595A200000000000006FA2000038F50000039058595A2000000000000062990000B785000018DA58595A2000000000000024A000000F840000B6CF64657363000000000000001649454320687474703A2F2F7777772E6965632E636800000000000000000000001649454320687474703A2F2F7777772E6965632E63680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064657363000000000000002E4945432036313936362D322E312044656661756C742052474220636F6C6F7572207370616365202D207352474200000000000000000000002E4945432036313936362D322E312044656661756C742052474220636F6C6F7572207370616365202D20735247420000000000000000000000000000000000000000000064657363000000000000002C5265666572656E63652056696577696E6720436F6E646974696F6E20696E2049454336313936362D322E3100000000000000000000002C5265666572656E63652056696577696E6720436F6E646974696F6E20696E2049454336313936362D322E31000000000000000000000000000000000000000000000000000076696577000000000013A4FE00145F2E0010CF140003EDCC0004130B00035C9E0000000158595A2000000000004C09560050000000571FE76D6561730000000000000001000000000000000000000000000000000000028F0000000273696720000000004352542063757276000000000000040000000005000A000F00140019001E00230028002D00320037003B00400045004A004F00540059005E00630068006D00720077007C00810086008B00900095009A009F00A400A900AE00B200B700BC00C100C600CB00D000D500DB00E000E500EB00F000F600FB01010107010D01130119011F0125012B01320138013E0145014C0152015901600167016E0175017C0183018B0192019A01A101A901B101B901C101C901D101D901E101E901F201FA0203020C0214021D0226022F02380241024B0254025D02670271027A0284028E029802A202AC02B602C102CB02D502E002EB02F50300030B03160321032D03380343034F035A03660372037E038A039603A203AE03BA03C703D303E003EC03F9040604130420042D043B0448045504630471047E048C049A04A804B604C404D304E104F004FE050D051C052B053A05490558056705770586059605A605B505C505D505E505F6060606160627063706480659066A067B068C069D06AF06C006D106E306F507070719072B073D074F076107740786079907AC07BF07D207E507F8080B081F08320846085A086E0882089608AA08BE08D208E708FB09100925093A094F09640979098F09A409BA09CF09E509FB0A110A270A3D0A540A6A0A810A980AAE0AC50ADC0AF30B0B0B220B390B510B690B800B980BB00BC80BE10BF90C120C2A0C430C5C0C750C8E0CA70CC00CD90CF30D0D0D260D400D5A0D740D8E0DA90DC30DDE0DF80E130E2E0E490E640E7F0E9B0EB60ED20EEE0F090F250F410F5E0F7A0F960FB30FCF0FEC1009102610431061107E109B10B910D710F511131131114F116D118C11AA11C911E81207122612451264128412A312C312E31303132313431363138313A413C513E5140614271449146A148B14AD14CE14F01512153415561578159B15BD15E0160316261649166C168F16B216D616FA171D17411765178917AE17D217F7181B18401865188A18AF18D518FA19201945196B199119B719DD1A041A2A1A511A771A9E1AC51AEC1B141B3B1B631B8A1BB21BDA1C021C2A1C521C7B1CA31CCC1CF51D1E1D471D701D991DC31DEC1E161E401E6A1E941EBE1EE91F131F3E1F691F941FBF1FEA20152041206C209820C420F0211C2148217521A121CE21FB22272255228222AF22DD230A23382366239423C223F0241F244D247C24AB24DA250925382568259725C725F726272657268726B726E827182749277A27AB27DC280D283F287128A228D429062938296B299D29D02A022A352A682A9B2ACF2B022B362B692B9D2BD12C052C392C6E2CA22CD72D0C2D412D762DAB2DE12E162E4C2E822EB72EEE2F242F5A2F912FC72FFE3035306C30A430DB3112314A318231BA31F2322A3263329B32D4330D3346337F33B833F1342B3465349E34D83513354D358735C235FD3637367236AE36E937243760379C37D738143850388C38C839053942397F39BC39F93A363A743AB23AEF3B2D3B6B3BAA3BE83C273C653CA43CE33D223D613DA13DE03E203E603EA03EE03F213F613FA23FE24023406440A640E74129416A41AC41EE4230427242B542F7433A437D43C044034447448A44CE45124555459A45DE4622466746AB46F04735477B47C04805484B489148D7491D496349A949F04A374A7D4AC44B0C4B534B9A4BE24C2A4C724CBA4D024D4A4D934DDC4E254E6E4EB74F004F494F934FDD5027507150BB51065150519B51E65231527C52C75313535F53AA53F65442548F54DB5528557555C2560F565C56A956F75744579257E0582F587D58CB591A596959B85A075A565AA65AF55B455B955BE55C355C865CD65D275D785DC95E1A5E6C5EBD5F0F5F615FB36005605760AA60FC614F61A261F56249629C62F06343639763EB6440649464E9653D659265E7663D669266E8673D679367E9683F689668EC6943699A69F16A486A9F6AF76B4F6BA76BFF6C576CAF6D086D606DB96E126E6B6EC46F1E6F786FD1702B708670E0713A719571F0724B72A67301735D73B87414747074CC7528758575E1763E769B76F8775677B37811786E78CC792A798979E77A467AA57B047B637BC27C217C817CE17D417DA17E017E627EC27F237F847FE5804780A8810A816B81CD8230829282F4835783BA841D848084E3854785AB860E867286D7873B879F8804886988CE8933899989FE8A648ACA8B308B968BFC8C638CCA8D318D988DFF8E668ECE8F368F9E9006906E90D6913F91A89211927A92E3934D93B69420948A94F4955F95C99634969F970A977597E0984C98B89924999099FC9A689AD59B429BAF9C1C9C899CF79D649DD29E409EAE9F1D9F8B9FFAA069A0D8A147A1B6A226A296A306A376A3E6A456A4C7A538A5A9A61AA68BA6FDA76EA7E0A852A8C4A937A9A9AA1CAA8FAB02AB75ABE9AC5CACD0AD44ADB8AE2DAEA1AF16AF8BB000B075B0EAB160B1D6B24BB2C2B338B3AEB425B49CB513B58AB601B679B6F0B768B7E0B859B8D1B94AB9C2BA3BBAB5BB2EBBA7BC21BC9BBD15BD8FBE0ABE84BEFFBF7ABFF5C070C0ECC167C1E3C25FC2DBC358C3D4C451C4CEC54BC5C8C646C6C3C741C7BFC83DC8BCC93AC9B9CA38CAB7CB36CBB6CC35CCB5CD35CDB5CE36CEB6CF37CFB8D039D0BAD13CD1BED23FD2C1D344D3C6D449D4CBD54ED5D1D655D6D8D75CD7E0D864D8E8D96CD9F1DA76DAFBDB80DC05DC8ADD10DD96DE1CDEA2DF29DFAFE036E0BDE144E1CCE253E2DBE363E3EBE473E4FCE584E60DE696E71FE7A9E832E8BCE946E9D0EA5BEAE5EB70EBFBEC86ED11ED9CEE28EEB4EF40EFCCF058F0E5F172F1FFF28CF319F3A7F434F4C2F550F5DEF66DF6FBF78AF819F8A8F938F9C7FA57FAE7FB77FC07FC98FD29FDBAFE4BFEDCFF6DFFFFFFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001F03012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F7FA28A2800A28A2803FFFD9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AD', N'ANDORRA', N'ANDORRAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E77419513C4BA63B1E05D465BFEFA15EA7AC6AD67A8E9E4448E364A0FCEB8CF06BC7BC3F26EF14698AE0ED3751839E38DC2BD53C470DA586920DB9C6E980E5F38183C5799C69EC9E3E8369F35B4B6DBEB73A785A97BCD3FE639CBB70B3614E063B515977575BA5054E78EDCD15E5C62DAB9FA03D1DAE7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AF', N'AFGHAN', N'AFGHAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00C6D2821D56D780493FFB29AEAA581164438F94FF00B38AE0749BE316AD6CD9C156EFF435D65D6B2254DAA028CE4E1F39AF0F34FE225E5FE67B78653FECAC4496D697FE9236F8849C056206DEC7DCD159B717664901193C63A515CB08BE547E7AB5573FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AG', N'ANTIGUA AND BARBUDA', N'ANTIGUAN; BARBUDIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00C7B9F0F06D511A2445B79CEE7620610F7FF1ADCD5FC39A1DAD8ABE9D7493CE3864C0E7E9FE7D29F6D7B0C4F13CA91CA8A4168DDB0187715AFE26BBF0F88ADD3488205691448F20624A83D17AF5F5AF26957A52A6AA549C94A1D15AD2ED7BABFAFDE7B98DCA712F18A34147927BB77D3BFF00C0FB8E41204B640800C9E4E3D68A8EE66065C83918ED4571A94E7EF3DD9F4AA953A4BD9C52B23FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AI', N'ANGUILLA', N'ANGUILLAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6536060804AB6DBCA2F9DB81F4E376DEFEB8FC69B6DE143ACC7737BF6B8A10B398BCB48C36E38520AE0818F9BF215C9AC8428E0D6EE87E279348B69AD645668246F3170A0ED7C633CD7D37F67D6C3C673C3D4BCA5DF65B6DF77E4BA6BF393CCE9625C29D7A69463DB77BEFF007FDF77D74CBD734BFEC5BF5B533ACFBA25977A0C0F98678A2A0D57539F56BF7BA9F249015463A28E00E28AF469292825535975F538A7CAE4DC159743FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AL', N'ALBANIA', N'ALBANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F0075F5D9B4B68D91559981EA3DAB323D61E79D536A6D24293B71DEAE4E23BA8A206608C9DF8CF4ACCB5B1F24969674E24DC1411C81D3E95E053951549F32D4FB5AF4B16F129D37EE976E1F6C980C471D8D1552EA6CCD953918ED45634E0DC51E954925268FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AM', N'ARMENIA', N'ARMENIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F009BEDB6E6300A0271C9DB542E2E6039C28FFBE6BB08FC33A415F9DA41FF006D6ABCFE19D1FB3BFF00DFEAE3E7E1FEBED3F03D3863B8894B6A7F8FF99C14F32993E4E063B714574D77E1ED31250137918ED2668AA55B225F0FB4B7C8EF55B3E92BB54FF13FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AO', N'ANGOLA', N'ANGOLAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BD6DB24DABB03311E99A9B51B7B236F2BDB18D9A12A1CAF2AE0FF10CF4E78C571B657F0DACCB24BE6E50651A19423A37620907F2A4D5355B3BE8E78E25FB2F998777C29F39941C6428F97393D38CF51DEBC0AB9755F68945BB77B79F6BDF6FC7EF3E8FFB7AF2E6E4FC7FE013DDB859B0A7031DA8AE36466DDC64FD39A2BB6397595B9BF0FF008254B886EEFECFF1FF00807FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AR', N'ARGENTINA', N'ARGENTINIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F438FC397AF6EA3ECD6E4ED192597D2B124D02EEE99D618A0C819FBC0647A8ADB4F135C25BAFEFE10DB464103D2B11F5FB9B4676824872DC723381E839E057BB078FE65CBCBE77B9E055582E5F7B9BF0322E7C37A9C72E0A4638CF120A28BAF136A324D92D11E31C474575BFED0FEEFE27347EA16D39BF03FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AS', N'AMERICAN SAMOA', N'AMERICAN SAMOAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F007E9DA26A5AB3EDB3B3965E797C6147D49E2B7E5F02A695682EF589DE4FFA77B4033F8B1E00FC2B94B0D7751D2A5DD65792C3CF2A1BE53F5078AE897E201BD8C45AB42DCAEC69AD58292A7A8653C11F957D3664B33E57EC6D6FEEEFF8EBF71F3D97432F4D73DF9BFBDB7CBA7DE747A0E9BA55CE9314FF00D950C024CB0463E6363B12C7BD14EB5F14E892DB27937F122280A164F948C76C515F34F9AFEF6FE67D2252FB3B1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AT', N'AUSTRIA', N'AUSTRIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB20F06EACC80FD9ADDB23BC82ABDD782F55C1FF0046B7FF00BF8B5620F19EA8A8019A01818FF562A0BAF1AEA983FBFB6FFBE07F8D783FEC96FB47D92799F37D8FC4E6EFBC21AB25C60450AF19C0945145F78C3557B8C89213F2F68C515B43EADCAAD709BCCF9B5E4FC4FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AU', N'AUSTRALIA', N'AUSTRALIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D96BAB2C46247B7271FBE254B64E063383C9F5C7EB58D708D05CBEA371043756DE718CA79B80CDB73D14E40E87D2AADB5D5847A6DDC5716B24976E47912ABE027AE477AA96EF6C6E545E9945BF3BCC2016E9C633C75C57D5E13011C34E73526EFDFD16DAF97E9D0F98C6E6153150A74DC12E5EDEAF7D3CFD377D46DE42B6D222A4EB2964576DA08D84FF0009CF7145526766624927DC9A2BB7D4E68C5D8FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AW', N'ARUBA', N'ARUBAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EC2D6285A18F31C650A025881BB763A63D3DEABDD4510CE113FEF9156E0BDD39635066B1180382AF4C9EF74D23FD7E9FFF007CBD7653CDE719BFDCD4777FCAFF00C8F12A5084E292945595B7FC4E56F0859F03818ED455FBA9EC1A6C86B1618EA124A2BBBFB65BFF009733FF00C059CF1CBAEBF891FBCFFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'AZ', N'AZERBAIJAN', N'AZERBAIJANI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00641A55DDDC8914310791C80A323926A0BBD03508A079FC90D02B6C3321CA67D335AF6375E43C72ACC12442194E470692FB56B86B392D12E02DAB3EF30A1017358AE2CC65ACE31BFA3FF33CE786C8A32BA752DF2F9FFC038F9609637C138FA1A2A6B825E524E4F6E28A17116324AED47EE7FE6762FEC04BDDF696F91FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BA', N'BOSNIA AND HERZEGOVINA', N'OF BOSNIA AND HERZEGOVINA', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E93C3FAB342FB1C798DC6558966947015507F78727DEBAFCC1346248C2323743B6BCB2399A3657472AEBC820E0835D268BAD045D830303E78906720025A5C93D7D4573716F0BBC6278CC2AFDE2DD7F32FF0035D3EEEC79393E68A93546AEDF91CEEAAC5755BB00E079CFD0E3F88D1516A7209353B97421D5A46219790793457DB6174A14D3FE55F923C4A8AF393F37F99FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BD', N'BANGLADESH', N'BANGLADESHI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BB1A45E42B32A9381DAAADC08F1C2A8FC29AB3930A8E9C0AAB2C8DDCF15F1E65964727780A8F16FF0079ADB7BEDA5BA6FF00F074206E18E28A81A4258F07F2A2B549D8F94B9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BE', N'BELGIUM', N'BELGIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00CBF0F043E26D23A1CDD459FF00BE857AE78C22886971F03FD72F6F635E23E1DBCC78A34904E31771F5FF007857ADF8C7504FEC84F9D7FD72F7F635F3B9C548C7114E2F77FE67AB94C1CABC6DDCE3EE484970A7031DA8ACCB9BC0F202A7231DB9A2B18C6EAE7DA6DA1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BF', N'BURKINA FASO', N'BURKINABE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BD014600150C4FB75A351B296D151A7B731875C82531F87D6A38EE50421495E9DCD57D575296F8279D22B7963098C703D2BE41CA57B247A1FEB9A5EF7B1F9737EB6D3EE6635D3ED9B0A4818EDC51503B1DE700FE028AEA82F7507FAECE5AFB0FFC9BFF00B53FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BG', N'BULGARIA', N'BULGARIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F534F15E88A9970C7EB066A8DD78C7C3E01E1C7FDBBD712ED1ECFF005833FEF5665CEC39FDE0FCEBC1FED1C42E8BEE3B16479ACBE1E4FBDFF91D4DDF8BF4679B31BCA0631C444515E7D385593E5E463B73456F1C7556AF641FD859AAD1B87DEFFC8FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BH', N'BAHRAIN', N'BAHRAINI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F5FD62285B4072638C9D80FCD6FE6F6F41FCFB57984A8817803F2AEFB59D4225D0E40D344BF281F35C795CE3D47F2AF327BD8F1FEB17F3AF1733F8D7A1F579045BA52F52399B6C98071C7AD15467B90D2641078ED4571C22DC51EE4DDA47FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BI', N'BURUNDI', N'BURUNDIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F41D2A5B3F16D8AD8DFC416F638C3ADC46A3A719FF00F5543178634A84CD797105D886D5983453A8C49B7F8863A8F6AA16705A786747927D4AF185F5CC3E52C36F2005471D0FAFBF4142F89F45BCBA8A2B89AF238CDB9B72F24C36F3DDB1DFDEBC88DACBDB5B9FCFF0B9D997ACD3EA9785EDAFF5DFEEFCCC8D5FC537B25F136BB2DE1030A8101E3DFDE8AA7ABF86AFE2BE2B6AF1DCC046524122838F423D68ACAD8BEB7B9F2B2FADDDDF9BF13FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BJ', N'BENIN', N'BENINESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B02187CA89B0BB8ED278AF4E91A12BF753F4AF1AFB7FC8AB9E9815B0F790F9583228FF008157C163300F14D7BD6B5FA1A70B617EB3ED75B5B97F53AFD46554B90148036F638EE68AF2DD4660F75943B86DEA39EE68ADE8E556A69737E1FF0004FAC965EA2EDCFF0087FC13FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BM', N'BERMUDA', N'BERMUDIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D606C8DBC5E6C70EED8BE71284F6E33B7BFAE3F1A596CED974A3773C8CB334DE5AC48830402B9391C0C06C81DF15989728AA01751C7734C7BE0A4E5E378F69011B1C1F5CD78D531D1AF26AAA766EFBBD34B69FD6D6EC7D5FF67D5C15353C37BD24ADA249B576F5D7FA777D748B5B8A2B1D43CAB6B869A16457493694DC08CF4A2B2EEA7692452CC1C85C654607534573D937786DD0F5A9B92847DAFC5657F5F9687FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BN', N'BRUNEI', N'BRUNEIAN', NULL, 0x89504E470D0A1A0A0000000D494844520000001400000010080600000016185F1B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C0000045649444154384F1D94794CD447188607B99143B09E9156A8582BA5065B4F14C4036B0CA668232D5E514A83542BA4A66A6A6D8C4A526348FF408C246D636D634214AC98A8884A5504B5E5A816612F600FF6803D90DD750F769F4ECD2F5F26934C9EF7FBE6F7BE13E2D6A712310111F03845D03B26A2C2FC42EEE42744588C103A9B10C9E98942DD631793E2C3447860A208F1868AD8D038E17C6913E1917E31CEB8080F4D100EBB5B084DC70758FB96F3AA7F09E833C19A01E659A08B20680A814022668D005F02B893F00EC511344C85E139F8158904D4B1F814D10494D3B0B445235CA65A7C23D5B874DF33AA29C1A32F60DCB80246DE959014B045C14B097686E0330BC687257C2C1EBF2E540AC74BE168D0C4807A0AD6C7E1889ECE6B0C0D34F3D2721BDFE85578759180BD128FA18480710B0CE50079745F97A05129609E24BB8BC5A6FE7F9FC0B8361A9F2AF67587A6B60884DEA862C43EC4B0CD8865D880D33E4CC0619287F512AE06D7136C370E527F588EE93800865C099D8FDF3A1DFFE8543C8353702B67E251CC46D7168FA8AA394F5DE34DDABA150C9A3CBCF242D02D9B32CB92DCC0BD27DC3B524163D97A94B55BE1D97E29B69F31C37A6C866CDCFAB538D5AB7129F350B76622D6AC2B606B51319F1FF89AC3274F5273E127AE37D6D3F3E00EFE7F3AB87FE2187F1F3B42E7B7E53C3E5A8AEBD6391CADB5F43E38835DFB334E6D150EF571EC7D27E8B9BF0F51F8711E3BB66DA270FB476CDE9E4B51F15A4A4BF338BE2F9F0B8776A2AE3D8DF1EC69ACD53F42DF0BAC97EBA8FBEE30DD4DD7088E6AB0F6376156D663EC6DA0B3E53CA262771AE525EFB0B7248DDDBB53D8B327958AD20C2ACB9653F3453667D6A6539D9DC1C58D3934161771F34839B7AB4FF1ECFE55C646FA30E9BA30EB9EA178DE4E4B533D624C558AB6F3339AFFC8E26CD50C8E7D13C9D1FD11FC5096404DC90C1ACA16D0B03393BAC265FCB26505951BB328DFB09C2F3FDDC0C17DBBA83D57C595CB97F8B3E52E8F1EB6220C4FA7E2D4CC935ECB92C65D85DBB298818E39B4D7C5D37426944B7B05F5A593682899C7AF3B3EE474C14A2AF272D896BB8A4DAB7258943997ECEC85E4E7AFA3706B01C2AB4A22A09DF2DAFD3E439234759234F54C9998B7E59F5E004A99A0F665682E6670E5D0344E7E12CBDED5D16C5E14CDCAF4487297CE206BC92C562E4D63F58AF710231DD371BD4826D09F0C5AE935431C1823E53A0106A47995B28C6F48913469F2F9787A33186C9DCB9DDF13A9AD8CA378730CF9394964BF1F43567A0CC2DA952C812904D5B3A15F02B5324E2619A5E10859126A91408B5C8D2132EF2178FB63A598CCBA3E059742BE032F76F1D78D227EABCAE2D457A908D3F3C98CA9E488DA37652EE5C18169329B726CC5443C3DE1B2ABC9AFAFC32FCBAB9DC978FF5BA04A25F86F0ADEEE141CCFE761EF5D88A57B31836D0B91AF4D38BAAE288C4FC3197A28B0B4086C7275B48731F2344CC669026A59AAD650D48FA2D03D88C5707722E65B71989B2351350BB48F0503AD1174C9BCFF079F06698A6E9072000000000049454E44AE426082, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BO', N'BOLIVIA', N'BOLIVIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E962F0CEA2172D04278EA5C567AE8F2DF9916D0DA4A63FBC1241C55D83C537E53E79611C74D82B2E3D59F4B32B58ADBC6640031033903A0E4F4E6BE0A32C6F2C94AD7E9DBCEE7A6B8B629F35BF0FF8253BAF0AEACB37CB1C4063B4A05151CFE2DD59E4CEE88E38E22A2BAA9AC6F2ABF2FE257FADF4E5AD9FDDFF0004FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BR', N'BRAZIL', N'BRAZILIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D3B496B8B17BC957CBB58D72D2B01F31F45CF5350CB6905FCE2DED2CE6B69CA931ACAC1966C0C9C30180D8E71D2AADAEB524761269F3932D94A30F116C15EF953D8E79F4A8E2BEB6D19DA5D3AEE5B899D700C881562CFB64E5BDFA7D6BE7E82C1FD52AFB5BFB5FB3BDBCBCB7DEFD36D4F9C8BA7EEFF2FDAEFF002FD2DF3D0C9B9492DE768A4578DD4E194F041A2A0B9B896E6769646791DB9663924D159D34F955CC525D363FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BT', N'BHUTAN', N'BHUTANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F6586284C219D13EEE49207A572FA9EBA2DAFE48A2B68258480236500E49EF9E9FFEAA8F5AD7835AB585AC91FCE9B64909CE3D8573AD244AE5BE46F94A81B8E3EA067F1AF8EA1EC234F9AA2BBEDFA9EDD2C0D7A92EA911DFDE4F7173E648D8623A27007D05154AE5F74991CF1DA8AC611F751F590A6945247FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BW', N'BOTSWANA', N'BOTSWANAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DE875BF0FA44BE65F2E71C9FB339FF00D96AA5D788BC39CE2FD47FDBABFF00F134D4B1D08C603E9D0E71CE67907FECD55EE34BF0F107FE25B0FF00E0449FFC557B8A18FBF43C375301CB6D4CEB8D7746797316A3F2FB4120FE945413E97A3893F77A646171DA690FFECD4568D661E5F819AFECF6B4BFE27FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'BY', N'BELARUS', N'BELARUSIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAF59943E91A70619FDD8E4E39F947BD72D70579C01F956EEA1223E9B62247C0110C72060E07B573974D18076B8FFBEABE6714DFB4B7A7E47D1C788305807EC6AA7757D969ABF533EE242B260311C7634555998B499E4FD28A209F2A07C5D97C9DD297DCBFCCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CA', N'CANADA', N'CANADIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EBFC1D25ADBEAC66B87448C5BB6E67E8395ADCBDD6EC352D2F518942C522ABA22B1197007515C6784E5B7BCD464B6B8DA637B6604138C72BFAD6CDC69361A669D7F7226F36510B88CBB0F978EA31DCD78F87757D8FBABDDD6E7D463A187FAD7EF1BE7F76DF7FF57391BB611CC029C0C76A2B32EEF03CA0A9C8DBDB9A2B8631BAB9F40DDB43FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CD', N'DEMOCRATIC REPUBLIC OF THE CONGO', N'CONGOLESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00ECEDE089EDE0FDDA16318FE11926A1BFB2F214168028201CEDFD2AAADEC696D6E3CC4CF97C8DC38E7F4FC6997FAB9BA03CC910EDCE307B57B74E38CF6D0E4B725E5CD7DF776B7EA7CD4E747D9B4FE2B2B18D7876CF85E063B714555BA9B7CD91CF1DA8AF65EE7047547FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CF', N'CENTRAL AFRICAN REPUBLIC', N'CENTRAL AFRICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB7FE15ECD3D942AB75668D182CD208DB73F7E79AC7B7F0C37890C82DEE62B7F200277A13BB3F4FA57409E1B11DB1FF89A370BE9EDF5AE5F44B15D6FED0BF6D30794AA72BCE739F71E95E0FF00AD3ED2A4710BFE5DB7DFED7AAFF86E963A305973597E2A3ECECDF269CDBD9FE16FC48EE3E1F5D5BCBB3FB4E1E99E11851562E3C21B64FF0090B3B71FDDFF00EBD15E82E30725CD7FC3FE01E5472DAA95BD8FFE4C8FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CH', N'SWITZERLAND', N'SWISS', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D2F4E9B527115B44249366EC640E3F1FAD6A7893C2DFD9B189ACD1A48163DD33BB2FCA73DBA573367AB3D910F05D1864DBB4956C1FA568EBBE2E6D55512391A18826D78C4B90FEE6BE760A9FB292927CDD3FAFCCFB9ABF58FACC1D392E4EBFF075FBBF139C9E578E4C23B28F40C45155E5669642D1AB38E99519A2BBF0D17ECA27998D9C7EB13D7A9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CL', N'CHILE', N'CHILEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F008E37D38D844E669BFB47ED2A3CBC7C8533D73EB5ED97421CB6153F215E490CA8ABC95FC4D43733A107F783FEFAAE7C6F107D66CFD9DAD7EB7DFE48F5F05C25F57BAF6B7BDBECFF00F6C7A05EC8A93E010063B1A2BC7EF24DD3E558918EC734572C7306D5F97F1FF80774B879276F6BF87FC13FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CM', N'CAMEROON', N'CAMEROONIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B5FBA610855058EDEDC935D3787ACE4B6D6419A068C3DB92372E3B8FD6BCFF00EDBCA827A102BAFF000E6B735FEB43ED132B7976EC13A0C0CAF15F0B8E53FABCD2EC76F0C294F055DC76BEBF71D85C90B28038E3B5154AEAE434A086078EC68AF0695397223BD44FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CN', N'CHINA', N'CHINESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DA8BEC4DA7421623F6A072EC79523FCFF3AA57488AEC140C67D05568AF15631FBC00EDC1F9B151CB77191FEB17FEFA15F256B1FA4429B52DCAB3B94930188E3B1A2A9DCCE1A5CA9C8C76E68AE8841B8A09C929347FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CO', N'COLOMBIA', N'COLOMBIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F58431F9632149C7B543288FD13F215E5BF638FCA04DD8071D3FC9AA13DA20CE2E41FC7FFAF5F1FF00EAB65C9DFEBCFF00F05CBFCCF4214F376FFDD7FF002A44F4BBB655980040E3B515E4334015F02527E9CD15D50E1FC0A8A4B177FF00B86FFCCE9F659975C3AFFC0E27FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CR', N'COSTA RICA', N'COSTA RICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAAD741F0BDEC7BD5353FBDB464A0CB75C0E3FCE6B3E7D37C2099F9355E3D765247E21F0B40BB1AD352936B6E5DE233B5BD473FE702AA4DAE7851F398357C9F568FF00C6BA67FDB9CAB96F7EBB0A92E1EF692E75EEE96B5EFE771860F0A29215352C7BECA2AB7F68785DC92B16AB8F764A2B1B67DD59DDFF0018CF44FF0013FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CU', N'CUBA', N'CUBAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6B7D02DE686DEEAFDA7B6B49B813C681803C7247A7352CBA0F84173FF001551C8EDE4FF00F5AB22CFC436F02DBC37D1CD7569100C2DD2408377D7F139AD197C61E157CFFC5210E4F7F307F857A594BCC7D8AF6BCDCB656F86FF008F4EC73E7B4F2C5887EC7979EEF9BE2B7E1D7BDB4F9DCA371A678723936C5E20775C7511E28A86E3C47A0C926E8BC351A2E3A6E07FA515DD275EFF006BFF00253CD8468F2AB72FFE4C7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CY', N'CYPRUS', N'CYPRIOT', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F71792DADAC5269630576AE70A0F51598752B79E411456A0C849C67007E7561A78E6B1117DA110941CE41C7D41EB54A22216DCF3DB2A818D9080031F524F3F8573D4559D45C8ED1EBA1A4674D46D28DDFE056BE016651B541DBCED1C7534556D42E15AE010EA46DEC7DCD15D0667FFD9, 0, 1, 1, 1, N'HRCYP')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'CZ', N'CZECH REPUBLIC', N'CZECH', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E8FC31E3F6D3645B2D5B335A67093632F17D7D47EA2BD024BFB29A25962B9B76471B95848304578B58E9A19FCEB91B8672A9FE357AE00C70A314F3ACCB0B1AD6C32BBEBDAFE5FAF43AB20C8B175687362A5CA9ECB776F3FD3A9E8D2DDDBEF3FBF87FEFB14579314CB1F94515E32CD25FC9F89F42F86E1FF3F7F0FF00827FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'DE', N'GERMANY', N'GERMAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00CA8F44BC74FF00531138EA58552B9D06F067F7317FDF42BDAA0F0CE8BE5AEE7901C7FCF7A82E7C33A260E1DFFEFF00D7CE4B399A8F3597F5F33DC587CB9CADEF7E0780DC6917B1CB8DAABC740F457AE5F785B47FB40C094FCBDA6A2A239F5D5DAFC3FE09ABC1E5F7D39BF03FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'DJ', N'DJIBOUTI', N'DJIBOUTIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F51BDD2B4E91C7D97ECFF6B31877B7E32DC7503D6B93BF5850B0F29148E08DA0115A5AAF896CEDA5DD63E535FF0094237B8C83B0607CA3D4FF002AE1AF6E7CD6677937BB1C962D924D42E2078697238F3DBCEDFA33C4CC7D85ED47E7EA25DB859C853818ED45624AFF00BC38C9FA515DAB8A6EAFEC7FF26FF807911A2EDB9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'DK', N'DENMARK', N'Danish', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EFBC1FE1FBDD3F5249EF2D1638FC82A5B729E4E3D0D666B1E16D4A7D4EEE68AC55A3795994EE4E413F5A5F05EB97B77A9C71DCDE4D2A7D9C9DAEC48CF1CD666B1E21D463D56F234D42E1516670AA1CE00CF4AF0E4E87D5D68ED77D8FB0A70C67D7A7671E6E55DED6BFA9957FE18D5E3B803EC58F973C3AFA9F7A2B2354F11EA9F6A5FF00898DCFDCFEF9F53456118E19ABDA5F81EA5F315A5E1F74BFCCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'DM', N'DOMINICA', N'DOMINICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D48608811FE956D26393E54AAE47E029B7D3FDB21923F3002B2BCC77600DCD8DC73F80E3B5566D6EFAE1916E2E1E5556E15BA7A51A86ED3E269212AAE6E1E12CB9CE63C73CF6391C7B57C7F2BBB50BFAF95D5FF1B1382AB96FD4A7CEBD6FBF959940DB2E4E350D3FAFFCFDA7F8D149FF000906ACC49FB74C79F514574A842DBBFB97F99F3EA783FE597DEBFC8FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'DZ', N'ALGERIA', N'ALGERIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B9B6268506D5C9519247B5771E1396DC6896F6ECF06E632322630F8DC7935E5FF6FDAAA33C818AF44F073C0DA0DB5CB8B70E0C8AADFC606E3C13E95E065CA4AB69FD6C79F964A838B4FE2D7EED2D6E96BDEFD7637E5540FC28FCA8A824B98CBFFAC4FF00BE8515EF9E81FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'EC', N'ECUADOR', N'ECUADORIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F5479A286D1A56456D89B880324F159B6FAA43793887ECE63729E60C8E31F90F5AE023B758BCB952F155D48619C7047E3556F4996268FED08159F7B60E727F13C0E7A57C73E1BCBA0F97EB3CD7EBCB25CBF2D6FF007A3D3A54334926DE1ECD74E78EBF3BE87A1DDB2ACC00C0E3B515E4334015F025278EDCD15D70E1FC0A8A4B177FFB86FF00CCDBD9667D70FF00F93C4FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'EE', N'ESTONIA', N'ESTONIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00C78AE626ED9FA8A82E2EA05CF1FF008ED7AE5BFC39F0AF960B1B852473FE95505D7C38F0A1070D3FFE05D7ADFDB388ECBEEFF82793FD8D87BDEEFEFF00F8078ACBA8C0AF80CE3E828AF48BEF877E1949C045B8231FF3F39EE68ACDE6B5DBBD97DDFF0004E88E5F492B6A7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'EG', N'EGYPT', N'EGYPTIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB53C1DABC910C5BDB938EBE60ACF9FC19AB3E76C36C71D712AD65AFC4DF10C7180B3DA02077807F8D67CBF137C45186092D90CF27F703FC6BCE796D36D6AEDFD791EDC73EC4C7A2FBBFE096AEBC21AC24D811C2BC74128A2B9EB9F88FE24965DC64B63C63E5B714568B03492B6A279F629BBD97DDFF0004FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'EL', N'GREECE', N'GREEK', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F46B1B6D37FB1E70B39756F2CBBB43820FF5A8E5B0D3FCA522D2D1C607CCD78109F723B7D288B5BB048046353B30081B97EC18E47AF355E6D634E20FFC4C6CBFF00335EDA8D5E66F5D7D7F448F11CA972A5A69E9FAB665DEDADA24F85B5B4518E8351A2AB5EEA36524E0ADEDA30DBD574EC773455BF69E7FF9390953B74FFC90FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ER', N'ERITREA', N'ERITREAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8B4D384D6A26668D4150D8619E338C9FC6B3AF2111B3A1450CA482315774EBDB8FB2245FB90814006538C739C63BF3FCCD32E23832CF25C2CAE4E49DC00CD78985C9F198A97BB1B2EEF4FF827A59C3C962E4F10D737F737F9F4FBCE6AE095970091C76A2AEDC3A893E4C631DA8AFA28F0BB8A49D5D7D3FE09F00EB46FEE276E97DCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ES', N'Spain', N'Spanish', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001503012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E93FE11B86CC5BC771776A1E5C2A83113938A927F051619135AFFDFAAAB73A941AAC96D73242F1BC4015DB2FE87DBA568C9E2D11A05FB267031FEB3FFAD5F9DD4FED0508B83BBEBA47F03ED2F8FE656DFE4731AA781662D1ECBAB65EB9FDD9F6A2A6D5BC7011A3FF0041F5FF0096BF4F6A2AE9BCC79569F91D17CC3AAFC8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ET', N'ETHIOPIA', N'ETHIOPIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E86DFC2DA8841BADA0638EEE2ABDD784F526CEDB6807FC0C55C87C517C106E9611C7F7054171E2BBF00E26B7FF00BE457E7FCB98DEFEEFE27A2B84A2DF2DFF001FF8073B71E14D5D25C148973CE04A28A7DF78B35469C624848DBDA3068AEEA7F5DE557B7E25FF00AA54A3A5FF001FF807FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'FI', N'FINLAND', N'FINN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EC7C5DAEE8DA8F86D6DECEEE296E3CD462AA841C0073D456969DE26F0F5BE8B630CB7D02CB1C08AEA636C8200CF6AC5F1869BA458786966B3B5B78AE3CD452C879C1073DEB4F4DD17C3F3689632CD6568D2BDBA33B16E492A33DEBD993C2FD5237E6B5DF6BEC78D058BFADC9FBB7B2EF62B5FF008AB42338F2F508B1B7B230EE7DA8A8350D0B421703CBB0B6C6DFE127D4FBD15C2FEA9D39BF03D15F58B6BCBF89FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'FJ', N'FIJI', N'FIJI ISLANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D958ED9EDE1F36D90B145F389898F6E33B7BFAE3F1A9E4B7916DA21F675DC57E63803073D38A7DAEA4B144A3CC008007DEA8EEB5085D1F7089D88001639DB820FF004C7E35EAD5C2E229C672A127CCF6BFCB6BE9D3F2EC7053C661EB3A70C44528ADECBCDEF6B3EBF7DDF5B183761E39B0DBA3246719228AAD7D7826BB7744017D1471457AD414D528AA9F1595FD7A9E356E47524E9FC37D3D3F1FCD9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'FR', N'FRANCE', N'FRANCE', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F006786C44DE20D23E45E6E22CF1EE2BD47C6D1403488FE44C79EBFC23D0D78EF86EF635D7F49CC8A3171177F715E99E37D4E2FEC58FF007C9FEBD7F887A1AF4F899FBBFF006E9C5C254DAAE97F78F3FD53CB4BA50AAA06CEC07A9A2B2754D4236B9522453F20E8C3D4D15F06A37573F5C575A1FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GA', N'GABON', N'GABONESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E923F0BEA1E4806DA0270392C2A8DD784B536076DBC03FE062A21E36D5D500F320E0778C5559BC73ACF3FBCB7FFBF62BC3FF005533FBDEF4FEF7FE4786ABE57276F7FF0002A4FE13D5D24C6C897BE04A28A827F19EB124992D09E31C45457447877388AB370BFABFF23AA31CB2DA73FE07FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GD', N'GRENADA', N'GRENADIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DCD1E0B698486EA1730841BE5400F979EE78F6EB56B588744D3ADCB8F3A495936A47B02EE1FDEE47EB58FA45D58C6C5EF667312A026146003E3D7919EBD2AF6AD7BE1EBFB631A09629426F49048ADB47F7796E9FECD7E7F5D54FAC7DAE5F2DBFAF43E8F14B33FDF7B1BDEFEEED6FEADB5FAEFA1CBCB27CC083B72338068AA73CA032856DC028191457B70837147BF09494573EF657F5B1FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GF', N'FRENCH GUIANA', N'GUIANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F009BED16627860257CE600E0AFD2BD4246848FBA9F90AF1F33DB87595B6F9A001B89E471D2AEC97D09836EE5CFD6BE1331C12C53872B6AC7B9C458DA98274FDA252BF35ACEDA2B7A9DAEA32AA5C80AC00DBD8E3B9A2BCAEE65DD312B923DB9A2B4A395DA09737E1FF04F9E59F36AFECFF1FF00807FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GH', N'GHANA', N'GHANAIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E921F0C6A1B0168203C777154CE81717624FB30B493636D6D92A9C1AB56FE2ABFD837CD0838FEE8ACD4D725D35661642DA212B9924DAA3E663D4F5AF8252C759A76BF4DFE773D2FF005B527CD6FC3FE099F79E16D5566C2C70A8C76940A2A3B9F166AAF2E4B447031C454575D358DE557B7E25FF00ADD4E5AD9FDDFF0004FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GM', N'GAMBIA', N'GAMBIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D28DB4E0B96D46DFF18643FF00B2D55B97D2CE71A8DBFF00DF893FF89A961FECC641E6585B8E3FE7B49FFC5555BAFECC5076E9D6E7FEDB49FF00C5572F3643B7EF3F0399714E6C9DDCA1F733365FB0EFF9352871ED1483FF0065A2A0964B42E71A6C38F69243FF00B35156964F6D39EDF2375C53984B56E3F733FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GN', N'GUINEA', N'GUINEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D7D37CB6D4AC381932A678F715D478A9621A6A65463CD1DBD8D705A4DEAFF6AD802E06264EA7DC5753E33BD51A3A157527CF5E87D8D7E778D8C9E36958FA3E258F2D06FF00BACE3EF195671B7818ED45664D725DF23278EC28AF7A117CA8FCCD6AAE7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GQ', N'EQUATORIAL GUINEA', N'EQUATORIAL GUINEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E9A1D0DF519847631C0CC630E55C853D39C7AD53B8F076AB24B2C290DB7991E378F30719E94FD335B9B4E6F3E16844BB3683200768F6F4A7CFE32D495DDD66B6DCDD7E41FE35E66610C047133E4BEFD36BF5B060B8671189A31A93F76FD2F6D3EE3027F05EB692636423E930A29D7BE32D59A7C89203C768A8ACA3F56B6973ABFD52A91D2EBEFF00F807FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GT', N'GUATEMALA', N'GUATEMALAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EEFC3C6086EA29A4404043D1724922B635FB9B66D36F60109471F28CA8C3630723F5FCAB95D0EE229AEE3824936AB4646430054E3823DC1AD4D61634B1B9B87BD33388422A9DA075FBC71D4F27F335EA631496360BD3F33C8C2CAF839B5E7F91C3DD36C9B0A4818EC68AAD752EF97239E3B515F40F73C28EA8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GU', N'GUAM', N'GUAMANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00ACD2C9E7B2873EC2A4D56D2F74D3189C91BC123F0EA2A8BB3994B2FF003A9755D4EF354689AE4A931A0418E33EE7DCD7BB45E179685BD9F2F2FBD7E5BDECBE7BFF00C13CAC4431FED710DFB4E6E67CB6E7B5AEFB69B7FC023826631E598939F5A2A9A394500FE9457C566508BC5D474FE1BBB5B6F91FA6E4F292C051557E2E557BEF7F3B9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GW', N'GUINEA-BISSAU', N'GUINEA-BISSAU NATIONAL', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000E001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E33C2DA8DB26A3A55BDD0802028F234B0AED081B9DCC47F3AF5AFED5F087FCFC787FF283FC2BC097568E2D3FECC6262C232BBB3599F6A5FEE9AF9CC56572C5CF99CDC6DD99F419CE3610F64A9C54BDDD74B7FC3FA9EC1E3197449F52B592C4E9CD19B61B8DB88F6EEDEFFDDE338C515E616FA9C7F668D3CB6CA020FBF24FF5A2BAE861E7469AA77BD8F969E2AAB937C88FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'GY', N'GUYANA', N'GUYANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6B46B289556EE1DF6EDC9741F3C64F71EA3DBF2F4ABB7DE1795A0171A6CD15DC0E372E30091EDD8D61D84D6732ACB7D73E5DB2FFCB38CE64948EC3FBA3DCFE1EB5A37DE32916DC5B69B0C567020DA98C1603DBB0AF8BC47B7F68BD9FCEFB7F9DFF0F99B67DFD96AABE5F8BAF2F7FCBD6E72F7B1CF6B7262952589C7556054D155EEEEE7BBB832CD2C92B9EACC4B1A2BD1827CA8F9256B687FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'HK', N'HONG KONG', N'HONG KONG CHINESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DDD0F4E835398C32CCB09F2B72B1507278E3F9D6ADEF86EDEEB4D45D263496E6127CF72DF7F03A0CF1D73C573DA26B7069770B3C90453E130033E0A1C751EFF855ED47C4D613E86F0DBA182EE69732796F85DB93DFBE46063DABE7E9BA3EC9A96FF8FF0091F6F5E18AFAC45D37EEE9DADE77D6F6FD4E56E18A498048E3A0E28AA775386972A7231DB9A2B2A706E28EFA924A4CFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'HN', N'HONDURAS', N'HONDURAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F414F0EDE35A2FFA35B9C2024E47A5655CF866FA4388E1B7248DDC30E95AA9E25B85B551E7C218A007A0ED59773E27BC8CE63960E98E80E7EBCF27DEBE8293C5DF4B5FE67CF56584B2BDEDF2306EBC37A9C536D291AE4678905145DF89751966DC5A23C6388E8ADDFD7EFF0067F1318FD42DA737E07FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'HR', N'CROATIA', N'CROAT', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAE1F07EA6B179925BC2502EE621831C63B0EE6B3BFE11BBBBB67486DE2DE17760918F7E7F97AF3E9518F1FEB6D0B44EF6C5197690611C8C62A91F19EA36F2192DC5BAB152A4B2EEE3F13ED5B3E19AAAD14934FADF6FEBD19AC78C6326E4DB4D6CB9747EBFF0E886F3C27AB4536DF2A15C8CE04A28AA973E36D6A697733404E31C43450B87A51F76FF008FFC035FF5AAA4FDEB2D7CBFE09FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'HT', N'HAITI', N'HAITIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00AFA5D949A9EA1159C4C8B24A480D21C28C02793F854DA9E84F6764F76B7B67711A32AB081C92376707903838AD3B1BC5B495251E59651F75FA72314DBDD4A292DDE1482D615760CC63E0923EA6BA1F16B7EF2A76B74BDEFF003B685AE069467CBED2F7EBB5BE57D7EF3897760DC123E868AB97AE0CFF0029C8C76E68A1713F37BDEC7F1FF80767FA98A1EEFB7DBFBBFF00DB1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'HU', N'HUNGARY', N'HUNGARIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB53C1DAB4B0AE2DADCF039322D51B9F046B033FE8D6FF00F7F56AE47E36D4E381713DB860A3AA0ACEBBF1E6B3CE26B63FF6C87F8D7CFDF06FF9BF03B3FD6EA90D6CBEEFF8263DE7843588E603CB8578CE04A28A8EE3C65AC4D2EE66849031F2C545744561ADA5C5FEB75496B65F77FC13FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ID', N'INDONESIA', N'INDONESIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BD0ECD80B20271DC5417223C1C46BFF7CD7B25B5C40B12EE78B3B47522A2B9B8B720E248BFEFA15E4FF65BFE7FC3FE09F48B885277F67F8FFC03C06ED8ACD85040C76A2BD6F50963FB40DA508DBDB1EA68AD2397D95B9BF0FF008239710DDDFD9FE3FF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IN', N'INDIA', N'INDIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F528B47B9F28398E2C6DC9258564DAC96FAAB4EB64D13B4270E3A7E359D1F8D752FB38569ADFEEE08318F4FAD60DBEB73E8ED3B58FD9D1A63972501FC2BE7E30CBB965CDCF7E9B5BCEE672CFE6A69C569D74FCB53A3BBB19D26030A38ECD4571D73E31D6259771684E063E58A8A6B0D836BED1D11E2695B6FC3FE09FFFD9, 0, 1, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IQ', N'IRAQ', N'IRAQI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EA97C29A8BA88FCBB4F3366F20CCB9C7AFD2A85C783F522AEC12CC84243113AFCA475CD647FC2C4D6815909B132840BB9ADD738EB8FCEB3EE3E22EB60B90BA765F25BFD157E6CF5CF3DEBCE797537D5FDFFF0000F6167D8C8BD147EE7FE65DBAF096AC2452A906D65C82B30C1F7E28AE7A7F889E2166501AD82AA85012DC600F4A2B48E069256D46F3DC53776A3F77FC13FFD9, 1, 1, 0, 1, N'HRIRQ')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IR', N'IRAN', N'IRANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAED3C15AA98958C76E7201C961552E3C17A9CDBBCAFB29DA7070E38356E0F1A6A28814C908C0C7DD154DFC5F776C1FC836C9BCE5B03A9AF9F71C25EFA9D8B84E6D38B7AFAFF00C031A7F04EB31C982D0AE4671E6514EBAF1C6A866FF9777E3AECFF000A2BA60B0DCAAD721F09D48FBBA7DFFF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IS', N'ICELAND', N'ICELANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B5A669D3DB9B992E234546848077A9C92CBD81A8757D2AEA6D467961890C6CD952244191F9D374ED4A7B8FB424A23DAB0961889548395EE066A2D5355B986FE78A21088D1B0A3C843C63E95ED41E3BFB425650E6E45FCD6B5DFE279B523977F6642EEA72F3CBF96F7B2F3B58A5FD937AA48F297FEFEA7F8D1509D5AEC9E445FF007E13FC28AEE6F32BED4FFF002638E31CAADBD4FF00C97FCCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IT', N'ITALY', N'ITALIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D1921FED9D2CED524CF1E78F715DBF8DA384E911E1540F3D7B0F435E63A35FE35CD38138C5C479CFD45771E35D4633A3478910FEFD7F887A1AF0F0A9AC354B9970DBE6C4452FE6471574C2394053818ED45665D5E0794153918ED45724637573F4D7A3B5CFFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'IV', N'Ivory Coast', N'Ivoryan', NULL, 0xFFD8FFE000104A46494600010101006000600000FFE100584578696600004D4D002A00000008000401310002000000110000003E5110000100000001010000005111000400000001000000005112000400000001000000000000000041646F626520496D61676552656164790000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000B001003012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EDBC13FF002310FF00AE2FFD2B0FE277FC8DA3FEBD93F9B56E7827FE4621FF005C5FFA561FC4EFF91B47FD7B27F36AF1724FF74F9B1718EDF77EA7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'JE', N'JERSEY', N'OF JERSEY', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F4F8B4FB9D0104F631FDAF4F601A4B561978F3D4A1EF58D65ACEA13B5D416F0C777712BFEE49501214E7E66FD38F6AB89AC5D6BC82DEC66FB1D8280B25D3901E4E39083B525D6930D9AA4FA25DA5BDD46B821E4CA4C3D1BDFDEBCD9424DA951BF2AFEB4FEBD0F6D3A4B4C55BDA3EFF008735BF4D7B955BC2968EC64D46492EAE9FE69240DB467D00F4A2A13E30B252535057B5BA4F9648C2EE19F50476A2B54B0B6E9F3DFF001225FDA97D39BE5B7CADA5BD0FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'JM', N'JAMAICA', N'JAMAICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E8349F1469BE288534BD644506A0BC4172000243E9EC7DBA1ED533E8B63A32C97FAECD12DB44D848D7FE5A9EDC77FA565E8FE1EB0F0BC09AA6B8D1CFA89E60B6041119F5F73EFD076AB0FE21B1D6E392C35D8626B795B2922F1E51EDCF6FAD7C8E2A549D5BD0BF275B7E3CBFD7A1955585F6B155FE3FC3CB9BFAF531353F1EDFDCDE17B2D96B6E06123D809C7A9F7A2A86A7E08D56DEF0A5818EEEDB19493CC5538F423D68AF6294F2C705CAE36F3B5FE77D4ED71AF7EA7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'JO', N'JORDAN', N'JORDANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F004D43C3CF35A47796F0AC7148C14BB8C465BEBDAA19BE1978964412470D93230CAB2DCA9047B56A5B5F5C49A7C56D3DC7FA2A10EB033704FBFB7B5684FE35D52188470B5A2C6A30AAB10000F40335E361F30505CB3BB3A338C660A95671A6EEFADB6FF87EF6D0E166F86DE274931E55B0E3B5C8A2B76E3C67ACC92E4B4278C7CB1515DAB1B49ABEA792B30A2D5F5FB8FFD9, 0, 1, 0, 1, N'HRJOD')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'JP', N'JAPAN', N'JAPANESE', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F61D4F51B6D2345177242B2360045FEF1AE56C7C65F69BF8EDEF2D2058E56DAAD18FBA4F4AE82FED20D5F471673B3282A0AB81CA9F5AE6F4FF00072595FA5D5D5E89D623B911508C9EC4D70D7589F6B1F65F0FF5B9EBE09E5FF569FD63E3E9BFCAC7453C718948D8BF95150CF3832E73DA8AEE3C83FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KE', N'KENYA', N'KENYAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00920F0A582A8927D6AD5E351975FB3C80918E79C555B8F0AE98D188C6A71C72C96F1CAAF242C40C93BB0147D2B7A3BFD35ED991B4C88164C1FF004971DBEB5424BBB289D1E4B28E6F2E0581419D870BDF8F5F4AF1FEBF27D55FD1DBE6752C665366D4A56D37DFE472373E15B78E5C0F105B74CF16F20FE9456BDD5FD8C9364690838C7CB3C868AD638CA8D5DB5F893F5EC99ECE7F723FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KG', N'KYRGYZSTAN', N'KYRGYZ', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6D32C96F6444F940DBB9988CE062B42FF0040812D9DEDD897452C5580E71D471D0E39C564E91A91B196394A96529B580E0E3DBDEB52FF00C456FF0064912DCC8F2480825936804E41279393826BE0F132C42AA953DBFADCFBEAAB11ED5726DFD6E72CC00638A2A1793E6EF457723D368FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KH', N'CAMBODIA', N'CAMBODIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F004874A797A306279C6DCD32EF439A250CD8DA503E42F407A66AD69BAF369F379A2DE391C0C0F318F1F955AD43C6B35DDB49049616BB1C60E19BFC6BD382CF9D3F79D9FF00DB87254970DAAC9538B71EBAD4F99C7CF6AD1C9B7CCEDDA8A6DC5C34B2EEDA7A638E68AE6BE7BF6AD7FF00B70F652E19FB37B7FDBE7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KI', N'KIRIBATI', N'KIRIBATIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6B7B29659238BECEFE6C8015528727DEAC6ADA54B6B6AB21B38D50603BA64E0FBE7A55E83508C5B3E6FE01173BF3ABBEC07FDA047984FFB9C1A65CEA01A45CDFA19769F2FFE27219C8FF64E3663FDFE4FE15CB53866729292AB64BA5BFF00B63B9F15C9D45254F45E6F5FC3EEF33959619636C34522E4646548C8F5A2B645F12CFE55EA11B8EEF2F58C73EFBC727DC71E94537C3ED69ED3F05FE6772E2DBAFE0FE2FF00F913FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KP', N'NORTH KOREA', N'NORTH KOREAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DAB0F09DB5FDA9B88EEE60092A8AE881A42064851BB9ACAB8D274C5CFF00A55DFF00DF84FF00E2AB4AC3C550585B7911DBCF804B217910B46C460953B7826B2E7D574D20FF00A35DFF00DFF4FF00E26BBE7FEB072AE5DFFEDC32A5FEAC7B4973DEDD3E33227B3D3E2936ADD5E74FF9E4A3FF0066A29B73776124BB85B5E74C7FAD53FF00B2D1597FC2F7DAB5FF00EDD3D15FEAD7D9BDBFEDE3FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KR', N'SOUTH KOREA', N'SOUTH KOREAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F56BFBAB9D365FB7CC22FECC8A0188D54179646E3073D39EFE9F5AC1B6F1647E2192E74EB08D2DB51857CD55C060EA08CAE48183C8AD0BF8BFB49CDB5CDD6ED3668024910CAB230E85081D73CE7EA2B16C3C31A6F87A3B9974ABA9A4BD9FE469EE58EE542790A42F07A1CF3D29C609B7294BA68977F37D8B738AA6A318FBD7D5B7B2F25DEFDCB1ABC9325E282763796A596363B41EF8A2A1D498C9740890CB84552E46371C75C514883FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KW', N'KUWAIT', N'KUWAITI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00A5A56A65EE60B178D6533BAC71B1032189C0C9F4C9AEB2EFC0FACF38B7B61FF6D4570FA169D38BAB7D427710885D658D1BEF31072323B0E2BB9B9F1CEAC73FBEB5FF00BF63FC6BC6C4C709ED1B77BF96C744386EA62D73A5CB7F3B7E8CC09FC17ADA4846C847B098514EBCF19EACD303BE13C768E8A70FAB595AE57FAA5523A5D7DFFF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'KZ', N'KAZAKHSTAN', N'KAZAKH', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00ECAD6081AC612D1A64F72BC9E28BAD21BEC86E1638F6819C6067154E0BC31585BB03C86E99F6F4A59B58736C622EFB3B20E87F1AF4EAC730E64F0AD5B9DDEFAE97774BB7F5B1F3AA787E4B54EDA7AD8C5955439E00FC28A8A7B832CCEEDD58E4E0515F4B152B2BEE78AE4AFA1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LA', N'LAOS', N'LAO', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F0092D6F2395D225B72F2390AA303249ABDE23D1EEF408E17BEB58C24D90AD190C011D8FBD67DB59C51B24AB70C8EA43290C010455DF10EAD77AEA4297D78AEB0E76AA05504FA9F7ACA7FD87CF1E5BF2F5F8AFF0023D6A5FEB2DA5CDCBCDD3E1B7CCE42E2E54CB9405463B714525CDBC6B2E15D88C76E68AD57F625BDDE6B7CCD7FE323FB5CB7FF00B74FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LB', N'LEBANON', N'LEBANESE', N'961', 0x89504E470D0A1A0A0000000D494844520000001400000010080600000016185F1B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA8640000044F49444154384F1D936B4CD36714C6FB651FB66C249A654BC616333341ED202838D189A23061160507A8ABA220990E4574BA4C179D9179C99C99371CBA18C3926D7171CE0B635EA6D3C409A89816A517DA52CABF3769D7CBBF17DA522EBFBDF3C3C97372DE3727CF93F33C8AF8EA9944ABB2F0572971AD9982BD3A0DE7FA34DCEBA632A89E8A77793AF15533F015A5E35E3409F9A30CFA8BDE44939782B3FC1DEC856F639EFB0683454A9E66BF8622BE761EC3B5F349D42D20BA398F70431ED1EDF90C7D964FAC7E3E347C40589D0D1B0AA06E31FECA2CE2B5798C6F2DA2BF341DFFCA1C9C2A25DEF21CB4B9A9289CA573F0A91712AA55216F5842E05315FEFA12020D2A7C9B0B096C2A205A5F48A2A18860ED02DC6AF1BFA6105F7511A6A53371A8E7D25B9A415FE52CFECE7D1DC5D88983D0D204BFFE28AA05CE9F83DF055EFD01AE1C83B6C370799F98ED854B5FC32F071839D3C8E829313F7B94E8A93D0C1EA9C77F72278FB7AF44316232C2B367108881774854142209480661DC0EF470FDDE373C369E7DDEC7835D241C4FC11F60DCDCCF986420D8DB41C4AA4573E3020A83D580DBEB212C8F20FB46080520310A2192387073D1799EBA8BEBA8BB54C585C116F4689186255C1E1F669384E4B6D36B336276F6D176E71A0ABD538B2BE4201A1B22124E12172487051759ACEC45C79E8EAD6CE95843D9C53C36DEACE47AE437FAC45A93C38C437263EA35A0EB798249286D6B6B45D1ED7C80236C451E0A120A45188A8AA58CE0C249E7D85D763EDC4843F7C7D4741653D9BA805DB737D2EEBF4920E9C366EDC7DED78FD568C461B571EBFA0D141AE91FDC512BD1B8E0140C938C8F9310723B1CF7D9776D17E53F2DA2FAEE87A82ECFA0E09C92FDF7B7F140BE8D3D3080DBE942B258B1E8F5CFF1AF362159D3D78ED3DF872C07F00F0690C5518291301AF7635ABA9AD9D7B18DFC2625EA2B0B3939B09BD3DA43B4E92FE0F0DAB118CC98F43A7AB41ACC063D7FB45E4161B6F4E0F5B88805E3C4FE1D61C83F4A223E46704CC63262E0D1E85D569F51B1A3B5469CE30EBA6427468FF6B91A738F0549B261B0E8B00C98B976EB4F14C3DD8FC06800ABB048FF20D83CE012283B8575AC74DC6BA2A9B98AEF4E54F0A0FD28A38187C25A7AE83581C144CCD085577B8780AE93AEAB3FA3E0F06EC6BFFD0A8E34C23161F2E307193EBA97D8F12F897DFF39E1E62DC2CC5FE03DBE16C78155249BB7231FAAC7D6504DA87107DEC6CD58778BB7FD9B68FFA4044570792E9EA539B84B73F054CEC1BBFA7D11AFD938566663AFC8C4523219A9340D87C8AD7BF934DC6519484B94D88A33702ECBC65A92C1934593319564722B6B82902CC21EA9789740793ADE156904D64E47AECD2454934148AD84F5B9444AA7912813BD7A16A32BB2885666102C9F8E543C098F6A2AB6FCC978559974CFFC3FCB2BA613AB988277592AD6E2144C4B52E82F9B886DE9AB0C2C9E88343705B92095E0BC549ECD9A803377227DB35FE2E97B2F609E9F822EEB15B4692F629BFD169AB497F90FBC65BE4695FDFA3D0000000049454E44AE426082, 1, 1, 0, 1, N'HRLEB')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LI', N'LIECHTENSTEIN', N'LIECHTENSTEINER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F006591D2BEC2DF69797ED277701723DB9AC79CF5C0AEA219A355E4AF4EE6A0B99A220FCE9F98AAA3C51ECA5397B372E677B3968BC97BBA23AA7C0FCED2F6C95BB477F5F78E45DD8370587D0D1576F5C19FE53918EDCD15B2E27E6F7BD97E3FF00DBFD4D50F77DBEDFDDFFED8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LK', N'SRI LANKA', N'SRI LANKAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E9EEB56BDB79AFD96E77243BCAA6071804E338AC8B8B8F153D97DAADF52670D2346238ADC3B02091D97DAAFCDA1DE4F3EA05E78047725C2E0B6406047A75E6A82E9BE31B6F2521D62D7CA8198A2191C641E81B0BCE2BF378AA77BC797A6EBCBD3B9F4B9749470B152B735DDF9B7B5DDBBF97C88EC753BBD46C629EEA46F386E8D8E7A956209E3145245A7CBA5411DBCB22CB23664765E9B9989239F7CD15F458749D35C9B1E6E29A75A4E3B5CFFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LR', N'LIBERIA', N'LIBERIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B82CED9B45B6DBA7DFB6A7F6805F31314D99C7F77DB38EBCF5ED5D75C69F60178B1B1FFBF173FE155AD758B048D436A56838EF75722A49F5AD34AF1AA597FE065D573E3F1EB18D5D256BEEEFBFC8F572CCB27815251E6D6DB2B6DF3662DE416B1CF85B7B6518E822B814557BFD4ACDEE32B7B6CC36F5171707B9A2B92318DBA1E8C9D54FED9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LT', N'LITHUANIA', N'LITHUANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F4183C49A5BA03F39E3BC5505C789B484CE77FFDFAAE460F2D5003201C7AD56BAF2981FDE2FF00DF42BF3DFEC7A37BDDFDFF00F00F53FB3739BE9C97F566DDD78B349337C8D2818ED1114570774AAB37CA7231DB9A2BBE9E5B49416E57F67E72B46E9DFE67FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LU', N'LUXEMBOURG', N'LUXEMBOURGER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB20F06EACC80FD9ADDB23BC82ABDD782B55C1FF0046B6FF00BF8B5BB69E26BA10AEF9E00768EC0556BDF145E0076CF01FC0525C3B77CB7FC7FE01D7FEB6D48AE6B2FBBFE09C45F78435649F0228578E825145685EF89750927C9788E06388E8AE85C3738AB5FF001FF8064F8CA52D797F0FF827FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LV', N'LATVIA', N'LATVIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00647E04F12B45FF0020576C8EBBD3FC6A85D7C3FF0015738D1A41FF006D23FF00E2AAFC7E3EF12245B7FB5A4040C7DC4FF0AA175F103C54738D5E5FFBF69FFC4D7850F61CCEDCDF81F7D279872AFE1FFE4C65B7833C4D0315934D9549E71E6AFF00F154523F8CFC4D3B1693519988E33E52FF008515DF1F676EA79551E2F99DF93F13FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'LY', N'LIBYA', N'LIBYAN', NULL, 0xFFD8FFE000104A46494600010101004800480000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000E001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F2D87C4705C4F1C315B4CD248C114640C92702AE6A1A80D38CC5E1692386736EF246C36F983AAF383F8E315D17FC23FA47FD036DFF00EF9A927D1B4EB994CB716714B21EAEE3713F89AF3ED47B33ABFD79C67F491C4FFC2536BFF3EF37E628AECBFE11ED23FE81B6DFF7C5145A8F661FEBCE33FA48FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MA', N'MOROCCO', N'MOROCCAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BF12C7E50670B8C0E48AAD23C2CC5405CF618EB4C4B951101BC038C726ABF991C449130390072C2BE53A1FA14A35BDB4796DCBD4AB74764D81C0C76A2AB5DCC1A6054E463B734574538BE545D469499FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MC', N'MONACO', N'Monégasque', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B56A909850B44872A3AAFB54573143838853FEF815ECD6B7302C29B9E2FBA3A91E9515CDC5B907F7917FDF42BC9FECBD3E3FC3FE09F4AB88B5BFB3FC7FE01F3B6A8112E8058C01B7B2FB9A2BD93519E2FB48C3211B7B11EA68AA596595B9BF0FF8268F897FE9D7E3FF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MD', N'MOLDOVA', N'MOLDOVAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F007F879E38BC41672B9F9558B37D02935D7EA3AE586A7A6CF1401F72ED6C32638C8FF1E95C1F87A4597C4369149F71D8A30F62A41AEA752D2ED747D22EA58A7323332AAE48F95770E3DCFBD797C6CA83CCE8CA57E6518DADB7C4EF7238469CED6FEFFF0091CF5E48166017818ED4566DDDCEE941073C76A2BCD846F1B9FA63D1D8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ML', N'MALI', N'MALIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D4D37CA3A969F855C9963CF1EE2BACF14AC634D4CA8C79A3B7B1AF3BD26F7FE27360A4E313A0E7EA2BB2F175EA0D213122FF00AE5EFEC6BF3AC5C64B1B499AF0AAE79BFF0012FC8E46F1C2CC029C0C76A2B2EEEEB74A0839E3B73457BF08DD5CFD0A5A3B1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MM', N'MYANMAR', N'BURMESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F007E9EB672D9EE99C073D78C9E87DBD87A75A86C8A34336CC15129031CF1C52C2D6C225CAC409519C81434D046A563F2D47A2E05736679DC3194654E316AED3D76563DDC9786EA603131AD29A764D68B5772BCF214930188E3B1A2A9DD4D99415E463B73457874E2DC51F53524949A3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MO', N'MACAO', N'MACANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B769047222E557EEE4923A7B9A7EA7A63DA2C65E12BBE31200C98247723D40F5A8348D4C585E4170D12CAB1F5475C83C63A56DF88FC5706A3A61B68E181DDB015D612A6350721413FD2BE5214E2E2E4E567D8F9A8FB374DB6F538C70371C5150B484B1E0FE5450AF6392E7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MQ', N'MARTINIQUE', N'MARTINICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F41B7D24C9A68DF6E164C0604C24B74FA7AD1AA69F23DC69F8B52512DD03E62C81D723A75AA506AD29D3F07505490631BA7C3631CF7A76A3ABC9E7E9E16F76A35BA193336073D49E7AD7BB6ABCFBAEBF91E1374BD9EDDBF339AD4EC2EE0BC2B1C32B2B0DDF246C00E4F14557D4F50BC178717D24808C831CA580E4F19A2BD05ED6DD0F3DAA57D99FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MR', N'MAURITANIA', N'MAURITANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B76D1C4D182CABD3B8A5D4EC05A2C44989BCC4DC36738AA965A82DB488CE8B22636B46C71B86391ED535EEA9A70B775B2B7916490619E69036D1DC2E3F9D7C54DD453492763E6E2A9BA6EEF5F9FF004FF0320E031C515079B9268AEB49D8E447FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MT', N'MALTA', N'MALTESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F618ADE73721DBCB30141C63FCF3FF00D7AF3DF15220D7AEB0A3AAF6FF00645778BA846215532A0C281CB0F4AF38F13DDC6DAEDD10EA795EFF00EC8AF3733D28AF5FF33DEC835C53FF000FEA8E7EE5B64B8048E3B1A2AA5DCC1A6CA9C8C76E68AF369C5B8A3EA2A492933FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MU', N'MAURITIUS', N'MAURITIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F005FED18BCA00C4A4E3AE0551B8BE8CE7F7407E15DE45E2B87C904D8C00E0705C7F8554B9F1846A0E34E80FF00C0C7F857CF7F6A615E9F507FF837FE00473DC6C5DFEB6BFF00059E7925D82FF28207B515D4DC78CB7C991A5C5C0C70D9FE9456F1C7619AD306D7FDC4FF0080742CFF0010F578A5FF0082FF00E01FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MV', N'MALDIVES', N'MALDIVIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F39875396DAC6CE34823959D700796A4939C01D39AB17FAA4FA75E3DACB0DA34D1F120445211BBA93B7048EF8E2B2D5A092D6D7FD31619221F8839A96FE58351BC7BA96EEDD6693990A2901DBBB119C027BE38AF2ACB5E6BDFE67D262E599FB4FF006571E4B46DFC3FE557DF5DEFB9B179B645B7731C60B45938403F89BD051504B796B2456FB2E236DB1ED3CF43B9A8AEAA37F66AE6798283C54F96D6BF43FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MW', N'MALAWI', N'MALAWIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00CDB7D16E188F320465EA7E61934DD4F46DF1110DBC6AE070400BCFA75E95BF6F2C7B06E90038FEF556BB957076C8A7FE055F3D2CC2AB95FB1DB0CD727845C6D3B3F257381B8D26F63971B5471D9E8ADEB862F292413DB8A2BAA38EACD5DA465FDA1933DBDA7DC8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MX', N'MEXICO', N'MEXICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D1921FED9D2CED5FF5F19391EE2BABF146A1A6EA7A41168EAFE55CAAB7C98EC7A7A8AF3DD1EF87F6DE9CAC4604E80E7EB5D6F89D74FD3F4726D1510C970A5B0F9EC7F4AF030EA6B0F3B6DD7EE32E1B7CD888AFEF2395BA611CA029C0C76A2B32EAF03CA0A9C8C76A2B9E31BAB9FA6BD1DAE7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MY', N'MALAYSIA', N'MALAYSIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F009236D3CDA69FE7E16D1918DDCD1A86943E4E073C818DB8C7A9AD7D22C2D6E3458251629286DD876B495C91B8E325580FCAB70E970794B9D2E1CE075B18FF00F8BAAB2D9055DA962AAA3A016698FF00D195963314EBC1C795EF7D76DE4FEFD6D7EC92B6875E5597AC156F69ED56D6D34EDE7B69F7B31AF34AB6130C69B18E3B595C7FF17452DE59399862C33F2FFCF9A7FF001CA2B8630D3E13DC95657FE2FE27FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'MZ', N'MOZAMBIQUE', N'MOZAMBICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D386DE231095B6AC78F998C65B1C6738009ACABCBBD1F91FDA7003FF005ED2FF00F135D4E81A17DAAD524D489485802B0EEDAE7DC9EA07B55BB8F03F859B24DAE49FFA7A7FFE2ABE36398E021371ACDB7E499D999E5587A959B82D5B77B3D3FE1FBDB43CC64BCD2D5C81AB47F84328FF00D968AED2EFC0DE1959804B36C63B5C39FEB457A10C7E5EE29ABFDCCF3D64B15A5BF13FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NA', N'NAMIBIA', N'NAMIBIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F0075AA69F2696DBF735E31C281C927B63D7B7EB4FB7D2FCA63BC234E065831F9211EAC7B9FF3C9E29DA78B6B787724E8A428F3AE5BAAE47DD45EB9EDEA7D8556BED49648FC98408EDC1C84DD92C7D58F73FA0ED46699E38B9D1C24DB527AB7F947B2F3FB8F3A9E0E965918D6C6C54AADBDD8745DA53FFE47EFF2A77B3C31CFB600CEA072EC4AEE3EB81D05159D3C9BA4C8C9E3B515F3714EC4BCF7329BE6755EA7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NE', N'NIGER', N'NIGERIEN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F508347BA68C1314478CF2C2A9B69ED71BCC490B6D383822B12DBC6DAA088069ADC718C18C5517F16DFDA2B8B77B61B8E4FC80FF005AF989430BCE92E6B75EFE562D7104545C9AD7A69FF04BF7FA6DC25C001107CBD9BDCD15CA5D78C357966DC5E13818E22A2BA6343096D398D23C513B68BF0FF827FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NF', N'NORFOLK ISLAND', N'NORFOLK ISLANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E9BC131C6DAFDB1600FC8DD47FB35B7AC6AD6DAA78775B48E2546B738181D5770C1FAF06B92F095D635B853CC119313AEE3DBE535A37BA52E8FA2EAF22EA1E6AC91EC58CEDF99772904FBF5AF0F0DED5507CAB4F7AFF0076878D4253F60F9569ADFEE38595D95F0188FA1A2ABCAE59F2013F4145614D3E5470417BA7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NG', N'NIGERIA', N'NIGERIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D9D1C44758D2FE55C99E3CF1EE2BB5F1BA40BA3C7F22E3CF5EC3D0D798E8B7E06BBA682718B88F393EE2BB6F1D6A287438F6C8A4FDA1780C0F66AF0B0C9FD56A9E2E1E5FECD519C35EB2ACE36F031DB8EF4565CF74647040278C515CB083E5470AD55CFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NI', N'NICARAGUA', N'NICARAGUAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F45B5F0BDCB44A592DCFCA0E49FF00EB5569BC3B349BBCB5B63B4E0F3FFD6A861F18DEA46A0BDB82001CAFFF005EAA7FC24F2DB890C02D50B9DCD85EA7D7AD7BCA18EBF43C0753056B6A472786EF439E211F47FF00EB51555FC597CCE4E60FC13FFAF456FCB987F74E7BE5FF00DE3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NL', N'NETHERLANDS', N'DUTCHMAN; DUTCHWOMAN; NETHERLANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB20F06EACC80FD9ADDB23BC82ABDD782B55C1FF0046B6FF00BF8B54E2F885AEA2EDF32D8606398854171F10B5D607F7B6DFF7E856DFEAACEDBFE3FF0000D171ABE6F87FF25FF8267DF78435649F0228578E82514557B9F1AEB534BB99A12718E2114525C3B28E97FC7FE01D1FEB6549FBD65F77FC13FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NO', N'NORWAY', N'NORWEGIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D0B88923D32EF7B439645000915893BD4F40734FBE815EE2478DADCAB1C82254E47E754AE254934EBA2618032A2952912A907728EA07B9A92F268E39E444B7B60AAD803C84FF000AE6ABF50FECFA77E7E5E6976BDEC8F6A84734FED6AB6E4E6E48DFE2B5AEED6EB72B35BB0638317E1327F8D155DAE406FF00516FFF007E13FC28AF33FE13BBCFFF00253DFF00F858EAA97FE4C7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NP', N'NEPAL', N'NEPALESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080013001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F44D4AE758B7F18DFCBA5EF711C68D244794650A3823D7D31CD745A27896CF5A0625FDC5E27FACB773F30F520FF10F7FCF15CB6A76726A3E3DBEB64BF3660C08CCCAD82C368E3AF3599E18D2347BDD566D3EEAEEE9351B7919A09A19F689003D57D08FE5F8D4C66E555C25B696EFB2DBF5BFCBA9D53A115878D482D7AFDEF7F5E8D7CF747AAD1488BB5157716C0C64F534551CA78BFC4A768BC63279676EE8109FAE31FD2B908AF2E20B88A68656496370C8EBC1041EB4515E9D2A34DC14DC55FBDB5396788ACAF4D4DF2F6BBB7DC7D2B13168918F52A09A28A2BCC3A8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NR', N'NAURU', N'NAURUAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F0070D0B55233FD997473FF004C4D579741D5BFE81775FF007E4D4D67A9C29A7DE2DDCB7CD7440FB3B24E42A9EF919ACC7BFBD3FF002F571FF7F4FF008D7D9538E64DB57869FDD97FF247C5B861D3BFBDAF9AFF0021CFA3EAA8D8FB05D2F7C79645154E4BBBC66FF8F898FD643FE345635238EE777943EE7FE67A54950E45A4BEF5FE47FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NU', N'NIUE', N'NIUEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DC8A2B66B28253042D3488BBC921495ECC46063FDEFD0D6E787A28A3B7BA8A28D162475D9B46411B41CE71CE7D79AD04B7D3F1B9ADAD77100125173C74A7A1B5B78BCB8043120E8A9803F215F099B7107D7A8CE8C632576B76ADA3F25D3656B1E8D0C32A7CBA2D3D7FCFAEEEF7FD4A57A76CC00E3E5ED45437D2A99C6181F97B1F73457994232F668EC7B9FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'NZ', N'NEW ZEALAND', N'NEW ZEALANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D902D0C30F9AB0091D479BB98838DA705B03838F4E7A66B12FA231DEC9713C20DB2C9B0AC6E076E00F6ACB3290CDF5A741E54F3849E6F2A3C125ABEAB0F80FAB4A755D46D3E96DB6DADADF4E9E5D8F99C4E62F171A74634945C7ADF7777BDF4B6BADFCF5D486E91A0940F3830650C363E719EC7DE8AAB2B059180258038071D68AEED3A9CA93B1FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'OM', N'OMAN', N'OMANI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E82C64B382E6CE7902FEEE4477F973C0233F5AEAEE7C59A09CE1CFFDF83FE15E76B2921460E0E2A0BA2541C66BE729E3A74B48A47D26735701879C5631CAED3B58EDDFC4FA33392B2363FEB89A2BCD7ED3282401DFD0D15B2CC6BF65FD7CCF17FB4721FE6A9F723FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PA', N'PANAMA', N'PANAMANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F5E6FB77F68D8ADBC36CD62CBFE90EF8DCA71C639E7FFAF5C378A7CB5F11DF28881195C10BC7DD15C2BCE366338FC6BD3BC357530F01D92DA490FDA3E7C091863EFB57667394A861E2D4F67D17AF998F0FE72D62A5786EBACB45AAF2D8F36BF245CFCA8C063B29A2BD52EEE81742CC85B60DDB7A668AF0A380B2B737E1FF0004FA9967FAFF000FF1FF00807FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PE', N'PERU', N'PERUVIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E8BC392DBC7AE594B2E02286662467F80D755E24BBB59348BA8845B1830032073C8FFEBFE46BCFFC377114DAE5A43330D8C19586EC7F01AE9FC430DA5AE8B77324DBE42548CB0E3E603F967F335E3619CFEAD3B2D35FC8FA5CCA1FF0A3455FF97FF4A7F71C65E481660158818EC714565DD5D6E941073C76E68AE28C5B573E8A564EC7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PF', N'FRENCH POLYNESIA', N'POLYNESIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F414F02D98B7F35EFA4C601FF56B59F0F846CEE9A45FB4CB19576519887CC07423D8D3A5F1D595CD91B69AC5F6B2807F7C010477E958F63E23B2D3AE1A7789A6719118DE1428FD73D6BC7952C24A4A4AA592E966EFF3FEADE7B1F44A59C2D395BBF5BC74FEBFAB135E78320866DA2FE6E46784028AAB7DE3A8659C32D94846DC71203DCFB515D11584B69FA93279BDF5FF00DB4FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PG', N'PAPUA NEW GUINEA', N'PAPUA NEW GUINEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00A1A36A2C96C4DC95685368DE586E5CF4E3A91C7E15DA69B65A3DD5A4D24D721C98F242AE0A8EA4AFAF4ED5E656D7CD1DA8983C292C282245DA0310D9C923186E323279E47A532DB5896C9BE53BA3CF284FF2AF2331CB1E220DD1972BF2EA7B183CCE514A95693E5EFD57FC0FEBC8E835445B6D425863977A29F95C71B87634566DCEA297D209D1B702A01F6F6A2B8E9539A8252DCFAAF6B196A9DCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PH', N'PHILIPPINES', N'FILIPINO', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00ED7C41E0886EE117DA56D4BA281E4B6E8B271D57D0FE86BCD6ED5A291A3746475386561820FA1AF51D47C550DB429059B235C6C0AD2E46138E83D4D715797092BB3BCA19D8E4B16C926AB0DC4B570B174AA454EDB6AD5974BB69DD9A2E1078D97B653F677F2BDFCED7563917918370CC3E868AB97AC0CFF290463B73456EB89F9BDEF63F8FFC03AFFD4CE4F77DBEDFDDFF00ED8FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PK', N'PAKISTAN', N'PAKISTANI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F56F154711F0CCA768C9D87A7B8AE02FF49B7B3D663B0BAB910A154F365DB9085973C0EE0645757E28BF43E1A9977AE7E418CFB8AE3EFF00C41A76A96F1B6A16B39BC8D0279D6F2281201D37020F35E363D45D5D77B2FCDDCF231FC9ED35DECBF539EBC2B0DDCA904ECF106211C12370EC68AA73481E5628A42E781D71F8D15CB14DA3CD8ABAB9FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PL', N'POLAND', N'POLE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F6C86F2D42F3343FF7D8A82E6EED483FBF87FEFB15E55190B9F94557B80083F28AF21E68FF0097F1FF00807D32E1F8B76F69F87FC13D1A5BBB7DE7F7F0FF00DF628AF2629963F28A292CD25FC9F89ABE1B87FCFDFC3FE09FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PN', N'PITCAIRN ISLANDS', N'PITCAIRNER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6536060804AB6DBCA2F9DB81F4E376DEFEB8FC6B12F6CA49EE269234463E66D2A8000BE9C8E31598B210A3835A163AB9B18644DA4EE39F5EDE9D3B0AFA2A982AD84A73AD8793949F4F92DBEEFBADDB5F9AAB98C717C94AA535151EABAEADEBF7FDF77D74CFBBB47B29847232312A18146C8C1145477772D7370D2151E836AE3F9515EA5172F671F6BF15B538DA57F7763FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PR', N'PUERTO RICO', N'PUERTO RICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BDA544B1C36F71ABA4F069D39D8974A81829E3AFB73FCEBA19747F0C326E5F10641E988C7F8571BA45C44C2DE3D59A49F4F84EF4B4594282DEFE83939EE6BAA93C53E1908153C390003A0122FF0085679CFD43DB3F65CBCD777DEDF875EF6D0F53228E6BEC57B6E6E4B2E5F86FFF009374ED7D7E4655E69FA1C53ED8F5A765C6721314557BDF1068AF3E63D0A20B8ECC0D15E64634ADF67FF263D993C4A7AF3FDF03FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PS', N'PALESTINE ', N'PALSTINIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080014001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DCD4FC6FE2DB476686E2DE488B6140B7048F6AC69FE2678E632708BF8D91AB10CCD3B3AF2A81F9901E47D3DEBAA93C7D6B6D6C90FD86593CB50BBDD97737B9AF2F0F984758D576B1D99BFD4F09579633D7AADEDFD76DCE42C3E2778D26819A68D0B07207FA191C515D143E3A82E159D6C5946E2319145772C4526AE99E5AC5516AEA477BFF00089683CFFC4B21E793D698DE0DF0F37DED2A03F5CFF8D14557B1A7FCABEE3474A9BD5C57DC2C7E0FF0F44A5534AB7504E7A1A28A2AB923D87ECE0BA23FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PT', N'PORTUGAL', N'PORTUGUESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B4B6D1BDAA32A0663B5703192C7A0E696589406023C6DC03903A119078F51CD6643A988A30AE09036918EA08E871DFE86AF49741A1C025B7104B30C138181C0E07F8935F2AB915377BF35FE56FF33D2E11F6524FD97C5F6BD2FA7977F3BDBA5CA8E00638E28A86493E6E945426EC7DF389FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PW', N'PALAU', N'PALAUAN', NULL, 0x89504E470D0A1A0A0000000D494844520000001400000010080600000016185F1B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C0000043C49444154384F2D94796C546514C5BF62298D8A264413A282182305012B2D1464272CCA56A52D1491B690080485A4EC2044968001134C9498B21428946ED36D866E83DD6068875271D82403C1A054964ECB74A6ED2C9D37CBCFDBE21F37F7BD9BF79D77CEB9E7BDB029C5415EEBDF4FF5772B15D4022A7CA053D15F5368912A9248352818AE346F97728539554F44A4EA0E1BA43C845478C8A9C2C2C394167C59F943112A180C2A40A9450658590F1B2E43BAD4760BEC90DAD604BBAFC1DE46E9BDF3068D7433ACBA044BAA20D11822A91666E8352609A9B8021FB1B91ED457E79CACAF844DF2E05693C67E73373F5C7172B0CE2D5D63A7C9C19646275BCC6E369A605D19A4E6C3D24248B8009F96C374E9BDA013741A6A759E9B4D460FDB4D2DEC6DF883CCEB9728BC7E91926B464A6E9A3862AE654F93859D0DFFB2B9CE4BBA1CFEBA0892F5102F60B3E47E4A294C2CF4F7B154C9BA1ED6D7D8F9FEF7CB645A33B03CDD425BC70ABA6CF1D8DBD2B8726F27F9B7CFF3536333BB6B9FB0B9DACDDA3A912C36CD953E4318BF000C303E5F00179EEF6043DD038E5A33A96F5D43A767267886417B04FE676FF0E4D96C4C0FB672BCB188EF8CB7F8C6D84A6A8D8FF81A3FD32B35661B5F804E2E4124FB51CB0ADA39D87C835ADB369EF44C81C00870BD0E6D8A60FB4B78DC43B1B62FA4E0EE31F69B2CACAD71B35298A554F7B0B8A293B9E2FF3491FD4931C4E982A82FCE3CE2A0D984B9358576D7BBD03548D885F701E21E40A7B39F008EA3E8DE11F6989A5965F4F3A5B04A33BA482EB733A3C4C744F1745C7E90D83C59CA929CE71C68BC8AB96D0D766F14D8DF846703C016011D917477BDCAEDA713C8BE79845D976EB0A22AC46291985CE622A9BC9399A501E284DDD8BC10D1B902382FCB417AB585A287BBB8EF9883CB3E8A50EB60FC2DAFE0F87B206DF60F313F4CE2D7C6936CACBCC3B2B200F1227181BE8759252EA6CAB6E384618C44293A27809A7E36C0F28AC71CB0146068D9CE5F6D8BF0DA63F1B70EC3F1CF28EEB5A460B8758843D5757C6B784C4AB99F84DE4548B8C70BD309B2E1713AF83837C4986C59CA9C5C096869176BEA9AD9D79485EED60EAE595763BD9F8AE5EE06F29B0EF3637DA9E4EF2E69C50E960BC0E7BD51A91099C274ECFF60A3CF698C3CE345C5CB4592CE2D9E3C26F5828574FD6FECBB50C5E1B27A0E5434B0CE709594B23F596A682541C2BBF83C7C764E62223D264F98E5C0E8EC2023CEF8883ADD839A79BA83F93AAF181D22B1DCC732BD83D45227AB8AFDA4950449327849ACF4917851C0E4CB58208C660BD864511627BEF531CBD2187ECADB572A2ADB4E6CA14FB625C9971FC5DCF26EE655B9982F87174A5813C4F0C4A2008BF4DDCCD17B9824B3189945EBEC8C29B0F1C16907EF9F70F1DEB1AEBE5243749D0C2FF0F251168CC974CBDB5A1899F38851D99D449F74332DC3CDD49F6DC41CB51295616548A68DC1676DBC75EA0E834F58189AF194778EDA79FB97E77DFD3FC8CE9BF448037FAA0000000049454E44AE426082, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'PY', N'PARAGUAY', N'PARAGUAYAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000D001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F008742F87F7F77A0D85C0BBB2C4B02B8DD6F920119E4EDE6A1D13C2D71AE7DA7C8B8B25F218039B7539CE71D070783C579941E21BEB6812049A5DB18DA3F7AC3FAD2A788EF23DDE5964DC7736D91864FA9C1E4D747F6561DEBED7FF4A3D48E778B8A4972D97F763FE47A0789FC232699796B14D25B3BBDBEFCA45B47DF71E9ED4570E7C4373731C7E6866645DA09909E324F7FAD1593C3C20F953BA470D4C656A937392577E87FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'QA', N'QATAR', N'QATARI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F67BC8607D1A5DD1C6D984E432839E3DEBE74D4446B3CA1401F39E800EF5EF57B7F12E933069631884E77381DBDEBE74BDB866B99B1C8DE7A7D6BCCCC20E4E363EA78726A31A97F218AE4670C473D8D155D19C8276375F4A2A6117CA8EFAD38F3B3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'RL', N'IRELAND', N'IRISH', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001503012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00BFA6436FF6BD34F9699F32227E51EA2BD5F578E1368F8441F30FE11EB5E23A5EA682FF004F5322F12C43AFB8AF59D4F5189AD5C0953A8FE21EB5E0E115B0D56FDBF4670E48F9A7A77463DFAA214DA0739EDF4A2A8DF5DA37978753D7BFD28AF0252573F42A54A5C8AE7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'RO', N'ROMANIA', N'ROMANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E7BC3CCA7C51A4FBDDC79FFBE857B0F8A5631A6A65463CD1DBD8D7887872623C55A567802EE3CE7FDE15EBDE2FBD41A4A6245FF5CBDFD8D78DC6F7799E15AEDFA9BF0BD2973D9FF31C85E38598053818ED4565DD5D6E941073C76E68AE2846EAE7E812D1D8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'RS', N'SERBIA', N'SERB', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D78BE1F6BEEBB85BDB9CF3CCC2A0B8F87BAF8CFF00A3DBFF00DFE5ADCB7F1A6A8B18067B7181DE31FE3505D78D75420FEFEDBFEF81FE35BFFAD53B6DF87FC1297053E6DFFF0026FF008072371E0AD6E1976B470838CF130A2AD5FF008BF557B807CC84FCBDA31EA68A5FEB14A5ADBF0FF8274FFAA7521EEDD7DFFF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'RU', N'RUSSIA', N'RUSSIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F47B7F1DF87046031909039CDBD4173E3AF0D9CE0C9FF80F5C18B3B41183BF0D8E72C2A95C5BDBF3871FF7D0AD5E63942FE7FB91A4723CEE4FFE5DFDECEAAF3C69A23CE0C724C171DA1228AF3EB88635930B9231DA8A5F5ECB1EAB9FF03A7FB0F345A49C2FEAFF00C8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'RW', N'RWANDA', N'RWANDAN; RWANDESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAED041E52978909DA3AA8A7449A79BAFF00498D0458ECA053A0F19868C06B58978EF2FF00F5AAB5D78D4267169137FDB5FF00EB5797538B7173528AC2B57EAAA2FF00E44F1E34308AD7ABA2FEEB39ED58C29A8482D788BB63A51535CF8D9E497234F5E0638933FD28AF468F16621538A786E9D66BFF009131780C1C9DD57DFF00B8FF00CCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SA', N'SAUDI ARABIA', N'SAUDI ARABIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DAD1B498750B496466DAF185C0D80EECFBD59B9F0C5BEF5413B293D7E4538E0E3E9DAB9BB6BF11280CEE1703211F69CD13DFDB956DAF700E38FDE83CF6ED5F2D1704ACE3A9F34A74F96CD199740C570F183F7491C71D0D155A590B3E7AD15B413E544455D1FFD9, 0, 1, 0, 1, N'HRKSA')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SB', N'SOLOMON ISLANDS', N'SOLOMON ISLANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EEACEDEDDE3B72F14064280A838C3F5E58E783514963696F0B5DDF6C8ADD7A2E396F6A87ED36BA259A5C5FBAB4E47EEE052339F7AE4B57D6E7D4E632CF20C0FBA80F0A3DABCECD73EAB5A72A18095A3B39FE90FF00E4BEE3C56A9E1E09D68DE5D23FACBFCBEF2C6A3E2EBC6BB3F6358E0B7518442809C7A9A2B999242CF9009FA515E3D2C252505EE92B1D8992BF3B3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SC', N'SEYCHELLES', N'SEYCHELLOIS', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F009BC3BA6FF6C6AF0C4D930463CC98FF00B23B7E278ADFF126B2B70C6C6C8031E70CEA3973E83DBF9D52D0520B6D1BC9975082CFED187B890B6E90AF64551CF4EB9C75AD34F127877428CFF66D949733E3067959413F8F38FC00AF273D9FF69663ED6A4AD4E9FBB15F9CADE6F6F2498F23A983CA30FED6BBE6A92D6DDBB5FF00CBA339B93C35AE49B5D21112B0CED925D8DF951525EF8EEFEE2E0BA5ADBA2E3000DCDFAE68A9853C2F2AD59DCF8B6A49DD256F47FE67FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SD', N'SUDAN', N'SUDANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B96AF15CCD15BBBC3179985124A30A0FB9C56C5D780B5319F9ACFF00EFA3FE15C20D4EE6CEE565B790C53447E57001208FAD2DC78D3C54F9C6B3727F15FF000AF270F97A942F5B73AB2DCDF1F428A8CDA76DAEAEEDE6759069779A3196DA5954167DE3CA738C1007B7A51593E1BBDD5B55B29EE2FE792E2513945772B90A1578FCC9A2BD3A74D422A2B64675ABCEB547527BB3FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SE', N'SWEDEN', N'SWEDE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00ECBC1BE1AD434BD5DEEAFA18C44D09504386E4907A7E1583A9782B5A96FAE658EDE2D8F2B32FEF57A1248A6F83B5B7B5D6E5FB7DE4DE5889970ECCE376476E7DEB0351D5EF1EFAE4C77B71B0CAC5712B0E32715DF4658DFED0AB6A9052E58EBCAECF7D17BDBAEBA9E0D4A547EAD0BD39DAEF4BEBF91D0E9BA7DF68D0CB6D744C6E64DE0249918200EDF434553F0E9BABAB19A4959E53E71019DF271B57D68AE7AFED7DA3F6924E5D5A565F2D5FE67AF875154A2A29A56EBB9FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SG', N'SINGAPORE', N'SINGAPOREAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DF034CFB2DA955424C0BE6139DDBF9DDDBAF000ED8358D7023C1C22FFDF35ECD6D7302C2BB9E3FBA3AB0A86E6E2020E248BFEFA15E5CB2DE6FB5F87FC13E869E7DC8EFECEFFF006F7FC03C06F1B6CD85040C761457ADEA1327DA06D65236F623D4D1551CBACADCDF87FC1349710DDDFD9FE3FF0000FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SH', N'SAINT HELENA', N'SAINT HELENIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D6536060804AB6DBCA2F9DB81F4E376DEFEB8FC6A9A680DAA35EDD7DA608961902945504B671F740E315CEAC8428E0D2C33CB6F7A9731CD247852ACAA321B3EA0D7D1D4C056C3427570F51B93B744ECB4BD93F4FBACBA6BF392CCA9E29C2957A6A318DF557D5EAD5EDEBF7DDF5D24D534F3A5DF3DAB4D1CA40077C678E68AA524CF2C85DC966F5228AF4A8732A51555DE56577B6BE8B438A76727C9A2E87FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SI', N'SLOVENIA', N'SLOVENE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EEA4F10C9AC48B1E837B6B6EB0C05E637508059BB6320F1EB4278E743FB1422E8B7DA7CB5F3765BF1BF1CE3DB35C4C3676A172D21538E7E6C557B9B4B519C483FEFA15B7F69E54D59F359792BFCDDF534590E71CD75C977BDE4EDF256D0E92F7C69A1BCE0C6F285C7FCF123BD15E7F750C4B2E172463B1A2A7EBD963D573FE0747F61E68B49385FD5FF91FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SK', N'SLOVAKIA', N'SLOVAK', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F4DD37C59A5DFBC50D9DBBCEE7E572E8142F1D79EB54AEBC6BA243B92EADE482604828220D8C1C7515C35BC314511093B44C704306C1522AB5DDBDB3019933818197159AC760556737297B3ED6F7B65AF6B5EFD4F41E4F983A2A9C631F69D657F7777A2EB7B5BA7CCE8AF7C69A23CE0C6D3018FF009E38EF4579FDD4312CD85E463B1A2BA3EBD963D529FE047F61668B49385FD5FF0091FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SL', N'SIERRA LEONE', N'SIERRA LEONEAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAE1F056AC605FF45B639039322D51BBF046B1838B6B61FF006D16BA58FC4F72B6A9FBF8036D19C81E959979E2CBFE76CD6E7FE022A63C35CCF47F8FFC03C19BC1C56BCDF81C75C783B598A5C18E15C8CE04C28AD1BBF136A324D92F11E31C2515D2B86E6B4BFE3FF00CE357056D398FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SM', N'SAN MARINO', N'SAN MARINESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F6DB6F27C942C884ED1D40F4A86E561C1C471FFDF22BCF9EF944283CC5C8503EF7B5674F7C39FDE0FF00BEABD88E52E5F6BF0FF8278F3CDE31FB3F8FFC03AFD41952E005C01B7B7D4D15E7373725E5041278EC68AB7937F7FF000FF8242CE6EAFC9F8FFC03FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SN', N'SENEGAL', N'SENEGALESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D3D37C9FED1D3CE147EF632491EE2BA6F10DD595C69FB6292372930040209E87F4AE0748BDFF0089CD8027189D073F515D4F88A3B3B0D249B7214CB3AB3FCF9C9C3735F9EE262962E9B77BF4FBC7C2EAA4EAAE5DB9B5FB8E6AF1D566017818ED4565DDDD86941073F2F6A2BDC8C5B573F47968ED73FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SO', N'SOMALIA', N'SOMALI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EC2CA08A48E31E5AB330181B4649A353D31ED115A4B70AAC01C94C63DBEB59F05D11128F4029FA96AD3DE85F39836CCEDC0C607A57D57B3A9ED15B6EA7CABA94BD934F7312EC849B0BC0C76A2AB5D3B34D903B515D2D6A72C75573FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SR', N'SURINAME', N'SURINAMER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8B78F4D28018EE0923BECFF000A8753D3ACAD5F64D0DDC6CCA180F93A1A647AAE9F1AED7B48830E08DD275FCEABDE6B56B3726D62738C02CF2FF8D7CBBA7539B45F8337F69905F5A32B7CFF00F921FA5BC7043325ABCE13CDC90EC01CED1E94526900DDC134B1DB2C6BE6E308C48FBA3D4E68AFA0C326A94533293C3377C3C5A8744F7B1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SV', N'EL SALVADOR', N'SALVADORIAN; SALVADORAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E8E3F86BA9C89BCDE59018DD92CDFF00C4D521E01BD9CB08AFEC58819C066CE3D7A53D7E26EAC89E5FD9ACB006DC156FFE2AA8C1E3CBBB2F30DB58D9219396E18E7FF1EAFA6BE65FDDFC0F9971CBB9BED7E2327F03EA3049B0DDDB7233C337F85155EE7C79A9CF26F36F6DC0C7CAADFE34573C9E3EFADBF03BA11C1F2AB5CFFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SY', N'SYRIA', N'SYRIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00C5D3BC29AB47E1EB5BD9BFB3E2B6689584933C6A003D3248AB8DE12D596786066D2C4D30DD146648B7483D54771F4AE1D3E2778923D3134C7FB0CB691A08C45359AB82ABD339EBD054ADF15FC4EF710CEC34F33420AC521B25DC80F0403DAB95E122DDEEFEF3DD8710622115154E1A7F77FE09D16BDE1BBED3AE2DA3BA82DD647837FC9B7046F61D87B515CE5E78F75CD71A2B8BE9A032469E50D9085C2EE27A7D58D15B469A8AB1E6D6C64EAD4751A49BECB43FFFD9, 1, 1, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'SZ', N'SWAZILAND', N'SWAZI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DE3AADB410063651B1242805F924FE1524D35BCDA50BEB7B7864DACC93C7B8A98D8363AE30474FCEB35E7D1DE368A549BFBAC3CC3FFC4D365BED33FB3E1B1533FD9A1C944F33B939249DB9279EA6B18D1CCB91A6A7CDDFDA47FF0092FD0D675B2775A2E315C9D5724BFAFC512D8DEB324BE5C6D001260A07279C0A29BA6431CF0CAF6C8E13CCE77BEE24E07B0A2B48C6B256AAFDEEBADFF1EA2A92C34A4DE1D5A1D346BF07A9FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TD', N'CHAD', N'CHADIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F006E8C54EBDA77FD7C267F315E85E29118D3532063CD1FC8D79868B3E35ED3F2718B84EBF515DF78BEF106909875FF005CBDFD8D79BC7B16B34C2B5FCBFA91C1B4A5CCD3FE6FD0E46EDC2CD853818ED4565DD5D6E94153918EDCD15E5462DAB9FA63D1DAE7FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TG', N'TOGO', N'TOGOLESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D88934E9F47B99A6B9F2EE500F2E30A3E7F5C73FE7DEA3B4B1D267D3A296E752F266607726CCE3935606B9E1EDA036851E71DDC54326BFA0AAED5D0D00F40E2BE12BD6AD51251A728DBAAE5D7EF6CEECD738C163287B28CAFEF5FDE4ECB46B4B6A566D33410C7FE274DF82515136BBA1B3123425FF00BE8514E31C45BED7FE4A7CFAFAAFF73FF2A1FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TH', N'THAILAND', N'THAI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D51AAF865546FD3F50638E4F9A9FE155E6D5BC2C7A69BA87FDFD4FF0A0D97863A3CDAA82383FEAEA096C7C2A3A5C6ABF9C55D5CDC3DDBF31AA7C557DDFE051B9BCF0F492868ED350418E9E6AFF0085150DC41E1D59008E4D4D971D7F77452BE4BF6569F33751E22FB4DDFE47FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TJ', N'TAJIKISTAN', N'TAJIK', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EDA3F035F4B029F3ACBEE83939FF000AA13F80AF9B7627B3E0E0F0DFE156D3C777696EA3CAB5CED00824FA7D6B366F1F5FC658AC16AD9F52C7FAD783278472495EDF33AD714D48ABF37E064DE7823508E70A2E6D4719E0B0FE9454775E39D4279771B5B7E063E50DFE34574C5616DA5C5FEB55596B7FFC94FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TM', N'TURKMENISTAN', N'TURKMEN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00A566F1BEBEB0C9B76EDE7E5CFF000E7AF43F4ADAD52DADE2446408198B6501070BC60FB679E3DAB0608B66A22F372648C639DDD31F4EDF5AB53DC122BE5EBBF857923CBCDA497B256FF9771FD4AAE06E38A2A1690EE3C1FCA8A857B1E1DCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TN', N'TUNISIA', N'TUNISIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D32CE2BBC9958471471F992BEDC90A31D07724903F1AD2D5FC351DAD879E8DE5CC13CCFB3C8CACC53B9E00C11E9CD73FA7EA91DA8224DB245245E5CB1EFC12A7D0F620807F0AD4D53C5B1DD587D9D487936797E7C814384EE383D4F73C7D2BE729FB2F66F9F7FEBFAFCCFBAAF1C4FB78FB3DAFAFF5F9FCADADCE5AE1B6498048E3B1A2A9DD4E1A5CA9C8C76E68A9A706E28ECA924A4CFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TO', N'TONGA', N'TONGAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F4A9EEEFFF00B66DE38E0B736862C924F0471924E3EF75C0AE0AE80123E3FBC7F9D558EED163506451C742D4C96EE323FD627FDF42BE6F1188757A33EF305815877BAD92DADB5F5DDF72ACF2B24980EC38EC68AA775386972A7231DB9A29422DC51D551A5267FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TR', N'TURKEY', N'TURK', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00E8574DB3B6D26D6E6F1DCCD749BE38A351C2F4DCC4FAFA0AA17D612DAC71C92C051251BA32C31B852A6ACB3E956D6B750B3B5BAE21951F690A79DA783919AA573792CA8A8EEEC88308A4E428F6AF97A8E16D3FAEF73F42A30ADCD793EAFEEE96FC3733A77D92601C71DA8AAB76EC66E3D28ABA71BC51AD495A4D1FFFD9, 0, 1, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TT', N'TRINIDAD AND TOBAGO', N'TRINIDADIAN; TOBAGONIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D5D8EE5F51D3A0492E593FD36C3185BA4EA593D1C75C0FA8EE2AB486DAE6D12F6C9FCCB590E01230D1B7F71C766FD0F5155E1BD1104659423AE0821B04114CB9999AE25D4B4CF28DE32FFA659120477A8392C07671D78FA8E720F8719AC4C7D9D4D25D1FE8CFAFA94A797CDD6A3AD37F147B79AFEBF0DAA4F214930188E3B1A29042BAB22DDE992A3DBB0FBB348A8F1B775607B8F51C1183454470D552B38B3B5E618597BCA6B5F33FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TV', N'TUVALU', N'TUVALUAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8096AD6F0F9B6F19628BE7131B1EDC676F7F5C7E3571618C5AA79CAA8C1724051CF3D38E05450DF2A46A0C8A3000FBD4E9AF6DC4455E75F9F0DF261B0307F239AF7638678794A4A4DF33F5B6D7B68FB7E4BCCF0ABE396229461C8972FE3BEFF007FE6FA993A936DBA0150C4BB46D18C123B13EF4554BFBAFB45D190000630029C81EC28AF4E945C60A32DCF29FBCEE8FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TW', N'TAIWAN', N'TAIWANESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00CBD33FE11E6F0DDF7F692CFF00DA7CF91B54F356B421FF00121B7DC30DF367239FBC6AEC7768A8A0C8A38EE6992DDC647FAC4FFBE8579D99E72F1B4BD9F25B5BEF7E8D7647D5E5390AC056F6AAA73696DADD53EEFB156790A4980C471D8D154EEA70D2E54E463B73457974E2DC51EDD4925267FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'TZ', N'TANZANIA', N'TANZANIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B76F123A8DCA093ED924D4370A4DD35A58C51CD7A397661FBAB61EAE7B9FF67F9F4A6DACAF740C5657023857E59AFBF9A440F53EADFCBBE8A3DA595A8B7B5091C439C6EC963EAC7B9AF2B2BC9AAE327CD3D23FD7F56FBFB3F09AA7858F355D65D17F9FF5FF00031A4D22C61622688DE4CDF3493CCEC0BB1EA7008C0A2A4B99834B91CF1DA8AFBC8E57858A51E5FC59C5FDA18996BCCCFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UA', N'UKRAINE', N'UKRAINIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EAED0C1E4AEF8D09DA3AA8AAD7A21C1DB1A0FA28AED63923551929D3D45472CB11FE24FCC5782BC426A77FAB7FE4FF00FDA9CCF206D72FB4FC3FE09E5374FB662172063B515DE5EBA19C60A9F97B7D4D15E9438F79A2A5F56FFC9BFF00B5335C316D3DAFFE4BFF0004FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UE', N'UNITED ARAB EMIRATES', N'EMIRATE', NULL, 0xFFD8FFE000104A46494600010101004700470000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001503012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B96F66B7CD6B6F0451B4D36D550C00C923D6AD5CFC3FD6867FD12D47FDB55AE7ADF5B3A7882EE09A213C015D3710402077152DC7C57F109CFF00A5D87FDF95FF001AF0B0585A75E2E53BE87AFC5382855AF4DCEFB7EA3750F03EB51B2660B719CF49451581AAFC52F10B347FE91647AF4847B7BD15E82CBE9256D4F97596505DCFFFD9, 1, 1, 0, 1, N'HRUAE')
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UG', N'UGANDA', N'UGANDAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D483C39E179080B77A83331C0055793F952EABE09F0F5822B5D4FA8C61C95180BC11D8F1C51069FE138D83AC57C8CA720F9E0107F3A975B9FC39ABB06BD17B2303B8912A824FA9C1E7FF00AE6BE49621D9DEA55BFA47FCCF77EA327356A3A76E6FD6DA7DCCE78F87FC2609DB7FA9FE4BFE145074FF000702716DA89FFB6E3FC68AA55E76FE254FB97F99D3F505FF0040FF00F93FFF006A7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UK', N'UNITED KINGDOM', N'BRITON', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DF8ECED6FA18659E4B5B5BB85D4931C80A4AB9EB8EC7D7F4F4A8A4B4B3BEF3239AEE382317464249C165C1E94C8F53B5D3E1862985A5DDE4ECB955894242A48E090393EBFE4D45FDA96563E63CD6F0DC466E8C64100955C1E9457FAFFD62972DAFEF72DAF6DB5B5F5F4F3D8ECC2ACB7EAB5B9B9ADEE735ED7DFDDBDB4F5EB6DCCED4E693ED7B6D059DBC0ABB517CC566239E58FAD150EA8B27DAC359CD67716ECA191BCA45603278618EB457A50FADF2AB727FE4DFAEBF79E74D60799DD54FFC97F4D3EE3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'US', N'UNITED STATES', N'AMERICAN;', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F009A13135AC24A44494524951CF15B16169692E9A8EF696EEC4B649881FE23FF004D47F215ADF6CB1F257FD26D73B47FCB44F4FF00AE55466BFB203FE3EED47FDB64FF00E354B32CD2962E9285ADADFF0033B728C9B1181ACEA5F756EBDD7F91977761642618B2B71C76847FF1FA2A2BCBFB3330C5DDB1F97B4A9EBFF5C68AF323C963DE97D62FD4FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UY', N'URUGUAY', N'URUGUAYAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000D001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00DBD1F50D13FB03484FF89093F634F39DC5BF99BF674F9875CFAFE359A2EA3C7FACB5FF00BF9A47FF00135C7D878B65B3D3ADAD956E088A25518683B0F7849FD4D58FF84DA6FEEDCFFDF56FFF00C62BB70AB0F4399B973736BADDDBC969B18D4F693B595ADD877898C6DA946C9E5FCD029251AD88279FF9E202FF005A2A86A3AC1D5A74B86590158C27CCC849C67FBA8A3BFA5158D5941CDB8DAC108C92D4FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'UZ', N'UZBEKISTAN', N'UZBEK', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F43B5D16F59519B4D8CE114637C67271D7AD53D4B40D424398F4F8D7031F7D07F5ACEB7F186AC10037B1AE074F2D3FC2AB5DF8CF5800E2F623FF006CD2B9D67ED4AE9BFB91E7C9E01C6CED6FFB78A773A06AB1CB836CA3233C4ABFE34566CFE2DD6659326E14E38E225FF0A2BA9710556AF77F723154B2DB68BFF4B3FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VC', N'SAINT VINCENT AND THE GRENADINES', N'VINCENTIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B5E14BA8EDB5B5B874DC2282472319CE14D763A86B96D77631C1F67DA6EAC9A5276F43EDEDC1E7E95C2782E65FF849A15940D863915837A6D3C575771BADB4AD6249CC5F2ABA5B6D2388F03A7A0E178F6AF3B8C6A43FB422BAF2C7F3679195D3AF1C2BE5DAF2BFC927F8AD0E3EF4859C043818ED45664F77E63823278ED4579508BE5479AB5573FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VE', N'VENEZUELA', N'VENEZUELAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EA2C3C536CBABDCC93DC34966EA3CA4F2C92A78ED8E3BD5EB8F16E8A8A5897C0EB88B38AE392D6D238F21F0C57072DD2A94D0C09B82B8C30C11B85787572AE1C9CB99FB5E8B4E5E9F23B619667CE5A7B3FBD9D25D78C746328D924A063FE791145705710C624C2E48C76A2B48E5B90A5EEFB4B7C8EAFECFCE169274EFEACFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VG', N'BRITISH VIRGIN ISLANDS', N'BRITISH VIRGIN ISLANDER;', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D51269E618449F66DE5479D9527B719C1EBEB8FC6B12E2D1EF3539A38CC40E49C8C05E99E31F4ACD12E38A9ADEFC5ABF98A4AC83387520F0460820F0457D156C157C2D2A9530B3729CAD64EDA6D7B5F4D97E4BA1F35571EB17C94AAC14631EAB77BEFF007FDF77D4A8382467BF6A29AD2ABB1289B57A601CFE3457A341CFD947DAFC5657F5B6BB69B9C6E0D3F7763FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VI', N'US VIRGIN ISLANDS', N'US VIRGIN ISLANDER', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC0001108000F001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F5D975A582F3C80C92021884DA430DB8C8F7EB597178A16E5E453657510DA64579A30AA1476E0F5E7F9D68DE595ADE98646DD1CD0B178E48C952091839C7507BD673696524CACE0C45FE742BD53FBA3D3B5704E8D6551A849F2CB6775EEF7F5F25AD9DBA0E2F4BCB75DBAFAFFC0278A47B84F33CC5E7FBA381450ECAAC7600A0F270314576469A8AB26DFABD42EDEE7FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VN', N'VIETNAM', N'VIETNAMESE', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D2B483CFD8891EF761C00324D4BA869371691248F0304640E4ECE1727A1F7ACB82F23458C9900C019F9B06AEEABE226D4A25495A30118B26D7E831D0FAFD6BE426E774A2B43F446AA7B45CB6B75331B018D1559AE14B1C3AFE745524EC763B1FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'VU', N'VANUATU', N'VANUATUAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F0034EBB0D656ED342A8EC8A3696077E470464E413E87AF6F4A92E248483851F4D9FF00D6AA1A3C6C34EB74B99D642A15C31503660700679247A9E9D877AB374F160ED73FF7F0FF008D7CBD692E7697E1FF0004EC87133C1AE46B9EDF87CCC6BD902CE0025463A608A2A3B801E5C9DCDC632493456D4EDCAB729F19736BECBF13FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'WS', N'SAMOA', N'SAMOAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00AB135AB5BA99141194F38BB6D71C9FB9D720803248E0E2ADDA61B4F89B18C83D7EA6961BA411265D41DA3A9A6CB75191FEB17FEFA15C39AE76F1F4953F67CB677DEFD1AECBB9F499270DACAEBBAAAA735D5B6B754FBBEC54B890A4980C471D8D154EEE6066054E463B515E4422DC51F47524949A3FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'YE', N'YEMEN', N'YEMENI', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00EB13C1DAB4B0AE2DADC9C0E7CC5AA573E08D6067FD1ADBFEFE2D64A7C4DF10C70A859ED010075847F8D51B9F8A5E2539FDFD9FFDF81FE35C0F2DA2FAB3DA8E7D8A8EC97DCFFCC9AF3C21ABC7301E5C2BC74128A2B9EBAF88DE239A5DC64B72718F96DC5156B03492B6A0F3DC5377B2FBBFE09FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ZA', N'SOUTH AFRICA', N'SOUTH AFRICAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00D8D2350B0BAB36F208BCB1CEE92070165818F7F63EE320F7A65E69B62C4B43A85988CF2A2546571EC405233F435474BB6B2B2B16F20FD92CB3B659DF0D34EC3B7BFD0600EF50DD6B90062B06996A631C29959D9CFB92180CFD0579380CA3178D529525EE2D9CB47F87F5F3392967D572E7C98697BAFA34DAF97548A579A6C426F9352B2C63F84BFF00F1345569B570CF9FECAB3FC049FF00C5515E92E1EC5C55BDDFBD9D8B8AF1F2F7BDDFB99FFFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Countries] ([CountryID], [Country], [Nationality], [ZipCode], [Flag], [WorkingCountry], [ActiveCountry], [AssetCodeCounter], [HRConnect], [HRDatabase]) VALUES (N'ZM', N'ZAMBIA', N'ZAMBIAN', NULL, 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080010001403012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B76D1C4D129655CED1D45473ADB22932E547AA818AAB15DAAC6A3701C0EF54B59D410696E0907E615F27469B9D5517D59E3E5986589A928BFB316F6ED6F41F3C33093F770CEA84647CA79A2BB917424B6B520FFCB041C7D28ADA33695AC7B8B87135773FC3FE09FFD9, 0, 0, 0, 0, NULL)
GO
INSERT [GSET].[Currencies] ([CurCode], [CurName]) VALUES (N'USD', N'American Dollar')
GO
INSERT [GSET].[Currencies] ([CurCode], [CurName]) VALUES (N'EUR', N'EURO')
GO
INSERT [GSET].[Currencies] ([CurCode], [CurName]) VALUES (N'LBP', N'Lebanese Pound')
GO
INSERT [GSET].[CurrenciesRates] ([CurCode], [StartDate], [Rate]) VALUES (N'EUR', CAST(N'1900-01-01' AS Date), 1800)
GO
INSERT [GSET].[CurrenciesRates] ([CurCode], [StartDate], [Rate]) VALUES (N'LBP', CAST(N'1900-01-01' AS Date), 1)
GO
INSERT [GSET].[CurrenciesRates] ([CurCode], [StartDate], [Rate]) VALUES (N'USD', CAST(N'1900-01-01' AS Date), 1500)
GO
INSERT [GSET].[LogSeverity] ([LogSeverityID], [LogSeverity]) VALUES (3, N'High')
GO
INSERT [GSET].[LogSeverity] ([LogSeverityID], [LogSeverity]) VALUES (1, N'Low')
GO
INSERT [GSET].[LogSeverity] ([LogSeverityID], [LogSeverity]) VALUES (2, N'Medium')
GO
INSERT [GSET].[LogSystem] ([LogSystemID], [LogSystem]) VALUES (3, N'Assets')
GO
INSERT [GSET].[LogSystem] ([LogSystemID], [LogSystem]) VALUES (2, N'Contacts')
GO
INSERT [GSET].[LogSystem] ([LogSystemID], [LogSystem]) VALUES (1, N'General')
GO
INSERT [GSET].[LogTypes] ([LogTypeID], [LogType]) VALUES (1, N'Error')
GO
INSERT [GSET].[LogTypes] ([LogTypeID], [LogType]) VALUES (2, N'Important Info')
GO
INSERT [GSET].[LogTypes] ([LogTypeID], [LogType]) VALUES (3, N'Info')
GO
INSERT [GSET].[LogTypes] ([LogTypeID], [LogType]) VALUES (4, N'Warning')
GO
INSERT [GSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (0, N'1', N'RegKey', N'General')
GO
INSERT [GSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (1, N'H:\E-Unity\Reports', N'Attachments Location', N'General')
GO
INSERT [GSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (2, N'dd/MM/yyyy', N'Date Format', N'General')
GO
INSERT [GSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (3, N'###,###,###,###,###,##0.0###############', N'General  Number Format', N'Number Format')
GO
INSERT [GSET].[Settings] ([SetID], [SetValue], [SetDescription], [SetType]) VALUES (4, N'yyyy-MM-dd', N'Date format for SQL statement', N'General')
GO
SET IDENTITY_INSERT [GTBL].[Contacts] ON 
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (1, N'MICROCITY', 2, N'', NULL, N'', NULL, N'Beirut, Hamra', N'LB', N'0', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (2, N'IOC', 2, N'', NULL, N'', NULL, N'MEKALESS', N'LB', N'01/697796', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (3, N'LIBATEL', 2, N'', NULL, N'', NULL, N'Dimitri El Hayek Street، Debahy Center, 1st floor، Mkalles، Beirut', N'LB', N'01/514000', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (4, N'EDM', 1, NULL, NULL, NULL, NULL, N'HAMRA', N'LB', N'01/700332', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (5, N'BTC', 1, N'', NULL, N'', NULL, N'LEBANON', N'LB', N'01/756550', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (6, N'LIBATEL', 1, N'', NULL, N'', NULL, N'LEBANON', N'LB', N'01/514000', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (7, N'QUANTUM', 1, N'', NULL, N'', NULL, N'LEBANON', N'LB', N'01/666723', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [GTBL].[Contacts] ([ContactID], [ContactName], [ContactTypeID], [ContactPerson], [ContactPersonEmail], [FinancialContact], [FinancialContactEmail], [Address], [CountryID], [Telephone1], [Telephone2], [Mobile1], [Mobile2], [Fax1], [Fax2], [Remark]) VALUES (8, N'PC DEAL NET', 1, N'', NULL, N'', NULL, N'LEBANON', N'LB', N'01/595646', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [GTBL].[Contacts] OFF
GO
SET IDENTITY_INSERT [GTBL].[Logs] ON 
GO
INSERT [GTBL].[Logs] ([LogID], [UserID], [FullName], [DateTime], [DomainUser], [Computer], [SQLHostName], [SQLLoggedName], [SQLCurrentUser], [LogSystemID], [LogSeverityID], [LogTypeID], [FormName], [MethodName], [LogDesc], [SentByEmail]) VALUES (4, 9999, N'Administrator', CAST(N'2020-05-04T17:43:39.630' AS DateTime), N'Domain\Administrator', N'SERVER', N'SA', N'SA', N'SA', 3, 1, 1, N'LogIn', N'Activiation', N'True', 0)
GO
SET IDENTITY_INSERT [GTBL].[Logs] OFF
GO
INSERT [SEC].[Roles] ([RoleID], [RoleName]) VALUES (1, N'Administrator')
GO
INSERT [SEC].[Roles] ([RoleID], [RoleName]) VALUES (2, N'System Auditor')
GO
INSERT [SEC].[Roles] ([RoleID], [RoleName]) VALUES (3, N'Full Access User')
GO
SET IDENTITY_INSERT [SEC].[Users] ON 
GO
INSERT [SEC].[Users] ([UserID], [UserName], [UserPassword], [FullName], [RoleID], [EmailAddress]) VALUES (3, N'alisaker', 0x3316D98CAFC7089B1F39373AF67AE89C1611C630AE3822B4175E7EB510199912, N'Ali Saker', 1, N'alisaker@example.com')
GO
INSERT [SEC].[Users] ([UserID], [UserName], [UserPassword], [FullName], [RoleID], [EmailAddress]) VALUES (6, N'test1', 0x3316D98CAFC7089B1F39373AF67AE89C1611C630AE3822B4175E7EB510199912, N'test1', 3, N'alloushifalkon8@gmail.com')
GO
INSERT [SEC].[Users] ([UserID], [UserName], [UserPassword], [FullName], [RoleID], [EmailAddress]) VALUES (7, N'test2', 0x3316D98CAFC7089B1F39373AF67AE89C1611C630AE3822B4175E7EB510199912, N'test2', 2, N'test2@example.com')
GO
SET IDENTITY_INSERT [SEC].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Assets]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [AT].[Assets] ADD  CONSTRAINT [IX_Assets] UNIQUE NONCLUSTERED 
(
	[AssetCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Depreciations]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [AT].[Depreciations] ADD  CONSTRAINT [IX_Depreciations] UNIQUE NONCLUSTERED 
(
	[DepreciationDate] ASC,
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Inventories]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [AT].[Inventories] ADD  CONSTRAINT [IX_Inventories] UNIQUE NONCLUSTERED 
(
	[InventoryStartDate] ASC,
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_BrandTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[BrandTypes] ADD  CONSTRAINT [IX_BrandTypes] UNIQUE NONCLUSTERED 
(
	[BrandDesc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Categories]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[CategoryTypes] ADD  CONSTRAINT [IX_Categories] UNIQUE NONCLUSTERED 
(
	[Category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_GroupTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[GroupTypes] ADD  CONSTRAINT [IX_GroupTypes] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LocationTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[LocationTypes] ADD  CONSTRAINT [IX_LocationTypes] UNIQUE NONCLUSTERED 
(
	[Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_OwnerTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[OwnerTypes] ADD  CONSTRAINT [IX_OwnerTypes] UNIQUE NONCLUSTERED 
(
	[OwnerDesc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_StatusTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [ATSET].[StatusTypes] ADD  CONSTRAINT [IX_StatusTypes] UNIQUE NONCLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AddressDetail1]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[AddressDetail1] ADD  CONSTRAINT [IX_AddressDetail1] UNIQUE NONCLUSTERED 
(
	[AddressDetail1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AddressDetail2]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[AddressDetail2] ADD  CONSTRAINT [IX_AddressDetail2] UNIQUE NONCLUSTERED 
(
	[AddressDetail2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Companies]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[Companies] ADD  CONSTRAINT [IX_Companies] UNIQUE NONCLUSTERED 
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ContactTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[ContactTypes] ADD  CONSTRAINT [IX_ContactTypes] UNIQUE NONCLUSTERED 
(
	[ContactType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Currencies]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[Currencies] ADD  CONSTRAINT [IX_Currencies] UNIQUE NONCLUSTERED 
(
	[CurName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LogSeverity]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[LogSeverity] ADD  CONSTRAINT [IX_LogSeverity] UNIQUE NONCLUSTERED 
(
	[LogSeverity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LogSystem]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[LogSystem] ADD  CONSTRAINT [IX_LogSystem] UNIQUE NONCLUSTERED 
(
	[LogSystem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LogTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [GSET].[LogTypes] ADD  CONSTRAINT [IX_LogTypes] UNIQUE NONCLUSTERED 
(
	[LogType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_NotifLog]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [NOTIF].[NotificationLogs] ADD  CONSTRAINT [UQ_NotifLog] UNIQUE NONCLUSTERED 
(
	[Type] ASC,
	[EntityID] ASC,
	[IntervalLabel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Roles]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [SEC].[Roles] ADD  CONSTRAINT [IX_Roles] UNIQUE NONCLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users]    Script Date: 09/07/2026 11:18:04 AM ******/
ALTER TABLE [SEC].[Users] ADD  CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [AT].[Assets] ADD  CONSTRAINT [DF_Assets_Donation]  DEFAULT ((0)) FOR [Donation]
GO
ALTER TABLE [AT].[Assets] ADD  CONSTRAINT [DF_Assets_PurchasePrice]  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [AT].[Attachments] ADD  DEFAULT ('') FOR [FilePath]
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
ALTER TABLE [GSET].[Countries] ADD  CONSTRAINT [DF_Countries_Asset Code Counter]  DEFAULT ((0)) FOR [AssetCodeCounter]
GO
ALTER TABLE [GSET].[Countries] ADD  CONSTRAINT [DF_Countries_HRExist]  DEFAULT ((0)) FOR [HRConnect]
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
ALTER TABLE [NOTIF].[NotificationLogs] ADD  DEFAULT (getdate()) FOR [SentAt]
GO
ALTER TABLE [NOTIF].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [NOTIF].[Notifications] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [SEC].[Users] ADD  CONSTRAINT [DF_Users_RoleID]  DEFAULT ((1)) FOR [RoleID]
GO
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_BrandTypes] FOREIGN KEY([BrandID])
REFERENCES [ATSET].[BrandTypes] ([BrandID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_BrandTypes]
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
ALTER TABLE [AT].[Assets]  WITH CHECK ADD  CONSTRAINT [FK_Assets_OwnerTypes] FOREIGN KEY([OwnerID])
REFERENCES [ATSET].[OwnerTypes] ([OwnerID])
GO
ALTER TABLE [AT].[Assets] CHECK CONSTRAINT [FK_Assets_OwnerTypes]
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
ALTER TABLE [AT].[Depreciations]  WITH CHECK ADD  CONSTRAINT [FK_Depreciations_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [AT].[Depreciations] CHECK CONSTRAINT [FK_Depreciations_Companies]
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
ALTER TABLE [AT].[Inventories]  WITH CHECK ADD  CONSTRAINT [FK_Inventories_Companies] FOREIGN KEY([CompanyID])
REFERENCES [GSET].[Companies] ([CompanyID])
GO
ALTER TABLE [AT].[Inventories] CHECK CONSTRAINT [FK_Inventories_Companies]
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
ALTER TABLE [AT].[Maintenances]  WITH CHECK ADD  CONSTRAINT [FK_Maintenances_Attachments] FOREIGN KEY([AttID])
REFERENCES [AT].[Attachments] ([AttID])
GO
ALTER TABLE [AT].[Maintenances] CHECK CONSTRAINT [FK_Maintenances_Attachments]
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
ALTER TABLE [AT].[Warranties]  WITH CHECK ADD  CONSTRAINT [FK_Warranties_Attachments] FOREIGN KEY([AttID])
REFERENCES [AT].[Attachments] ([AttID])
GO
ALTER TABLE [AT].[Warranties] CHECK CONSTRAINT [FK_Warranties_Attachments]
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
ALTER TABLE [ATSET].[OwnerTypes]  WITH CHECK ADD  CONSTRAINT [FK_OwnerTypes_OwnerTypes] FOREIGN KEY([OwnerID])
REFERENCES [ATSET].[OwnerTypes] ([OwnerID])
GO
ALTER TABLE [ATSET].[OwnerTypes] CHECK CONSTRAINT [FK_OwnerTypes_OwnerTypes]
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
/****** Object:  StoredProcedure [AT].[rstpAssetsList]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[rstpAssetsListInventory]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[rstpAssetsNotDepreciated]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[rstpDepreciation]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpAssetsD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [AT].[stpAssetsD]
(
@AssetID int
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @LastAssetID int;
DECLARE @CountryID char(2);

BEGIN TRY
    BEGIN TRAN;

    SELECT
        @CountryID = c.CountryID
    FROM AT.Assets a
    INNER JOIN GSET.Companies c ON c.CompanyID = a.CompanyID
    WHERE a.AssetID = @AssetID;

    IF @CountryID IS NULL
        THROW 50010, 'Delete failed: Asset not found.', 1;

    SELECT @LastAssetID = MAX(AssetID)
    FROM AT.Assets;

    IF @AssetID <> @LastAssetID
        THROW 50011, 'Delete failed: You can delete only the last asset record.', 1;

    DELETE FROM AT.Assets
    WHERE AssetID = @AssetID;

    IF @@ROWCOUNT = 0
        THROW 50012, 'Delete failed: Asset was not deleted.', 1;

    UPDATE GSET.Countries
    SET AssetCodeCounter =
        CASE
            WHEN AssetCodeCounter > 0 THEN AssetCodeCounter - 1
            ELSE 0
        END
    WHERE CountryID = @CountryID;

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    THROW;
END CATCH
END
GO
/****** Object:  StoredProcedure [AT].[stpAssetsDepreciationHistory]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpAssetsI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [AT].[stpAssetsI]
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
@BrandID smallint,
@Model nvarchar(50),
@Remark nvarchar(100),
@InstalledAt nvarchar(50),
@OwnerID tinyint,
@OwnerDesc nvarchar(50),
@HREmpIDUsedBy nchar(10)
)
AS
BEGIN
SET NOCOUNT OFF;
IF NULLIF(LTRIM(RTRIM(@Model)), N'') IS NULL
    THROW 50001, 'Model is required.', 1;

IF EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc <> N'Company')
   AND NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') IS NULL
    THROW 50002, 'Owner description is required when the asset is not company-owned.', 1;

INSERT INTO [AT].[Assets]
(
    [CompanyID], [AssetCode], [AssetImage], [AssetDesc], [LocationID], [LocDetailID],
    [GroupID], [CategoryID], [Donation], [ContactID], [PurchaseOrderNo], [PurchaseDate],
    [PurchasePrice], [PurchaseCurCode], [InServiceDate], [InvoiceNo], [InvoiceDate],
    [AccountingEntryDate], [AccountingEntryJVNo], [BarcodeNumber], [SerialNumber],
    [BrandID], [Model], [StatusID], [Remark], [InstalledAt], [OwnerID], [OwnerInfo], [HREmpIDUsedBy]
)
VALUES
(
    @CompanyID, @AssetCode, @AssetImage, @AssetDesc, @LocationID, @LocDetailID,
    @GroupID, @CategoryID, @Donation, @ContactID, @PurchaseOrderNo, @PurchaseDate,
    @PurchasePrice, @PurchaseCurCode, @InServiceDate, @InvoiceNo, @InvoiceDate,
    @AccountingEntryDate, @AccountingEntryJVNo, @BarcodeNumber, @SerialNumber,
    @BrandID, LTRIM(RTRIM(@Model)), 0, @Remark, @InstalledAt, @OwnerID,
    CASE WHEN EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc = N'Company')
        THEN NULL ELSE NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') END,
    NULLIF(LTRIM(RTRIM(@HREmpIDUsedBy)), N'')
);

SELECT SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [AT].[stpAssetsInventoryHistory]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpAssetsList]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpAssetsS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [AT].[stpAssetsS]
(
@AssetID int
)
AS
BEGIN
SET NOCOUNT ON;

SELECT      a.AssetID, a.CompanyID, a.AssetCode, a.AssetDesc, a.LocationID, a.LocDetailID,
            a.GroupID, a.CategoryID, a.Donation, a.ContactID, a.PurchaseOrderNo, a.PurchaseDate,
            a.PurchasePrice, a.PurchaseCurCode, a.InServiceDate, a.InvoiceNo, a.InvoiceDate,
            a.AccountingEntryDate, a.AccountingEntryJVNo, a.BarcodeNumber, a.SerialNumber,
            a.BrandID, a.Model, a.StatusID, st.Status AS StatusName, bt.BrandDesc,
            a.StatusDate, a.Remark, a.InstalledAt, a.OwnerID, a.OwnerInfo AS OwnerDesc,
            ot.OwnerDesc AS OwnerTypeDesc,
            a.HREmpIDUsedBy AS HrEmpIDUsedBy
FROM AT.Assets a
LEFT OUTER JOIN ATSET.StatusTypes st ON a.StatusID = st.StatusID
LEFT OUTER JOIN ATSET.BrandTypes bt ON a.BrandID = bt.BrandID
LEFT OUTER JOIN ATSET.OwnerTypes ot ON a.OwnerID = ot.OwnerID
WHERE a.AssetID = @AssetID;
END
GO
/****** Object:  StoredProcedure [AT].[stpAssetsStatusRemove]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Recreate AT.stpAssetsStatusRemove */
CREATE PROCEDURE [AT].[stpAssetsStatusRemove]
(
    @StatusID tinyint,
    @StatusDate date,
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
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Assets]
    SET [StatusID] = 0,
        [StatusDate] = @StatusDate
    WHERE [AssetID] = @AssetID;

    INSERT INTO [AT].[StatusHistory]
    (
        AssetID,
        StatusID,
        StatusDate,
        StatusDesc,
        [StatusContactID],
        [StatusSalePrice],
        [StatusSaleCurCode],
        CreatedByUserID,
        CreatedByFullName,
        CreatedByDateTime
    )
    VALUES
    (
        @AssetID,
        @StatusID,
        @StatusDate,
        @StatusDesc,
        @StatusContactID,
        @StatusSalePrice,
        @StatusSaleCurCode,
        @CreatedByUserID,
        @CreatedByFullName,
        @CreatedByDateTime
    );
END;
GO
/****** Object:  StoredProcedure [AT].[stpAssetsStatusU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Recreate AT.stpAssetsStatusU with return-from-maintenance rule */
CREATE PROCEDURE [AT].[stpAssetsStatusU]
(
    @AssetStatusID tinyint,
    @AssetStatusDate date,
    @StatusID tinyint,
    @StatusDate date,
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
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Assets]
    SET [StatusID] = CASE WHEN @StatusID = 9 THEN 0 ELSE @AssetStatusID END,
        [StatusDate] = @AssetStatusDate
    WHERE [AssetID] = @AssetID;

    INSERT INTO [AT].[StatusHistory]
    (
        AssetID,
        StatusID,
        StatusDate,
        StatusDesc,
        [StatusContactID],
        [StatusSalePrice],
        [StatusSaleCurCode],
        CreatedByUserID,
        CreatedByFullName,
        CreatedByDateTime
    )
    VALUES
    (
        @AssetID,
        @StatusID,
        @StatusDate,
        @StatusDesc,
        @StatusContactID,
        @StatusSalePrice,
        @StatusSaleCurCode,
        @CreatedByUserID,
        @CreatedByFullName,
        @CreatedByDateTime
    );
END;
GO
/****** Object:  StoredProcedure [AT].[stpAssetsU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [AT].[stpAssetsU]
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
@BrandID smallint,
@Model nvarchar(50),
@Remark nvarchar(100),
@InstalledAt nvarchar(50),
@OwnerID tinyint,
@OwnerDesc nvarchar(50),
@HREmpIDUsedBy nchar(10),
@AssetID int
)
AS
BEGIN
SET NOCOUNT OFF;
IF NULLIF(LTRIM(RTRIM(@Model)), N'') IS NULL
    THROW 50001, 'Model is required.', 1;

IF EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc <> N'Company')
   AND NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') IS NULL
    THROW 50002, 'Owner description is required when the asset is not company-owned.', 1;

UPDATE [AT].[Assets]
SET [CompanyID] = @CompanyID,
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
    [AccountingEntryDate] = @AccountingEntryDate,
    [AccountingEntryJVNo] = @AccountingEntryJVNo,
    [BarcodeNumber] = @BarcodeNumber,
    [SerialNumber] = @SerialNumber,
    [BrandID] = @BrandID,
    [Model] = LTRIM(RTRIM(@Model)),
    [Remark] = @Remark,
    [InstalledAt] = @InstalledAt,
    [OwnerID] = @OwnerID,
    [OwnerInfo] = CASE WHEN EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc = N'Company')
        THEN NULL ELSE NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') END,
    [HREmpIDUsedBy] = NULLIF(LTRIM(RTRIM(@HREmpIDUsedBy)), N'')
WHERE [AssetID] = @AssetID;
END
GO
/****** Object:  StoredProcedure [AT].[stpAttachmentByID]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAttachmentByID] (@AttID int)
AS
    SET NOCOUNT ON;
    SELECT AttID, AssetID, FilePath, AttDesc, AttFileName, AttFileExt, Remark
    FROM AT.Attachments WHERE AttID = @AttID

GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpAttachmentsI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAttachmentsI]
  (@AssetID int, @FilePath nvarchar(500), @AttDesc nvarchar(50),
   @AttFileName nvarchar(255), @AttFileExt nchar(5), @Remark nvarchar(100))
AS
    SET NOCOUNT OFF;
    INSERT INTO [AT].[Attachments] ([AssetID],[FilePath],[AttDesc],[AttFileName],[AttFileExt],[Remark])
    VALUES (@AssetID, @FilePath, @AttDesc, @AttFileName, @AttFileExt, @Remark);
    SELECT AttID,AssetID,FilePath,AttDesc,AttFileName,AttFileExt,Remark
    FROM AT.Attachments WHERE AttID = SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpAttachmentsS] (@AssetID int)
AS
    SET NOCOUNT ON;
    SELECT AttID,AssetID,FilePath,AttDesc,AttFileName,AttFileExt,Remark
    FROM AT.Attachments WHERE AssetID = @AssetID
GO
/****** Object:  StoredProcedure [AT].[stpAttachmentsU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpDepreciationLastDelete]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpDepreciationLastDelete]
(
	@CompanyID smallint,
	@DepreciationDate date output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	SET @DepreciationDate = (SELECT TOP 1 DepreciationDate From AT.Depreciations WHERE CompanyID = @CompanyID ORDER BY DepreciationDate DESC)
		
	DELETE FROM AT.DepreciationsDetails WHERE DepID = (SELECT DepID FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate AND CompanyID = @CompanyID)
	DELETE FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate AND CompanyID = @CompanyID

END
GO
/****** Object:  StoredProcedure [AT].[stpGetAssetCodeList]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpGetDepreciation]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetDepreciation]
(
	@CompanyID smallint
)
AS
	SET NOCOUNT ON;

	SELECT DepID, DepreciationDate, CompanyID 
	FROM AT.Depreciations
	WHERE CompanyID = @CompanyID
	ORDER BY DepreciationDate DESC
GO
/****** Object:  StoredProcedure [AT].[stpGetDepreciationLastDate]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetDepreciationLastDate]
(
	@CompanyID smallint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 * 
	FROM AT.Depreciations 
	WHERE CompanyID = @CompanyID
	ORDER BY DepreciationDate DESC
END
GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryFinishInfo]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpGetInventoryInfo]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetInventoryInfo]
(
    @CompanyID smallint
)
AS
    SET NOCOUNT ON;
    SELECT  InventoryID,
            CONVERT(varchar, InventoryStartDate, 103) + ' - ' + ISNULL(CONVERT(varchar, InventoryEndDate, 103), 'Open Inventory') AS Inventory
    FROM    AT.Inventories
    WHERE   CompanyID = @CompanyID
    ORDER BY InventoryID DESC
GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryLastDate]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetInventoryLastDate]
(
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 * FROM AT.Inventories
    WHERE CompanyID = @CompanyID
    ORDER BY InventoryStartDate DESC
END
GO
/****** Object:  StoredProcedure [AT].[stpGetInventoryMode]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpGetInventoryMode]
(
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 InventoryID, CompanyID, InventoryStartDate, InventoryEndDate, Remark,
                 StartCreatedByUserID, StartCreatedByFullName, StartCreatedByDateTime
    FROM AT.Inventories
    WHERE InventoryEndDate IS NULL
      AND CompanyID = @CompanyID
    ORDER BY InventoryID DESC
END
GO
/****** Object:  StoredProcedure [AT].[stpInventoriesDetailsList]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpInventoriesDetailsList]
(
    @InventoryID int,
    @LocationID smallint = -1,
    @CompanyID smallint = -1,
    @CategoryID smallint = -1,
    @GroupID smallint = -1,
    @LocationDetailID smallint = -1,
    @AccountingExclusion bit = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  ID.InvDetailID, ID.InventoryID, ID.AssetID, ID.IsAvailable, ID.AssetCode, ID.AssetDesc,
            ID.Relocated,
            LT_R.Location  AS RelocatedLocation,
            LD_R.Floor     AS RelocatedFloor,
            LD_R.Zone      AS RelocatedZone,
            LD_R.Room      AS RelocatedRoom,
            ID.BarcodeNumber, ID.SerialNumber, ID.Remark, ID.CreatedDate,
            C.CompanyAbbreviation,
            LT.Location, LD.Floor, LD.Zone, LD.Room,
            GT.GroupName,
            CT.Category
    FROM    AT.InventoriesDetails ID
            LEFT JOIN ATSET.LocationDetails LD_R ON ID.RelocatedLocDetailID = LD_R.LocDetailID
            LEFT JOIN ATSET.LocationTypes   LT_R ON ID.RelocatedLocationID  = LT_R.LocationID
            LEFT JOIN ATSET.LocationTypes   LT   ON ID.LocationID           = LT.LocationID
            LEFT JOIN ATSET.LocationDetails LD   ON ID.LocDetailID          = LD.LocDetailID
            LEFT JOIN GSET.Companies        C    ON ID.CompanyID            = C.CompanyID
            LEFT JOIN ATSET.GroupTypes      GT   ON ID.GroupID              = GT.GroupID
            LEFT JOIN ATSET.CategoryTypes   CT   ON ID.CategoryID           = CT.CategoryID
    WHERE   ID.InventoryID = @InventoryID
      AND   (@CompanyID      = -1 OR ID.CompanyID    = @CompanyID)
      AND   (@LocationID     = -1 OR ID.LocationID   = @LocationID)
      AND   (@CategoryID     = -1 OR ID.CategoryID   = @CategoryID)
      AND   (@GroupID        = -1 OR ID.GroupID      = @GroupID)
      AND   (@LocationDetailID = -1 OR ID.LocDetailID = @LocationDetailID)
END
GO
/****** Object:  StoredProcedure [AT].[stpInventoriesList]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [AT].[stpInventoriesList]
(
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        i.InventoryID,
        i.CompanyID,
        i.InventoryStartDate,
        i.InventoryEndDate,
        i.Remark,
        i.StartCreatedByFullName,
        i.StartCreatedByDateTime,
        i.EndCreatedByFullName,
        i.EndCreatedByDateTime,
        COUNT(d.InvDetailID)           AS TotalAssets,
        SUM(CAST(d.IsAvailable AS int)) AS FoundAssets,
        SUM(CAST(d.Relocated   AS int)) AS RelocatedAssets
    FROM AT.Inventories i
    LEFT JOIN AT.InventoriesDetails d ON i.InventoryID = d.InventoryID
    WHERE i.CompanyID      = @CompanyID
      AND i.InventoryEndDate IS NOT NULL
    GROUP BY
        i.InventoryID, i.CompanyID, i.InventoryStartDate, i.InventoryEndDate,
        i.Remark, i.StartCreatedByFullName, i.StartCreatedByDateTime,
        i.EndCreatedByFullName, i.EndCreatedByDateTime
    ORDER BY i.InventoryStartDate DESC
END
GO
/****** Object:  StoredProcedure [AT].[stpInventoryGeneratedList]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpInventoryGeneratedList]
(
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AT.Inventories
    WHERE CompanyID = @CompanyID
    ORDER BY InventoryStartDate ASC
END
GO
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailable]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailableAllAssets]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpInventoryIsAvailableAllAssets]
(
    @InventoryID int,
    @IsAvailable bit
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AT.InventoriesDetails
    SET IsAvailable = @IsAvailable
    WHERE InventoryID = @InventoryID;

    SELECT @@ROWCOUNT;
END;
GO
/****** Object:  StoredProcedure [AT].[stpInventoryIsAvailableByAssetCode]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpInventoryRelocatedS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [AT].[stpInventoryRelocatedU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpInventoryRelocatedU]
(
    @InvDetailID int,
    @RelocatedLocationID smallint,
    @RelocatedLocDetailID smallint,
    @Remark nvarchar(100) = NULL,
    @Relocated bit = 1
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AT.InventoriesDetails
    SET RelocatedLocationID  = @RelocatedLocationID,
        RelocatedLocDetailID = @RelocatedLocDetailID,
        Relocated            = @Relocated,
        Remark               = @Remark
    WHERE InvDetailID = @InvDetailID
END
GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 3) Procedures - Maintenance */
CREATE PROCEDURE [AT].[stpMaintenancesD]
(
    @Original_MaintID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_FromDate date,
    @Original_ToDate date,
    @Original_SupplierContactID int,
    @Original_Cost float,
    @Original_CurCode char(3),
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    DELETE FROM [AT].[Maintenances]
    WHERE ([MaintID] = @Original_MaintID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ([SupplierContactID] = @Original_SupplierContactID)
      AND ([Cost] = @Original_Cost)
      AND ([CurCode] = @Original_CurCode)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));
END
GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpMaintenancesI]
(
    @AssetID int,
    @AttID int,
    @FromDate date,
    @ToDate date,
    @SupplierContactID int,
    @Cost float,
    @CurCode char(3),
    @Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [AT].[Maintenances]
    (
        [AssetID], [AttID], [FromDate], [ToDate],
        [SupplierContactID], [Cost], [CurCode], [Remark]
    )
    VALUES
    (
        @AssetID, @AttID, @FromDate, @ToDate,
        @SupplierContactID, @Cost, @CurCode, @Remark
    );

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE MaintID = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpMaintenancesS]
(
    @AssetId int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE AssetID = @AssetID;
END
GO
/****** Object:  StoredProcedure [AT].[stpMaintenancesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpMaintenancesU]
(
    @AssetID int,
    @AttID int,
    @FromDate date,
    @ToDate date,
    @SupplierContactID int,
    @Cost float,
    @CurCode char(3),
    @Remark nvarchar(100),
    @Original_MaintID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
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
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Maintenances]
    SET [AssetID] = @AssetID,
        [AttID] = @AttID,
        [FromDate] = @FromDate,
        [ToDate] = @ToDate,
        [SupplierContactID] = @SupplierContactID,
        [Cost] = @Cost,
        [CurCode] = @CurCode,
        [Remark] = @Remark
    WHERE ([MaintID] = @Original_MaintID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ([SupplierContactID] = @Original_SupplierContactID)
      AND ([Cost] = @Original_Cost)
      AND ([CurCode] = @Original_CurCode)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE MaintID = @MaintID;
END
GO
/****** Object:  StoredProcedure [AT].[stpProDepreciation]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AT].[stpProDepreciation]
(
    @DepreciationDate date,
    @CompanyID smallint,
    @CreatedByUserID smallint,
    @CreatedByFullName nvarchar(100),
    @CreatedByDateTime datetime,
    @Remark nvarchar(100),
    @RowEffected int output
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @LastDepreciationDate date;
    DECLARE @DepID int;

    -- Must be after the last prior depreciation date for this company.
    -- Excluding current date keeps same-date rerun behavior.
    SELECT @LastDepreciationDate = MAX(DepreciationDate)
    FROM AT.Depreciations
    WHERE CompanyID = @CompanyID
      AND DepreciationDate <> @DepreciationDate;

    IF @LastDepreciationDate IS NOT NULL AND @DepreciationDate <= @LastDepreciationDate
        THROW 50022, 'Cannot run depreciation: DepreciationDate must be after the last depreciation date.', 1;

    IF (SELECT COUNT(*) FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate AND CompanyID = @CompanyID) > 0
    BEGIN
        DELETE FROM AT.DepreciationsDetails
        WHERE DepID = (SELECT DepID FROM AT.Depreciations WHERE DepreciationDate = @DepreciationDate AND CompanyID = @CompanyID);

        DELETE FROM AT.Depreciations
        WHERE DepreciationDate = @DepreciationDate AND CompanyID = @CompanyID;
    END

    INSERT INTO AT.Depreciations
    (
        DepreciationDate, CompanyID, Remark, CreatedByUserID, CreatedByFullName, CreatedByDateTime
    )
    VALUES
    (
        @DepreciationDate, @CompanyID, @Remark, @CreatedByUserID, @CreatedByFullName, @CreatedByDateTime
    );

    SET @DepID = SCOPE_IDENTITY();

    INSERT INTO AT.DepreciationsDetails
    (
        DepID, AssetID, DepreciationRate,
        DepreciationValue, NetBookValue,
        PurchasePrice, PurchaseCurCode,
        AccountingEntryJVNo, AccountingEntryDate,
        GroupID, CategoryID
    )
    SELECT
        @DepID,
        A.AssetID,
        GT.DepreciationRate,
        ROUND((A.PurchasePrice * GT.DepreciationRate / 100.0) * (DATEDIFF(DAY, A.AccountingEntryDate, @DepreciationDate) + 1) / 365.0, 2),
        ROUND(A.PurchasePrice - ((A.PurchasePrice * GT.DepreciationRate / 100.0) * (DATEDIFF(DAY, A.AccountingEntryDate, @DepreciationDate) + 1) / 365.0), 2),
        A.PurchasePrice,
        A.PurchaseCurCode,
        A.AccountingEntryJVNo,
        A.AccountingEntryDate,
        A.GroupID,
        A.CategoryID
    FROM AT.Assets A
    LEFT JOIN ATSET.GroupTypes GT ON A.GroupID = GT.GroupID
    WHERE
        A.CompanyID = @CompanyID
        AND A.AccountingEntryDate < @DepreciationDate
        AND A.PurchasePrice > 0
        AND StatusID in (0, 8 , 12)
        AND A.OwnerID IN (1, 3)
        AND
        (
            A.AssetID IN
            (
                SELECT AssetID
                FROM AT.DepreciationsDetails DD
                WHERE NetBookValue > 0
                  AND DepID IN
                  (
                      SELECT TOP 1 DepID
                      FROM AT.Depreciations
                      WHERE DepID <> @DepID
                        AND CompanyID = @CompanyID
                      ORDER BY DepreciationDate DESC
                  )
            )
            OR
            A.AssetID NOT IN (SELECT AssetID FROM AT.DepreciationsDetails)
        );

    UPDATE AT.DepreciationsDetails
    SET NetBookValue = 0
    WHERE NetBookValue < 0
      AND DepID = @DepID;

    SET @RowEffected = (SELECT COUNT(*) FROM AT.DepreciationsDetails WHERE DepID = @DepID);
END;
GO
/****** Object:  StoredProcedure [AT].[stpProInventoryEnd]    Script Date: 09/07/2026 11:18:04 AM ******/
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

	UPDATE	AT.Assets SET StatusID = 0
	FROM	AT.Assets Ast Inner Join AT.InventoriesDetails InvD On Ast.AssetID = InvD.AssetID
	WHERE	InvD.IsAvailable = 1 AND InvD.Relocated = 0 AND InvD.InventoryID = @InventoryID

	UPDATE	AT.Assets SET StatusID = 0, LocationID = InvD.RelocatedLocationID, LocDetailID = InvD.RelocatedLocDetailID
	FROM	AT.Assets Ast Inner Join AT.InventoriesDetails InvD On Ast.AssetID = InvD.AssetID
	WHERE	InvD.IsAvailable = 1 AND InvD.Relocated = 1  AND InvD.InventoryID = @InventoryID

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
/****** Object:  StoredProcedure [AT].[stpProInventoryStart]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpProInventoryStart]
(
    @InventoryStartDate date,
    @StartCreatedByUserID smallint,
    @StartCreatedByFullName nvarchar(100),
    @StartCreatedByDateTime datetime,
    @Remark nvarchar(100),
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InventoryID int;

    INSERT INTO AT.Inventories
    (
        InventoryStartDate,
        Remark,
        CompanyID,
        StartCreatedByUserID,
        StartCreatedByFullName,
        StartCreatedByDateTime
    )
    VALUES
    (
        @InventoryStartDate,
        @Remark,
        @CompanyID,
        @StartCreatedByUserID,
        @StartCreatedByFullName,
        @StartCreatedByDateTime
    );

    SET @InventoryID = SCOPE_IDENTITY();

    INSERT INTO AT.InventoriesDetails
    (
        InventoryID,
        AssetID,
        IsAvailable,
        AssetCode,
        AssetDesc,
        Relocated,
        RelocatedLocationID,
        RelocatedLocDetailID,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        Remark
    )
    SELECT
        @InventoryID,
        AssetID,
        0,
        AssetCode,
        AssetDesc,
        0,
        NULL,
        NULL,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        NULL
    FROM AT.Assets
    WHERE (StatusID = 0 OR StatusID = 12)
      AND CompanyID = @CompanyID;

    UPDATE Ast
    SET Ast.StatusID = 10
    FROM AT.Assets Ast
    INNER JOIN AT.InventoriesDetails InvD ON InvD.AssetID = Ast.AssetID
    WHERE InvD.InventoryID = @InventoryID
      AND (Ast.StatusID = 0 OR Ast.StatusID = 12);

    SELECT @@ROWCOUNT;
END;
GO
/****** Object:  StoredProcedure [AT].[stpProInventoryStartRefresh]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpProInventoryStartRefresh]
(
    @InventoryID int
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AT.InventoriesDetails
    (
        InventoryID,
        AssetID,
        IsAvailable,
        AssetCode,
        AssetDesc,
        Relocated,
        RelocatedLocationID,
        RelocatedLocDetailID,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        Remark
    )
    SELECT
        @InventoryID,
        AssetID,
        0,
        AssetCode,
        AssetDesc,
        0,
        NULL,
        NULL,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        NULL
    FROM AT.Assets
    WHERE (StatusID = 0 OR StatusID = 12)
      AND CompanyID = (SELECT CompanyID FROM AT.Inventories WHERE InventoryID = @InventoryID)
      AND AssetID NOT IN (SELECT AssetID FROM AT.InventoriesDetails WHERE InventoryID = @InventoryID);

    UPDATE Ast
    SET Ast.StatusID = 10
    FROM AT.Assets Ast
    INNER JOIN AT.InventoriesDetails InvD ON InvD.AssetID = Ast.AssetID
    WHERE InvD.InventoryID = @InventoryID
      AND (Ast.StatusID = 0 OR Ast.StatusID = 12);
END;
GO
/****** Object:  StoredProcedure [AT].[stpStatusHistoryS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
    SELECT  SH.StatusHistID, SH.AssetID, SH.StatusID, ST.[Status] AS StatusName,
            SH.StatusDate, SH.StatusDesc, C.ContactName,
            SH.StatusSalePrice, SH.StatusSaleCurCode,
            SH.CreatedByUserID, SH.CreatedByFullName, SH.CreatedByDateTime
    FROM    AT.StatusHistory SH
            LEFT OUTER JOIN GTBL.Contacts C ON SH.StatusContactID = C.ContactID
            LEFT OUTER JOIN ATSET.StatusTypes ST ON SH.StatusID = ST.StatusID
    WHERE   SH.AssetID = @AssetID;
GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 4) Procedures - Warranty */
CREATE PROCEDURE [AT].[stpWarrantiesD]
(
    @Original_WarntID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_WarrantyDesc nvarchar(50),
    @Original_FromDate date,
    @Original_ToDate date,
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    DELETE FROM [AT].[Warranties]
    WHERE ([WarntID] = @Original_WarntID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([WarrantyDesc] = @Original_WarrantyDesc)
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));
END
GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpWarrantiesI]
(
    @AssetID int,
    @AttID int,
    @WarrantyDesc nvarchar(50),
    @FromDate date,
    @ToDate date,
    @Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [AT].[Warranties]
    (
        [AssetID], [AttID], [WarrantyDesc], [FromDate], [ToDate], [Remark]
    )
    VALUES
    (
        @AssetID, @AttID, @WarrantyDesc, @FromDate, @ToDate, @Remark
    );

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE WarntID = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpWarrantiesS]
(
    @AssetId int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE AssetID = @AssetID;
END
GO
/****** Object:  StoredProcedure [AT].[stpWarrantiesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [AT].[stpWarrantiesU]
(
    @AssetID int,
    @AttID int,
    @WarrantyDesc nvarchar(50),
    @FromDate date,
    @ToDate date,
    @Remark nvarchar(100),
    @Original_WarntID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_WarrantyDesc nvarchar(50),
    @Original_FromDate date,
    @Original_ToDate date,
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100),
    @WarntID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Warranties]
    SET [AssetID] = @AssetID,
        [AttID] = @AttID,
        [WarrantyDesc] = @WarrantyDesc,
        [FromDate] = @FromDate,
        [ToDate] = @ToDate,
        [Remark] = @Remark
    WHERE ([WarntID] = @Original_WarntID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([WarrantyDesc] = @Original_WarrantyDesc)
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE WarntID = @WarntID;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpBrandTypesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [ATSET].[stpBrandTypesI]
(
    @BrandDesc nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO ATSET.BrandTypes (BrandDesc)
    VALUES (LTRIM(RTRIM(@BrandDesc)));

    SELECT BrandID, BrandDesc
    FROM ATSET.BrandTypes
    WHERE BrandID = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpCategoryTypesD]
(
    @Original_CategoryID smallint,
    @Original_Category nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    DELETE FROM [ATSET].[CategoryTypes]
    WHERE [CategoryID] = @Original_CategoryID
      AND [Category] = @Original_Category;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesI]
(
    @Category nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [ATSET].[CategoryTypes] ([Category])
    VALUES (@Category);

    SELECT CategoryID, Category
    FROM ATSET.CategoryTypes
    WHERE CategoryID = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoryID, Category
    FROM ATSET.CategoryTypes
    ORDER BY Category;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpCategoryTypesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpCategoryTypesU]
(
    @Category nvarchar(50),
    @Original_CategoryID smallint,
    @Original_Category nvarchar(50),
    @CategoryID smallint
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [ATSET].[CategoryTypes]
    SET [Category] = @Category
    WHERE [CategoryID] = @Original_CategoryID
      AND [Category] = @Original_Category;

    SELECT CategoryID, Category
    FROM ATSET.CategoryTypes
    WHERE CategoryID = @CategoryID;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpGetAssetCode]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGetAssetCode]
(
    @CountryID  char(2),
    @Generate   bit,
    @AssetCode  nvarchar(20) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AssetCodeAcronym nvarchar(5)  = (SELECT TOP 1 SetValue FROM ATSET.Settings WHERE SetID = 1)
    DECLARE @AssetCodeLength  tinyint      = ISNULL((SELECT TOP 1 SetValue FROM ATSET.Settings WHERE SetID = 2), 0)
    DECLARE @AssetCodeCounter int          = (SELECT AssetCodeCounter FROM GSET.Countries WHERE CountryID = @CountryID)

    IF @AssetCodeLength > 10  SET @AssetCodeLength  = 10
    IF LEN(@AssetCodeAcronym) > 5  SET @AssetCodeAcronym = SUBSTRING(@AssetCodeAcronym, 1, 5)

    SET @AssetCode =
        RTRIM(@CountryID) + '-' +
        @AssetCodeAcronym + '-' +
        REPLICATE('0', @AssetCodeLength - LEN(CAST(@AssetCodeCounter AS varchar(15)))) +
        CAST(@AssetCodeCounter + 1 AS varchar(15))

    IF @Generate = 1
        UPDATE GSET.Countries
        SET    AssetCodeCounter = AssetCodeCounter + 1
        WHERE  CountryID = @CountryID
END
GO
/****** Object:  StoredProcedure [ATSET].[stpGetBrandTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
  Add support for asset BrandID, Model, OwnerID, and OwnerDesc/OwnerInfo
  across asset procedures and expose brand/owner lookup procedures.
  Safe to run multiple times.
*/

CREATE   PROCEDURE [ATSET].[stpGetBrandTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT BrandID, BrandDesc
    FROM ATSET.BrandTypes
    ORDER BY BrandDesc;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpGetCategoryTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpGetGroupTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpGetGroupTypes]
AS
    SET NOCOUNT ON;
    SELECT GroupID, GroupName, Acronym, DepreciationRate, CountryID
    FROM   ATSET.GroupTypes
    ORDER BY GroupName
GO
/****** Object:  StoredProcedure [ATSET].[stpGetLocationDetails]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpGetLocationTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpGetLocationTypes]
    @CompanyID smallint = -1
AS
    SET NOCOUNT ON;
    SELECT LocationID, Location, CompanyID
    FROM   ATSET.LocationTypes
    WHERE  CompanyID = CASE @CompanyID WHEN -1 THEN CompanyID ELSE @CompanyID END
    ORDER BY Location
GO
/****** Object:  StoredProcedure [ATSET].[stpGetOwnerTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [ATSET].[stpGetOwnerTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OwnerID, OwnerDesc
    FROM ATSET.OwnerTypes
    ORDER BY OwnerDesc;
END
GO
/****** Object:  StoredProcedure [ATSET].[stpGetSettings]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpGetStatusTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ATSET].[stpGroupTypesI]
(
    @GroupName            nvarchar(50),
    @Acronym              nvarchar(5),
    @DepreciationRate     tinyint,
    @AccountNo            nvarchar(20),
    @AccountingExclusion  bit,
    @CountryID            char(2)
)
AS
    SET NOCOUNT OFF;
    INSERT INTO [ATSET].[GroupTypes]
        ([GroupName],[Acronym],[DepreciationRate],[AccountNo],[AccountingExclusion],[CountryID])
    VALUES
        (@GroupName, @Acronym, @DepreciationRate, @AccountNo, @AccountingExclusion, @CountryID);

    SELECT GroupID, GroupName, Acronym, DepreciationRate,
           AccountNo, AccountingExclusion, CountryID
    FROM   ATSET.GroupTypes
    WHERE  GroupID = SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpGroupTypesS]
AS
    SET NOCOUNT ON;
    SELECT GroupID, GroupName, Acronym, DepreciationRate,
           AccountNo, AccountingExclusion, CountryID
    FROM   ATSET.GroupTypes
GO
/****** Object:  StoredProcedure [ATSET].[stpGroupTypesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpGroupTypesU]
(
    @GroupName                    nvarchar(50),
    @Acronym                      nvarchar(5),
    @DepreciationRate             tinyint,
    @AccountNo                    nvarchar(20),
    @AccountingExclusion          bit,
    @CountryID                    char(2),
    @Original_GroupID             smallint,
    @Original_GroupName           nvarchar(50),
    @Original_Acronym             nvarchar(5),
    @Original_DepreciationRate    tinyint,
    @IsNull_AccountNo             int,
    @Original_AccountNo           nvarchar(20),
    @Original_AccountingExclusion bit,
    @GroupID                      smallint
)
AS
    SET NOCOUNT OFF;
    UPDATE [ATSET].[GroupTypes]
    SET    [GroupName]           = @GroupName,
           [Acronym]             = @Acronym,
           [DepreciationRate]    = @DepreciationRate,
           [AccountNo]           = @AccountNo,
           [AccountingExclusion] = @AccountingExclusion,
           [CountryID]           = @CountryID
    WHERE  [GroupID]             = @Original_GroupID
      AND  [GroupName]           = @Original_GroupName
      AND  [Acronym]             = @Original_Acronym
      AND  [DepreciationRate]    = @Original_DepreciationRate
      AND  ((@IsNull_AccountNo = 1 AND [AccountNo] IS NULL) OR [AccountNo] = @Original_AccountNo)
      AND  [AccountingExclusion] = @Original_AccountingExclusion;

    SELECT GroupID, GroupName, Acronym, DepreciationRate,
           AccountNo, AccountingExclusion, CountryID
    FROM   ATSET.GroupTypes WHERE GroupID = @GroupID
GO
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailI]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpLocationDetailU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpLocationTypesI]
(
    @Location  nvarchar(50),
    @CompanyID smallint
)
AS
    SET NOCOUNT OFF;
    INSERT INTO [ATSET].[LocationTypes] ([Location], [CompanyID])
    VALUES (@Location, @CompanyID);
    SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [ATSET].[stpLocationTypesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ATSET].[stpLocationTypesU]
(
    @Location   nvarchar(50),
    @CompanyID  smallint,
    @LocationID smallint
)
AS
    SET NOCOUNT OFF;
    UPDATE [ATSET].[LocationTypes]
    SET    [Location]  = @Location,
           [CompanyID] = @CompanyID
    WHERE  [LocationID] = @LocationID
GO
/****** Object:  StoredProcedure [ATSET].[stpSettingsU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpBanksD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpBanksI]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpBanksList]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpBanksS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpBanksU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpCompaniesD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GSET].[stpCompaniesD]
(
    @CompanyID smallint
)
AS
    SET NOCOUNT OFF;
    DELETE FROM GSET.Companies WHERE CompanyID = @CompanyID
GO
/****** Object:  StoredProcedure [GSET].[stpCompaniesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [GSET].[stpCompaniesI]
(
    @CompanyName         nvarchar(100),
    @CompanyAbbreviation nvarchar(10),
    @CompanyPrmCurCode   char(3),
    @CompanyScdCurCode   char(3),
    @CountryID           char(2)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO GSET.Companies
        (CompanyName, CompanyAbbreviation, CompanyPrmCurCode, CompanyScdCurCode, CountryID)
    VALUES
        (@CompanyName, @CompanyAbbreviation, @CompanyPrmCurCode, @CompanyScdCurCode, @CountryID);

    SELECT CompanyID, CompanyName, CompanyAbbreviation,
           CompanyPrmCurCode, CompanyScdCurCode, CountryID
    FROM   GSET.Companies
    WHERE  CompanyID = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [GSET].[stpCompaniesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [GSET].[stpCompaniesU]
(
    @CompanyID           smallint,
    @CompanyName         nvarchar(100),
    @CompanyAbbreviation nvarchar(10),
    @CompanyPrmCurCode   char(3),
    @CompanyScdCurCode   char(3),
    @CountryID           char(2)
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE GSET.Companies
    SET    CompanyName         = @CompanyName,
           CompanyAbbreviation = @CompanyAbbreviation,
           CompanyPrmCurCode   = @CompanyPrmCurCode,
           CompanyScdCurCode   = @CompanyScdCurCode,
           CountryID           = @CountryID
    WHERE  CompanyID = @CompanyID;
END
GO
/****** Object:  StoredProcedure [GSET].[stpCountriesI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpCountriesI]
(
    @CountryID      char(2),
    @Country        nvarchar(50),
    @Nationality    nvarchar(50),
    @ZipCode        varchar(5)  = NULL,
    @WorkingCountry bit         = 0,
    @ActiveCountry  bit         = 1
)
AS
    SET NOCOUNT OFF;
    INSERT INTO GSET.Countries
        (CountryID, Country, Nationality, ZipCode, Flag, WorkingCountry, ActiveCountry)
    VALUES
        (@CountryID, @Country, @Nationality, @ZipCode, 0x, @WorkingCountry, @ActiveCountry);
    SELECT CountryID, Country, Nationality, ZipCode, WorkingCountry, ActiveCountry
    FROM   GSET.Countries WHERE CountryID = @CountryID
GO
/****** Object:  StoredProcedure [GSET].[stpCountriesU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpCountriesU]
(
    @CountryID      char(2),
    @Country        nvarchar(50),
    @Nationality    nvarchar(50),
    @ZipCode        varchar(5)  = NULL,
    @WorkingCountry bit,
    @ActiveCountry  bit
)
AS
    SET NOCOUNT OFF;
    UPDATE GSET.Countries
    SET    Country        = @Country,
           Nationality    = @Nationality,
           ZipCode        = @ZipCode,
           WorkingCountry = @WorkingCountry,
           ActiveCountry  = @ActiveCountry
    WHERE  CountryID = @CountryID
GO
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail1]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail2]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetAddressDetail3]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetBanks]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetCities]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetCompanies]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [GSET].[stpGetCompanies]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CompanyID, CompanyName, CompanyAbbreviation,
           CompanyPrmCurCode, CompanyScdCurCode, CountryID
    FROM   GSET.Companies
    ORDER BY CompanyName;
END
GO
/****** Object:  StoredProcedure [GSET].[stpGetContactTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetCountries]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GSET].[stpGetCountries]
AS
    SET NOCOUNT ON;
    SELECT CountryID, Country, Nationality, ZipCode, Flag,
           WorkingCountry, ActiveCountry
    FROM   GSET.Countries
    ORDER BY Country
GO
/****** Object:  StoredProcedure [GSET].[stpGetCurrencies]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetLogSeverity]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetLogSystem]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetLogTypes]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetSettings]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpGetWorkingCountry]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GSET].[stpSettingsU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpContactsD]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpContactsI]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpContactsList]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpContactsS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpContactsU]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpGetContacts]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpLogI]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [GTBL].[stpLogS]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [NOTIF].[stpCreateNotification]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NOTIF].[stpCreateNotification]
(
    @UserID    smallint,
    @CompanyID smallint,
    @Type      nvarchar(20),
    @EntityID  int,
    @AssetID   int,
    @Message   nvarchar(500)
)
AS
    SET NOCOUNT OFF;
    INSERT INTO NOTIF.Notifications(UserID, CompanyID, Type, EntityID, AssetID, Message)
    VALUES (@UserID, @CompanyID, @Type, @EntityID, @AssetID, @Message);
    SELECT SCOPE_IDENTITY() AS NotifID;
GO
/****** Object:  StoredProcedure [NOTIF].[stpGetNotifications]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NOTIF].[stpGetNotifications]
(
    @UserID smallint
)
AS
    SET NOCOUNT ON;
    SELECT TOP 50
        NotifID, UserID, CompanyID, Type, EntityID, AssetID, Message, IsRead, CreatedAt
    FROM  NOTIF.Notifications
    WHERE UserID = @UserID
    ORDER BY CreatedAt DESC;
GO
/****** Object:  StoredProcedure [NOTIF].[stpGetPendingMaintenanceNotifications]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [NOTIF].[stpGetPendingMaintenanceNotifications]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.MaintID,
        m.AssetID,
        m.FromDate,
        m.ToDate,
        a.CompanyID,
        a.AssetCode,
        a.AssetDesc,
        a.StatusID,
        up.UserID AS RecipientUserID,
        u.EmailAddress AS RecipientEmailAddress,
        DATEDIFF(day, CAST(GETDATE() AS date), m.ToDate) AS DaysLeft
    FROM  AT.Maintenances m
    INNER JOIN AT.Assets a ON a.AssetID = m.AssetID
    INNER JOIN SEC.UsersPermissions up ON up.CompanyID = a.CompanyID
    INNER JOIN SEC.Users u ON u.UserID = up.UserID
    WHERE a.StatusID = 8;
END
GO
/****** Object:  StoredProcedure [NOTIF].[stpGetPendingWarrantyNotifications]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [NOTIF].[stpGetPendingWarrantyNotifications]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        w.WarntID,
        w.AssetID,
        w.WarrantyDesc,
        w.ToDate,
        a.CompanyID,
        a.AssetCode,
        a.AssetDesc,
        up.UserID AS RecipientUserID,
        u.EmailAddress AS RecipientEmailAddress,
        DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) AS DaysLeft
    FROM  AT.Warranties w
    INNER JOIN AT.Assets a ON a.AssetID = w.AssetID
    INNER JOIN SEC.UsersPermissions up ON up.CompanyID = a.CompanyID
    INNER JOIN SEC.Users u ON u.UserID = up.UserID
    WHERE w.ToDate >= CAST(GETDATE() AS date)
      AND DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) <= 14;
END
GO
/****** Object:  StoredProcedure [NOTIF].[stpLogNotification]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NOTIF].[stpLogNotification]
(
    @Type          nvarchar(20),
    @EntityID      int,
    @IntervalLabel nvarchar(30)
)
AS
    IF NOT EXISTS (
        SELECT 1 FROM NOTIF.NotificationLogs
        WHERE Type = @Type AND EntityID = @EntityID AND IntervalLabel = @IntervalLabel
    )
        INSERT INTO NOTIF.NotificationLogs(Type, EntityID, IntervalLabel)
        VALUES (@Type, @EntityID, @IntervalLabel);
GO
/****** Object:  StoredProcedure [NOTIF].[stpMarkAllNotificationsRead]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NOTIF].[stpMarkAllNotificationsRead]
(
    @UserID smallint
)
AS
    UPDATE NOTIF.Notifications
    SET    IsRead = 1
    WHERE  UserID = @UserID AND IsRead = 0;
GO
/****** Object:  StoredProcedure [NOTIF].[stpMarkNotificationRead]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NOTIF].[stpMarkNotificationRead]
(
    @NotifID int,
    @UserID  smallint
)
AS
    UPDATE NOTIF.Notifications
    SET    IsRead = 1
    WHERE  NotifID = @NotifID AND UserID = @UserID;
GO
/****** Object:  StoredProcedure [SEC].[stpGetLoginUser]    Script Date: 09/07/2026 11:18:04 AM ******/
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
    SELECT [UserID], [UserName], [FullName], [RoleID]
    FROM   [SEC].[Users]
    WHERE  [UserName]     = @UserName
      AND  [UserPassword] = HASHBYTES('SHA2_256', @Password)
      AND  [UserPassword] IS NOT NULL
END
GO
/****** Object:  StoredProcedure [SEC].[stpGetRoles]    Script Date: 09/07/2026 11:18:04 AM ******/
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
/****** Object:  StoredProcedure [SEC].[stpGetUserPermissions]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SEC].[stpGetUserPermissions]
(
    @UserID SMALLINT
)
AS
    SET NOCOUNT ON;
    SELECT up.UserID, up.CountryID, c.Country,
           up.CompanyID, co.CompanyName
    FROM   SEC.UsersPermissions up
    JOIN   GSET.Countries c  ON up.CountryID = c.CountryID
    JOIN   GSET.Companies co ON up.CompanyID = co.CompanyID
    WHERE  up.UserID = @UserID
    ORDER BY co.CompanyName
GO
/****** Object:  StoredProcedure [SEC].[stpUserPermissionsD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SEC].[stpUserPermissionsD]
(
    @UserID    SMALLINT,
    @CountryID CHAR(2),
    @CompanyID SMALLINT
)
AS
    SET NOCOUNT OFF;
    DELETE FROM SEC.UsersPermissions
    WHERE  UserID = @UserID AND CountryID = @CountryID AND CompanyID = @CompanyID
GO
/****** Object:  StoredProcedure [SEC].[stpUserPermissionsI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SEC].[stpUserPermissionsI]
(
    @UserID    SMALLINT,
    @CountryID CHAR(2),
    @CompanyID SMALLINT
)
AS
    SET NOCOUNT OFF;
    IF NOT EXISTS (
        SELECT 1 FROM SEC.UsersPermissions
        WHERE UserID = @UserID AND CountryID = @CountryID AND CompanyID = @CompanyID
    )
        INSERT INTO SEC.UsersPermissions (UserID, CountryID, CompanyID)
        VALUES (@UserID, @CountryID, @CompanyID)
GO
/****** Object:  StoredProcedure [SEC].[stpUsersD]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SEC].[stpUsersD]
(
    @UserID SMALLINT
)
AS
    SET NOCOUNT OFF;
    DELETE FROM SEC.UsersPermissions WHERE UserID = @UserID;
    DELETE FROM SEC.Users             WHERE UserID = @UserID
GO
/****** Object:  StoredProcedure [SEC].[stpUsersI]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [SEC].[stpUsersI]
(
    @UserName      NVARCHAR(100),
    @Password      NVARCHAR(256),
    @FullName      NVARCHAR(100),
    @EmailAddress  NVARCHAR(255),
    @RoleID        TINYINT
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO SEC.Users (UserName, UserPassword, FullName, EmailAddress, RoleID)
    VALUES (@UserName, HASHBYTES('SHA2_256', @Password), @FullName, @EmailAddress, @RoleID);

    SELECT SCOPE_IDENTITY() AS UserID;
END
GO
/****** Object:  StoredProcedure [SEC].[stpUsersS]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [SEC].[stpUsersS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT u.UserID, u.UserName, u.FullName, u.EmailAddress, u.RoleID, r.RoleName
    FROM   SEC.Users u
    JOIN   SEC.Roles r ON u.RoleID = r.RoleID
    ORDER BY u.FullName;
END
GO
/****** Object:  StoredProcedure [SEC].[stpUsersU]    Script Date: 09/07/2026 11:18:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [SEC].[stpUsersU]
(
    @UserID        SMALLINT,
    @UserName      NVARCHAR(100),
    @Password      NVARCHAR(256) = NULL,
    @FullName      NVARCHAR(100),
    @EmailAddress  NVARCHAR(255),
    @RoleID        TINYINT
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE SEC.Users
    SET    UserName     = @UserName,
           FullName     = @FullName,
           EmailAddress = @EmailAddress,
           RoleID       = @RoleID,
           UserPassword = CASE
                              WHEN @Password IS NOT NULL AND @Password <> ''
                              THEN HASHBYTES('SHA2_256', @Password)
                              ELSE UserPassword
                          END
    WHERE  UserID = @UserID;
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'GTBL', @level1type=N'TABLE',@level1name=N'Logs', @level2type=N'COLUMN',@level2name=N'LogSystemID'
GO
USE [master]
GO
ALTER DATABASE [Assets] SET  READ_WRITE 
GO
