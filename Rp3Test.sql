USE [master]
GO
/****** Object:  Database [Rp3Test]    Script Date: 17-08-2019 03:00:53 p.m. ******/
CREATE DATABASE [Rp3Test]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Rp3Test', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Rp3Test.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Rp3Test_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Rp3Test_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Rp3Test] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Rp3Test].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Rp3Test] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Rp3Test] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Rp3Test] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Rp3Test] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Rp3Test] SET ARITHABORT OFF 
GO
ALTER DATABASE [Rp3Test] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Rp3Test] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Rp3Test] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Rp3Test] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Rp3Test] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Rp3Test] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Rp3Test] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Rp3Test] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Rp3Test] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Rp3Test] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Rp3Test] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Rp3Test] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Rp3Test] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Rp3Test] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Rp3Test] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Rp3Test] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Rp3Test] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Rp3Test] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Rp3Test] SET RECOVERY FULL 
GO
ALTER DATABASE [Rp3Test] SET  MULTI_USER 
GO
ALTER DATABASE [Rp3Test] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Rp3Test] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Rp3Test] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Rp3Test] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Rp3Test', N'ON'
GO
USE [Rp3Test]
GO
/****** Object:  StoredProcedure [dbo].[FillRandomData]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FillRandomData]
AS

TRUNCATE TABLE dbo.tbTransaction;

DECLARE @FechaInicial DATETIME;
DECLARE @FechaFinal DATETIME;

DECLARE @FechaProceso DATETIME;
DECLARE @CategoryId INT;
DECLARE @TypeId INT;
DECLARE @Description VARCHAR(500);

SET @FechaInicial = DATEADD(DAY, -30, GETDATE());
SET @FechaFinal = GETDATE() - 1;

SET @FechaProceso = @FechaInicial;

DECLARE @Amount MONEY;

DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT;

DECLARE @Id INT;
SET @Id = 1;

DECLARE @Contador INT;
DECLARE @Limite INT;

SET @Contador = 0;
SET @Limite = 30;

WHILE (@Contador < @Limite)
BEGIN

    ---- This will create a random number between 1 and 999
    SET @Lower = 1; ---- The lowest random number
    SET @Upper = 10; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower), 0);

    SET @CategoryId = @Random;

    SELECT @Description = Name + ' del ' + CONVERT(VARCHAR, GETDATE(), 103)
    FROM dbo.tbCategory
    WHERE CategoryId = @CategoryId;

    SET @Lower = 100; ---- The lowest random number
    SET @Upper = 200; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower) / 100, 0);

    SET @TypeId = @Random;


    SET @Lower = 2; ---- The lowest random number
    SET @Upper = 100; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower), 0);

    SET @Amount = @Random;

    DECLARE @Seconds INT = DATEDIFF(SECOND, @FechaInicial, @FechaFinal);
    SET @Random = ROUND(((@Seconds - 1) * RAND()), 0);

    SELECT @FechaProceso = DATEADD(SECOND, @Random, @FechaInicial);


	IF @CategoryId = 6
	BEGIN
		SET @TypeId = 1
		SET @Amount = @Amount * 5
	END
	ELSE
		SET @TypeId = 2


    INSERT INTO dbo.tbTransaction
    (
        TransactionId,
        TransactionTypeId,
        CategoryId,
        RegisterDate,
        ShortDescription,
        Amount,
        Notes
    )
    VALUES
    (   @Id,           -- TransactionId - int
        @TypeId,       -- TransactionTypeId - smallint
        @CategoryId,   -- CategoryId - int
        @FechaProceso, -- RegisterDate - datetime
        @Description,  -- ShortDescription - varchar(100)
        @Amount,       -- Amount - numeric(18, 6)
        NULL);

    SET @Id = @Id + 1;
    SET @Contador = @Contador + 1;

END;

GO
/****** Object:  StoredProcedure [dbo].[spGetBalance]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetBalance]
@AccountId int,
@DateFrom DateTime,
@DateTo DateTime
AS
	BEGIN

	SELECT TransactionTypeId, t.CategoryId, c.Name AS CategoryName, AccountId, SUM (Amount) AS Amount
	FROM tbTransaction t
	INNER JOIN tbCategory c ON t.CategoryId = c.CategoryId
	WHERE AccountId = @AccountId AND RegisterDate >= @DateFrom AND RegisterDate <= @DateTo
	GROUP BY TransactionTypeId, t.CategoryId, c.Name, AccountId
	ORDER BY TransactionTypeId, Amount DESC;

	END

RETURN

GO
/****** Object:  StoredProcedure [dbo].[spTransactionInsert]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTransactionInsert]
@infoXml XML
AS
BEGIN

	/*
	Complete the code for Insert to dbo.tbTransaction Table

	Code XML SELECT EXAMPLE:

	SELECT 
	TransactionId = T.info.value('@ TransactionId','int'),
	TransactionTypeId = T.info.value('@ TransactionTypeId','smallint'),
	CategoryId = T.info.value('@ CategoryId','int'),
	RegisterDate = T.info.value('@ RegisterDate','datetime'),
	ShortDescription = T.info.value('@ ShortDescription','varchar(100)'),
	Notes = T.info.value('@ Notes','varchar(max)')
    FROM    @infoXml.nodes('Transaction')
                        AS T ( info ); 
	*/

	RETURN 0;

END

GO
/****** Object:  StoredProcedure [dbo].[spTransactionUpdate]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTransactionUpdate]
@infoXml XML
AS
BEGIN
	
	/*
	Complete the code for Update to dbo.tbTransaction Table

	Code XML SELECT EXAMPLE:

	SELECT 
	TransactionId = T.info.value('@ TransactionId','int'),
	TransactionTypeId = T.info.value('@ TransactionTypeId','smallint'),
	CategoryId = T.info.value('@ CategoryId','int'),
	RegisterDate = T.info.value('@ RegisterDate','datetime'),
	ShortDescription = T.info.value('@ ShortDescription','varchar(100)'),
	Notes = T.info.value('@ Notes','varchar(max)')
    FROM    @infoXml.nodes('Transaction')
                        AS T ( info ); 
	*/
	RETURN 0;
END

GO
/****** Object:  Table [dbo].[tbAccount]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbAccount](
	[AccountId] [int] NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[FullName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tbAccount] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbCategory]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbCategory](
	[CategoryId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_tbCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbTransaction]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbTransaction](
	[TransactionId] [int] NOT NULL,
	[TransactionTypeId] [smallint] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[RegisterDate] [datetime] NOT NULL,
	[ShortDescription] [varchar](100) NOT NULL,
	[Amount] [numeric](18, 6) NOT NULL,
	[Notes] [varchar](max) NULL,
	[DateUpdate] [datetime] NULL,
 CONSTRAINT [PK_tbTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbTransactionType]    Script Date: 17-08-2019 03:00:53 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbTransactionType](
	[TransactionTypeId] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tbTransactionType] PRIMARY KEY CLUSTERED 
(
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tbAccount] ([AccountId], [Email], [FullName]) VALUES (1, N'account1@empresa.com', N'Account 1')
INSERT [dbo].[tbAccount] ([AccountId], [Email], [FullName]) VALUES (2, N'account2@empresa.com', N'Account 2')
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (1, N'Alimentación', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (2, N'Transporte', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (3, N'Educación', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (4, N'Salud', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (5, N'Vestuario', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (6, N'Remuneración', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (7, N'Vivienda', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (8, N'Servicios Básicos', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (9, N'Luz', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (10, N'Agua', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (11, N'Teléfono', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (12, N'Renta', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (13, N'Hipoteca', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (14, N'Alícuota', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (15, N'Mi categoria', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (16, N'Mi categoria 2', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (17, N'Nueva categoria', 1)
INSERT [dbo].[tbCategory] ([CategoryId], [Name], [Active]) VALUES (18, N'Mi categoria 3', 1)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (1, 2, 8, 1, CAST(0x0000AA8D00EB1F40 AS DateTime), N'Servicios Básicos del 15/08/2019', CAST(50.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (2, 2, 3, 2, CAST(0x0000AAA201888E60 AS DateTime), N'Educación del 15/08/2019', CAST(76.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (3, 2, 7, 1, CAST(0x0000AA9800D19688 AS DateTime), N'Vivienda del 15/08/2019', CAST(43.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (4, 2, 7, 2, CAST(0x0000AAA6014E5420 AS DateTime), N'Vivienda del 15/08/2019', CAST(15.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (5, 2, 7, 2, CAST(0x0000AAA80165BD18 AS DateTime), N'Vivienda del 15/08/2019', CAST(23.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (6, 2, 2, 1, CAST(0x0000AA930177D32C AS DateTime), N'Transporte del 15/08/2019', CAST(47.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (7, 2, 5, 2, CAST(0x0000AA98008AE2EC AS DateTime), N'Vestuario del 15/08/2019', CAST(64.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (8, 2, 8, 2, CAST(0x0000AA9700465744 AS DateTime), N'Servicios Básicos del 15/08/2019', CAST(42.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (9, 1, 6, 2, CAST(0x0000AA980072FB64 AS DateTime), N'Remuneración del 15/08/2019', CAST(320.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (10, 1, 6, 1, CAST(0x0000AA98009C354C AS DateTime), N'Remuneración del 15/08/2019', CAST(160.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (11, 2, 8, 1, CAST(0x0000AA630050094C AS DateTime), N'Servicios Básicos del 15/08/2019', CAST(58.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (12, 1, 6, 2, CAST(0x0000AA8F0023ADD4 AS DateTime), N'Remuneración del 15/08/2019', CAST(45.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (13, 2, 2, 1, CAST(0x0000AA9700BE85AC AS DateTime), N'Transporte del 15/08/2019', CAST(35.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (14, 2, 3, 2, CAST(0x0000AAA6011249D0 AS DateTime), N'Educación del 15/08/2019', CAST(49.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (15, 2, 8, 2, CAST(0x0000AA90004DB3A4 AS DateTime), N'Servicios Básicos del 15/08/2019', CAST(36.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (16, 1, 6, 1, CAST(0x0000AA9000D09134 AS DateTime), N'Remuneración del 15/08/2019', CAST(180.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (17, 1, 6, 1, CAST(0x0000AAA801717C20 AS DateTime), N'Remuneración del 15/08/2019', CAST(85.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (18, 1, 6, 1, CAST(0x0000AA8E014C4720 AS DateTime), N'Remuneración del 15/08/2019', CAST(225.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (19, 2, 4, 1, CAST(0x0000AA8E000B0BF8 AS DateTime), N'Salud del 15/08/2019', CAST(42.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (20, 2, 8, 1, CAST(0x0000AAA700D06830 AS DateTime), N'Servicios Básicos del 15/08/2019', CAST(76.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (21, 2, 2, 2, CAST(0x0000AA9A00A1E4C4 AS DateTime), N'Transporte del 15/08/2019', CAST(32.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (22, 1, 6, 2, CAST(0x0000AA9B009FB118 AS DateTime), N'Remuneración del 15/08/2019', CAST(40.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (23, 2, 2, 2, CAST(0x0000AAA800C8C454 AS DateTime), N'Transporte del 15/08/2019', CAST(48.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (24, 2, 3, 2, CAST(0x0000AAA600B0CEBC AS DateTime), N'Educación del 15/08/2019', CAST(7.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (25, 2, 2, 2, CAST(0x0000AA95012B37D8 AS DateTime), N'Transporte del 15/08/2019', CAST(80.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (26, 1, 6, 2, CAST(0x0000AAA0009F1794 AS DateTime), N'Remuneración del 15/08/2019', CAST(270.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (27, 2, 7, 1, CAST(0x0000AAA8015C4A58 AS DateTime), N'Vivienda del 15/08/2019', CAST(5.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (28, 2, 5, 1, CAST(0x0000AA9E0169EFB4 AS DateTime), N'Vestuario del 15/08/2019', CAST(34.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (29, 2, 4, 1, CAST(0x0000AA8D0092E80C AS DateTime), N'Salud del 15/08/2019', CAST(41.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (30, 2, 4, 1, CAST(0x0000AA9C00371FF4 AS DateTime), N'Salud del 15/08/2019', CAST(66.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (31, 1, 6, 2, CAST(0x0000AAAA015ECC35 AS DateTime), N'Mi ingreso del mes', CAST(1500.000000 AS Numeric(18, 6)), N'Mi ingreso personal', NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (32, 1, 6, 2, CAST(0x0000AAAA016055C7 AS DateTime), N'Mi ingreso del mes', CAST(1500.000000 AS Numeric(18, 6)), N'Mi ingreso personal', NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (33, 2, 4, 2, CAST(0x0000AA6D016089E0 AS DateTime), N'Odontologia', CAST(2000.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (34, 2, 7, 2, CAST(0x0000AAAA016130B3 AS DateTime), N'Alquiler', CAST(13000.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (35, 1, 6, 1, CAST(0x0000AAAA016378AD AS DateTime), N'Mi ingreso del mes', CAST(500.000000 AS Numeric(18, 6)), N'Mi ingreso personal', NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (36, 1, 16, 1, CAST(0x0000AAAA0164A957 AS DateTime), N'asdas', CAST(1100.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (37, 1, 8, 1, CAST(0x0000AAAA016E23FA AS DateTime), N'fwewef', CAST(149.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (38, 1, 6, 1, CAST(0x0000AA6E00E48E55 AS DateTime), N'Actual personal', CAST(3400.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (39, 1, 6, 2, CAST(0x0000AAAC00E76380 AS DateTime), N'Mi ingreso del mes', CAST(14000.000000 AS Numeric(18, 6)), NULL, NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (40, 1, 6, 2, CAST(0x0000AAAC00E90A2A AS DateTime), N'Mi ingreso del mes', CAST(1600.000000 AS Numeric(18, 6)), N'Probando modal', NULL)
INSERT [dbo].[tbTransaction] ([TransactionId], [TransactionTypeId], [CategoryId], [AccountId], [RegisterDate], [ShortDescription], [Amount], [Notes], [DateUpdate]) VALUES (41, 1, 6, 2, CAST(0x0000AAAC00E91791 AS DateTime), N'Mi ingreso del mes', CAST(1600.000000 AS Numeric(18, 6)), N'Probando modal', NULL)
INSERT [dbo].[tbTransactionType] ([TransactionTypeId], [Name]) VALUES (1, N'INGRESOS')
INSERT [dbo].[tbTransactionType] ([TransactionTypeId], [Name]) VALUES (2, N'GASTOS')
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbAccount] FOREIGN KEY([AccountId])
REFERENCES [dbo].[tbAccount] ([AccountId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbAccount]
GO
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tbCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbCategory]
GO
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbTransactionType] FOREIGN KEY([TransactionTypeId])
REFERENCES [dbo].[tbTransactionType] ([TransactionTypeId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbTransactionType]
GO
USE [master]
GO
ALTER DATABASE [Rp3Test] SET  READ_WRITE 
GO
