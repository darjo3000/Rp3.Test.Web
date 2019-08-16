USE [master]
GO
/****** Object:  Database [Rp3Test]    Script Date: 16-08-2019 05:57:20 p.m. ******/
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
/****** Object:  StoredProcedure [dbo].[FillRandomData]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  StoredProcedure [dbo].[spGetBalance]    Script Date: 16-08-2019 05:57:21 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetBalance]
@AccountId int
AS
	BEGIN

	SELECT TransactionTypeId, t.CategoryId, c.Name AS CategoryName, AccountId, SUM (Amount) AS Amount
	FROM tbTransaction t
	INNER JOIN tbCategory c ON t.CategoryId = c.CategoryId
	WHERE AccountId = @AccountId
	GROUP BY TransactionTypeId, t.CategoryId, c.Name, AccountId
	ORDER BY TransactionTypeId, Amount DESC;

	END

RETURN

GO
/****** Object:  StoredProcedure [dbo].[spTransactionInsert]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  StoredProcedure [dbo].[spTransactionUpdate]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  Table [dbo].[tbAccount]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  Table [dbo].[tbCategory]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  Table [dbo].[tbTransaction]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
/****** Object:  Table [dbo].[tbTransactionType]    Script Date: 16-08-2019 05:57:21 p.m. ******/
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
