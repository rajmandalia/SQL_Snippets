USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Fuel]    Script Date: 10/25/2010 13:13:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMK3_Fuel]') AND type in (N'U'))
DROP TABLE [dbo].[EMK3_Fuel]
GO

USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Fuel]    Script Date: 10/25/2010 13:13:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMK3_Fuel](
	[Plant] [nvarchar](max) NULL,
	[Meter] [nvarchar](max) NULL,
	[Production_Date] [nvarchar](max) NULL,
	[Party_Id] [nvarchar](max) NULL,
	[Product_Code] [nvarchar](max) NULL,
	[Dispostion_Code] [nvarchar](max) NULL,
	[Volume_In_MMBTUS] [nvarchar](max) NULL,
	[SourceId] [nvarchar](max) NULL
) ON [PRIMARY]

GO


USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Gas]    Script Date: 10/25/2010 13:13:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMK3_Gas]') AND type in (N'U'))
DROP TABLE [dbo].[EMK3_Gas]
GO

USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Gas]    Script Date: 10/25/2010 13:13:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMK3_Gas](
	[PLANT] [nvarchar](max) NULL,
	[METER] [nvarchar](max) NULL,
	[PRODUCTION_DATE] [nvarchar](max) NULL,
	[PARTY_ID] [nvarchar](max) NULL,
	[ASSOCIATED_METER] [nvarchar](max) NULL,
	[ETHANE_GPM] [nvarchar](max) NULL,
	[PROPANE_GPM] [nvarchar](max) NULL,
	[ISOBUTANE_GPM] [nvarchar](max) NULL,
	[NORMAL_BUTANE_GPM] [nvarchar](max) NULL,
	[ISOPENTANE_GPM] [nvarchar](max) NULL,
	[NORMAL_PENTANE_GPM] [nvarchar](max) NULL,
	[HEXANE_GPM] [nvarchar](max) NULL,
	[WATER_BTU] [nvarchar](max) NULL,
	[BTU_DRY] [nvarchar](max) NULL,
	[SourceId] [nvarchar](max) NULL
) ON [PRIMARY]

GO


USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Liquid]    Script Date: 10/25/2010 13:13:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMK3_Liquid]') AND type in (N'U'))
DROP TABLE [dbo].[EMK3_Liquid]
GO

USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Liquid]    Script Date: 10/25/2010 13:13:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMK3_Liquid](
	[Plant] [nvarchar](max) NULL,
	[Meter] [nvarchar](max) NULL,
	[Production_Date] [nvarchar](max) NULL,
	[Party_Id] [nvarchar](max) NULL,
	[Product_Code] [nvarchar](max) NULL,
	[Dispostion_Code] [nvarchar](max) NULL,
	[GALLONS] [nvarchar](max) NULL,
	[GALLONS_TO_PRODUCER] [nvarchar](max) NULL,
	[TAKE_IN_KIND_GALLONS] [nvarchar](max) NULL,
	[THEORETICAL_GALLONS] [nvarchar](max) NULL,
	[STATEMENT_PRICE] [nvarchar](max) NULL,
	[PERCENT_OF_PROCEEDS_PCT] [nvarchar](max) NULL,
	[LBS] [nvarchar](max) NULL,
	[LBS_TO_PRODUCER] [nvarchar](max) NULL,
	[THEORETICAL_LBS] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NULL,
	[VALUE_TO_PRODUCER] [nvarchar](max) NULL,
	[UOM_PCT] [nvarchar](max) NULL,
	[SourceId] [nvarchar](max) NULL
) ON [PRIMARY]

GO


USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_PDF]    Script Date: 10/25/2010 13:14:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMK3_PDF]') AND type in (N'U'))
DROP TABLE [dbo].[EMK3_PDF]
GO

USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_PDF]    Script Date: 10/25/2010 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EMK3_PDF](
	[Merrickid] [varchar](max) NULL,
	[Recorddate] [varchar](max) NULL,
	[Actbtufactor] [varchar](max) NULL,
	[actgasvolmcf] [varchar](max) NULL,
	[Actgasvolmmbtu] [varchar](max) NULL,
	[Actpressurebase] [varchar](max) NULL,
	[Actwetdryflag] [varchar](max) NULL,
	[BackgroundTaskflag] [varchar](max) NULL,
	[Productcode] [varchar](max) NULL,
	[SourceId] [varchar](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Residue]    Script Date: 10/25/2010 13:14:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMK3_Residue]') AND type in (N'U'))
DROP TABLE [dbo].[EMK3_Residue]
GO

USE [EMK3_Interfaces]
GO

/****** Object:  Table [dbo].[EMK3_Residue]    Script Date: 10/25/2010 13:14:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMK3_Residue](
	[Plant] [nvarchar](max) NULL,
	[Meter] [nvarchar](max) NULL,
	[Production_Date] [nvarchar](max) NULL,
	[Party_Id] [nvarchar](max) NULL,
	[CONTRACT_NUMBER] [nvarchar](max) NULL,
	[WELLHEAD_GROSS_MCF] [nvarchar](max) NULL,
	[WELLHEAD_GROSS_MMBTU] [nvarchar](max) NULL,
	[CONTRACT_PCT] [nvarchar](max) NULL,
	[RESIDUE_PRODUCED_MMBTU] [nvarchar](max) NULL,
	[RESIDUE_POP_PCT] [nvarchar](max) NULL,
	[RESIDUE_TIK_MMBTU] [nvarchar](max) NULL,
	[RESIDUE_MMBTU_TO_PRODUCER] [nvarchar](max) NULL,
	[RESIDUE_PRICE] [nvarchar](max) NULL,
	[TOTAL_LIQUIDS_VALUE] [nvarchar](max) NULL,
	[LIQUIDS_TOTAL_VALUE_TO_PRODUCER] [nvarchar](max) NULL,
	[TOTAL_FEES] [nvarchar](max) NULL,
	[TOTAL_TAX] [nvarchar](max) NULL,
	[RESIDUE_VALUE] [nvarchar](max) NULL,
	[RESIDUE_VALUE_TO_PRODUCER] [nvarchar](max) NULL,
	[RESIDUE_MMBTU] [nvarchar](max) NULL,
	[RESIDUE_MCF] [nvarchar](max) NULL,
	[RESIDUE_LRU_MMBTU] [nvarchar](max) NULL,
	[RESIDUE_LRU_MCF] [nvarchar](max) NULL,
	[RESIDUE_SOLD_MCF] [nvarchar](max) NULL,
	[RESIDUE_SOLD_MMBTU] [nvarchar](max) NULL,
	[SourceId] [nvarchar](max) NULL
) ON [PRIMARY]

GO


