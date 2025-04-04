USE [master]
GO
/****** Object:  Database [prj301_1805_slot8]    Script Date: 3/25/2025 7:36:15 PM ******/
CREATE DATABASE [prj301_1805_slot8]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'prj301_1805_slot8', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.CBAOSQL\MSSQL\DATA\prj301_1805_slot8.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'prj301_1805_slot8_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.CBAOSQL\MSSQL\DATA\prj301_1805_slot8_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [prj301_1805_slot8] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [prj301_1805_slot8].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [prj301_1805_slot8] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET ARITHABORT OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [prj301_1805_slot8] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [prj301_1805_slot8] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET  ENABLE_BROKER 
GO
ALTER DATABASE [prj301_1805_slot8] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [prj301_1805_slot8] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET RECOVERY FULL 
GO
ALTER DATABASE [prj301_1805_slot8] SET  MULTI_USER 
GO
ALTER DATABASE [prj301_1805_slot8] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [prj301_1805_slot8] SET DB_CHAINING OFF 
GO
ALTER DATABASE [prj301_1805_slot8] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [prj301_1805_slot8] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [prj301_1805_slot8] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [prj301_1805_slot8] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'prj301_1805_slot8', N'ON'
GO
ALTER DATABASE [prj301_1805_slot8] SET QUERY_STORE = OFF
GO
USE [prj301_1805_slot8]
GO
/****** Object:  Table [dbo].[bookings]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userID] [varchar](50) NOT NULL,
	[room_id] [int] NOT NULL,
	[check_in_date] [date] NOT NULL,
	[check_out_date] [date] NOT NULL,
	[total_price] [decimal](10, 2) NOT NULL,
	[status] [nvarchar](50) NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contact_messages]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_messages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [varchar](50) NULL,
	[full_name] [nvarchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phone] [varchar](20) NULL,
	[message] [nvarchar](max) NOT NULL,
	[created_at] [datetime] NULL,
	[is_read] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[notifications]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[notifications](
	[notification_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [varchar](50) NOT NULL,
	[message] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
	[is_read] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reviews]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reviews](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[room_id] [int] NOT NULL,
	[user_id] [varchar](50) NOT NULL,
	[rating] [float] NOT NULL,
	[comment] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[room_images]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[room_images](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[room_id] [int] NOT NULL,
	[image_url] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rooms]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rooms](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[amenities] [nvarchar](max) NOT NULL,
	[ratings] [float] NULL,
	[image_url] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBooks]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBooks](
	[BookID] [char](5) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Author] [nvarchar](100) NOT NULL,
	[PublishYear] [int] NULL,
	[Price] [decimal](10, 2) NULL,
	[Quantity] [int] NULL,
	[image] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 3/25/2025 7:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsers](
	[userID] [varchar](50) NOT NULL,
	[fullName] [nvarchar](255) NULL,
	[roleID] [char](2) NOT NULL,
	[password] [varchar](250) NOT NULL,
	[gmail] [varchar](100) NULL,
	[sdt] [varchar](15) NULL,
	[avatar_url] [varchar](255) NULL,
	[token] [nvarchar](255) NULL,
	[isVerified] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bookings] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[bookings] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[contact_messages] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[contact_messages] ADD  DEFAULT ((0)) FOR [is_read]
GO
ALTER TABLE [dbo].[notifications] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[notifications] ADD  DEFAULT ((0)) FOR [is_read]
GO
ALTER TABLE [dbo].[reviews] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[rooms] ADD  DEFAULT ((0.0)) FOR [ratings]
GO
ALTER TABLE [dbo].[tblBooks] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[tblUsers] ADD  DEFAULT ((0)) FOR [isVerified]
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD  CONSTRAINT [FK_bookings_rooms] FOREIGN KEY([room_id])
REFERENCES [dbo].[rooms] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[bookings] CHECK CONSTRAINT [FK_bookings_rooms]
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD  CONSTRAINT [FK_bookings_users] FOREIGN KEY([userID])
REFERENCES [dbo].[tblUsers] ([userID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[bookings] CHECK CONSTRAINT [FK_bookings_users]
GO
ALTER TABLE [dbo].[contact_messages]  WITH CHECK ADD  CONSTRAINT [FK_contact_messages_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[tblUsers] ([userID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[contact_messages] CHECK CONSTRAINT [FK_contact_messages_user_id]
GO
ALTER TABLE [dbo].[notifications]  WITH CHECK ADD  CONSTRAINT [FK__notificat__user___2B0A656D] FOREIGN KEY([user_id])
REFERENCES [dbo].[tblUsers] ([userID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[notifications] CHECK CONSTRAINT [FK__notificat__user___2B0A656D]
GO
ALTER TABLE [dbo].[reviews]  WITH CHECK ADD  CONSTRAINT [FK_reviews_rooms] FOREIGN KEY([room_id])
REFERENCES [dbo].[rooms] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[reviews] CHECK CONSTRAINT [FK_reviews_rooms]
GO
ALTER TABLE [dbo].[reviews]  WITH CHECK ADD  CONSTRAINT [FK_reviews_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[tblUsers] ([userID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[reviews] CHECK CONSTRAINT [FK_reviews_users]
GO
ALTER TABLE [dbo].[room_images]  WITH CHECK ADD FOREIGN KEY([room_id])
REFERENCES [dbo].[rooms] ([id])
ON DELETE CASCADE
GO
USE [master]
GO
ALTER DATABASE [prj301_1805_slot8] SET  READ_WRITE 
GO
