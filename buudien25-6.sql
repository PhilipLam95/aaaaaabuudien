USE [TKBUUDIEN]
GO
/****** Object:  Role [ADMIN]    Script Date: 06/25/2017 01:19:37 ******/
CREATE ROLE [ADMIN] AUTHORIZATION [GDV1]
GO
/****** Object:  Role [NHANVIEN]    Script Date: 06/25/2017 01:19:37 ******/
CREATE ROLE [NHANVIEN] AUTHORIZATION [dbo]
GO
/****** Object:  User [GDV1]    Script Date: 06/25/2017 01:19:37 ******/
CREATE USER [GDV1] FOR LOGIN [GDV1] WITH DEFAULT_SCHEMA=[GDV1]
GO
/****** Object:  User [GDV2]    Script Date: 06/25/2017 01:19:37 ******/
CREATE USER [GDV2] FOR LOGIN [GDV2] WITH DEFAULT_SCHEMA=[GDV2]
GO
/****** Object:  User [GDV3]    Script Date: 06/25/2017 01:19:37 ******/
CREATE USER [GDV3] FOR LOGIN [GDV3] WITH DEFAULT_SCHEMA=[GDV3]
GO
/****** Object:  User [user_gdv]    Script Date: 06/25/2017 01:19:37 ******/
CREATE USER [user_gdv] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [useradmin]    Script Date: 06/25/2017 01:19:37 ******/
CREATE USER [useradmin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [GDV1]    Script Date: 06/25/2017 01:19:35 ******/
CREATE SCHEMA [GDV1] AUTHORIZATION [GDV1]
GO
/****** Object:  Schema [GDV2]    Script Date: 06/25/2017 01:19:35 ******/
CREATE SCHEMA [GDV2] AUTHORIZATION [GDV2]
GO
/****** Object:  Schema [GDV3]    Script Date: 06/25/2017 01:19:35 ******/
CREATE SCHEMA [GDV3] AUTHORIZATION [GDV3]
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[HOTEN] [nvarchar](50) NOT NULL,
	[DIACHI] [nvarchar](50) NOT NULL,
	[CMND] [nchar](9) NOT NULL,
	[NGAYCAP] [datetime] NOT NULL,
 CONSTRAINT [PK__KHACHHAN__F67C8D0A08EA5793] PRIMARY KEY CLUSTERED 
(
	[CMND] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GDV]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GDV](
	[MAGDV] [nchar](10) NOT NULL,
	[HOTEN] [nvarchar](50) NOT NULL,
	[DIACHI] [nvarchar](100) NOT NULL,
	[CMND] [nchar](9) NOT NULL,
	[SODT] [nchar](12) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_GDV] PRIMARY KEY CLUSTERED 
(
	[MAGDV] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DICHVU]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DICHVU](
	[MADV] [nchar](5) NOT NULL,
	[KYHAN] [int] NOT NULL,
	[TENDV] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_DICHVU] PRIMARY KEY CLUSTERED 
(
	[MADV] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Xoa_Login]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Xoa_Login]
  @LGNAME VARCHAR(50),
  @USRNAME VARCHAR(50)
  
AS
EXEC SP_DROPUSER @USRNAME
  EXEC SP_DROPLOGIN @LGNAME
GO
/****** Object:  StoredProcedure [dbo].[TAO_LOGIN]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TAO_LOGIN]
  @LGNAME VARCHAR(50),
  @PASS VARCHAR(50),
  @USRNAME VARCHAR(50),
 @ROLE VARCHAR(50)
AS
  DECLARE @RET INT
  EXEC @RET= SP_ADDLOGIN @LGNAME, @PASS,'TKBUUDIEN'
   IF (@RET =1)  -- LOGIN NAME BI TRUNG
     RETURN 1
 
  EXEC @RET= SP_GRANTDBACCESS @LGNAME, @USRNAME
  IF (@RET =1)  -- USER  NAME BI TRUNG
  BEGIN
       EXEC SP_DROPLOGIN @LGNAME
       RETURN 2
  END

IF (@ROLE ='ADMIN')
BEGIN
  EXEC sp_addsrvrolemember @LGNAME, 'SecurityAdmin'
  EXEC sp_addsrvrolemember @LGNAME, 'DBCreator'
  EXEC sp_addsrvrolemember @LGNAME, 'ProcessAdmin'
  EXEC sp_addrolemember 'ADMIN', @USRNAME
END
ELSE  -- THUOC NHOM NHANVIEN
BEGIN
   EXEC sp_addsrvrolemember @LGNAME, 'SecurityAdmin'
  EXEC sp_addrolemember 'NHANVIEN', @USRNAME
END
RETURN 0  -- THANH CONG
GO
/****** Object:  StoredProcedure [dbo].[SP_TINHNGAYDENHAN]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TINHNGAYDENHAN]
	-- Add the parameters for the stored procedure here
	@NGAYGUI nvarchar(50),
	@KYHAN real
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @NGAYDENHAN DATETIME,@TAM NVARCHAR(50)
	
	SET @TAM= DATEADD(MONTH,@KYHAN,@NGAYGUI)
	
	SET @NGAYDENHAN = CONVERT(NVARCHAR(50),@TAM)
	
	SELECT NGAYDENHAN = @NGAYDENHAN
	


END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYMADICHVU]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYMADICHVU]
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT MADV FROM DICHVU
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_THEMGDV]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_THEMGDV]
	@id int, 
	@MAGDV varchar(50),
	@HOTEN nvarchar(50),
	@DIACHI nvarchar(100),
	@CMND nchar(9),
	@SODT nchar(12),
	@TENDANGNHAP varchar(50),
	@MATKHAU varchar(50),
	@LOAITK nchar(10)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set @id = (select MAX(ID) from GDV) 
	set @id = @id +1
	set @MAGDV ='GDV'

	declare @i varchar(20)

	set @i =  CAST(@id as varchar(20))
	set @MAGDV = @MAGDV +@i
	print @MAGDV
	
	INSERT INTO GDV(MAGDV,HOTEN,DIACHI,CMND,SODT,TENDANGNHAP,MATKHAU,LOAITK) values (@MAGDV,@HOTEN,@DIACHI,@CMND,@SODT,@TENDANGNHAP,@MATKHAU,@LOAITK)
END
GO
/****** Object:  Table [dbo].[PHIEUGUI]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEUGUI](
	[MAPHIEU] [nchar](9) NOT NULL,
	[CMND] [nchar](9) NOT NULL,
	[MADV] [nchar](5) NOT NULL,
	[NGAYGUI] [datetime] NULL,
	[LAISUAT] [real] NULL,
	[SOTIEN_GUI] [money] NULL,
	[NGAYDENHAN] [datetime] NULL,
	[MAGDV_LPGUI] [nchar](10) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__PHIEUGUI__F001B9414E88ABD4] PRIMARY KEY CLUSTERED 
(
	[MAPHIEU] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[LIST_NHANVIEN]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LIST_NHANVIEN] 
AS
	SELECT MAGDV,HOTEN FROM GDV;
CREATE TABLE ACCOUNT 
(
    MAGDV NCHAR (10) NOT NULL PRIMARY KEY ,
	USERNAME VARCHAR (16) NOT NULL,
	PASSWORD VARCHAR (128) NOT NULL,
	ROLE VARCHAR(8) NOT NULL CHECK  (ROLE IN('GDV','ADMIN'))
	FOREIGN KEY (MAGDV) REFERENCES GDV(MAGDV)
)
GO
/****** Object:  Table [dbo].[LAISUAT]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LAISUAT](
	[MADV] [nchar](5) NOT NULL,
	[NGAYAD] [datetime] NOT NULL,
	[LAISUAT] [real] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MADV] ASC,
	[NGAYAD] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYCMND]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYCMND]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CMND FROM KHACHHANG
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DANGNHAP]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_DANGNHAP]
	-- Add the parameters for the stored procedure here
	@LOGINNAME NVARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @TENUSER NVARCHAR(20);--MA NHAN VIEN TRONG NHANVIEN
	DECLARE @HOTEN NVARCHAR(100); -- HO TEN NHAN VIEN
	DECLARE @UID SMALLINT;-- 
	DECLARE @GROUPID SMALLINT;
	DECLARE @ROLE NVARCHAR(20);
	--TÌM TENUSER TỪ SYS.SYSUSERS (MA SO NHAN VIEN)
	SELECT @TENUSER = NAME FROM sys.sysusers WHERE SID = SUSER_SID(@LOGINNAME) 
	
	
	
	--LẤY UID TỪ sys.sysusers
	SELECT @UID = UID FROM sys.sysusers WHERE NAME = @TENUSER
	--LẤY GROUPUID CỦA @UID TỪ SYS.SYSMEMBERS
	SELECT @GROUPID = groupuid FROM sys.sysmembers WHERE memberuid = @UID
	--LẤY ROLE TỪ sys.sysusers
	SELECT @ROLE = NAME FROM sys.sysusers WHERE uid = @GROUPID
	--LẤY HỌ TÊN NV
	SELECT  ROLES = @ROLE ,USERNAME = @TENUSER,HOTEN,MAGDV FROM GDV WHERE MAGDV = @TENUSER
	SELECT @HOTEN =  HOTEN FROM GDV WHERE MAGDV = @TENUSER
	--RETURN MANV, HO TEN, ROLE
	SELECT @TENUSER AS MAGDV, @HOTEN AS HOTEN  , @ROLE as role
	
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYTHONGTINKHACHANG]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYTHONGTINKHACHANG]
	-- Add the parameters for the stored procedure here
	@MAPHIEU NCHAR(9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT HOTEN,DIACHI,NGAYCAP,PHIEUGUI.CMND AS CMNDAN,
			PHIEUGUI.MADV AS MDV
					 FROM PHIEUGUI JOIN KHACHHANG ON PHIEUGUI.CMND = KHACHHANG.CMND 
							 WHERE @MAPHIEU = PHIEUGUI.MAPHIEU
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYTHONGTINDICHVU]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYTHONGTINDICHVU]
	-- Add the parameters for the stored procedure here
	@MADV NCHAR(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM DICHVU JOIN LAISUAT ON DICHVU.MADV = LAISUAT.MADV WHERE DICHVU.MADV = @MADV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYMAPHIEUGUI]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYMAPHIEUGUI]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MAPHIEU FROM PHIEUGUI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYMAPHIEU]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYMAPHIEU] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MAPHIEU FROM PHIEUGUI 
END
GO
/****** Object:  Table [dbo].[PHIEURUT]    Script Date: 06/25/2017 01:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEURUT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MAPHIEU] [nchar](9) NOT NULL,
	[MAGDV_LPRUT] [nchar](10) NOT NULL,
	[NGAYRUT] [datetime] NULL,
	[SOTIEN_RUT] [money] NOT NULL,
	[TIENLAI] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_THEMPHIEUGUI]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_THEMPHIEUGUI]
	-- PHIEU GUI --
		@CMND nchar(9),
		@MADV nchar(5),
		@SOTIEN_GUI VARCHAR(250),
		@NGAYDENHAN DATETIME,
		@MAGDV_LPGUI nchar(10),
	-- KHACH HANG --
		@DIACHI nvarchar(50),	
		@HOTEN nvarchar(50),
		@NGAYCAP DATETIME
AS
			DECLARE @id int,
					@maphieu varchar(50),
					@i varchar(20),@LAISUAT REAL,@CURRENT_TIME DATETIME,
					@TIEN_GUI money
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET @TIEN_GUI = CONVERT(MONEY,@SOTIEN_GUI)
	
	
	
	SET @LAISUAT = (SELECT LAISUAT FROM LAISUAT where LAISUAT.MADV = @MADV)
	SET @CURRENT_TIME = (SELECT CURRENT_TIMESTAMP) --NGAY GUI--	
	
	IF(not exists (Select CMND FROM KHACHHANG WHERE CMND = @CMND))
		BEGIN
			Insert into KHACHHANG(CMND,DIACHI,HOTEN,NGAYCAP) values(@CMND,@DIACHI,@HOTEN,@NGAYCAP)
			set @id = (select MAX(ID) from PHIEUGUI)
			set @id = @id +1
			set @maphieu ='A00'
			
			set @i =  CAST(@id as varchar(20))
			set @maphieu = @maphieu +@i
			INSERT INTO PHIEUGUI(MAPHIEU,CMND,MADV,NGAYGUI,LAISUAT,SOTIEN_GUI,NGAYDENHAN,MAGDV_LPGUI) 
			values (@maphieu,@CMND,@MADV,@CURRENT_TIME,@LAISUAT,@TIEN_GUI,@NGAYDENHAN,@MAGDV_LPGUI) 
		END
	ELSE
		begin
			set @id = (select MAX(ID) from PHIEUGUI)
			set @id = @id +1
			set @maphieu ='A00'


			set @i =  CAST(@id as varchar(20))
			set @maphieu = @maphieu +@i
	
			INSERT INTO PHIEUGUI(MAPHIEU,CMND,MADV,NGAYGUI,LAISUAT,SOTIEN_GUI,NGAYDENHAN,MAGDV_LPGUI) 
			values (@maphieu,@CMND,@MADV,@CURRENT_TIME,@LAISUAT,@TIEN_GUI,@NGAYDENHAN,@MAGDV_LPGUI)
		end
	select MAPHIEU = @maphieu 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LAYDULIEUFORPHIEURUT]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LAYDULIEUFORPHIEURUT] 
	-- Add the parameters for the stored procedure here
	@MAPHIEU nchar(9)
	
AS
BEGIN

   IF exists(SELECT PHIEUGUI.MAPHIEU FROM PHIEUGUI WHERE @MAPHIEU = PHIEUGUI.MAPHIEU)
	BEGIN
		SELECT * FROM KHACHHANG JOIN PHIEUGUI ON KHACHHANG.CMND= PHIEUGUI.CMND
							JOIN DICHVU ON DICHVU.MADV = PHIEUGUI.MADV
							WHERE  PHIEUGUI.MAPHIEU=@MAPHIEU
							   
							
	END
   ELSE
	BEGIN
		PRINT 'KHONG CO MA PHIEU NAY'
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TINHLAISUAT]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TINHLAISUAT] 
	
	@NGAYDENHAN Datetime,
	@NGAYRUT Datetime,
	@NGAYGUI datetime,
	@LAISUAT REAL,
	@SOTIENGUI MONEY,
	@KYHAN int
/*@MADV nchar(5)*/

	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
	DECLARE @SONGAY_GUI real,
			@LAISUATKHONGKYHAN REAL,
			@TIENLAI Money,
			@TONGTIEN Money
			
	SET @LAISUATKHONGKYHAN = (SELECT MIN(LAISUAT) FROM LAISUAT)
	
	
	
	
	IF(@NGAYRUT< @NGAYDENHAN)/* Ngay rut tien < ngay gui lien=> rut truoc han*/
		BEGIN
			SET @SONGAY_GUI  = DATEDIFF(DAY,@NGAYGUI,@NGAYRUT)
			
			SET @TIENLAI = (@SOTIENGUI * (@SONGAY_GUI/365) *(@LAISUATKHONGKYHAN/100))/10000
		END
		
	
	IF(@NGAYRUT = @NGAYDENHAN)/* rut dung han */
		BEGIN
			SET @SONGAY_GUI  = DATEDIFF(DAY,@NGAYGUI,@NGAYRUT)
			SET @TIENLAI = ((@SOTIENGUI * @LAISUAT/(12*100) * @KYHAN))/10000

		END
		
	IF(@NGAYRUT > @NGAYDENHAN)   /* rut qua han */
		BEGIN
		SET @SONGAY_GUI  = DATEDIFF(DAY,@NGAYGUI,@NGAYRUT)
		SELECT * FROM GDV
			/*DECLARE @TIENLAI_TRONGHAN MONEY,
					@TIENLAI_QUAHAN MONEY,
					@SONGAY_QUAHAN REAL,
					@SONGAY_QUAHAN1KY REAL,
					@SONGAY_QUAHAN2KY REAL,
					@SONGAY_QUAHAN3KY REAL
			SET @SONGAY_QUAHAN = DATEDIFF(DAY,@NGAYDENHAN,@NGAYRUT)
			SET @SONGAY_GUI = DATEDIFF(DAY,@NGAYGUI,@NGAYDENHAN)
			SET @TIENLAI_TRONGHAN = (@SOTIENGUI *(@LAISUAT/(12*100))* @KYHAN)
			IF(@SONGAY_QUAHAN >1 AND @SONGAY_QUAHAN <90  )
				BEGIN
					SET @TIENLAI_QUAHAN = @SOTIENGUI * (@SONGAY_QUAHAN/365)*2/100
				END
			IF(@SONGAY_QUAHAN >90 AND @SONGAY_QUAHAN<180) /* Qua han 1 ky 3 thang>x >6thang */				
				SET @SONGAY_QUAHAN1KY = DATEDIFF(DAY,90,@SONGAY_QUAHAN)
				BEGIN
					SET @TIENLAI_QUAHAN = (@SOTIENGUI * (3/12)* (5/100) 
											+ @SOTIENGUI *(@SONGAY_QUAHAN1KY/365)*(2/100))
				END
			IF(@SONGAY_QUAHAN >180 AND @SONGAY_QUAHAN <365)/* Qua han 1 ky 6 thang> x >12thang */
				SET @SONGAY_QUAHAN2KY =DATEDIFF(DAY,180,@SONGAY_QUAHAN)
				BEGIN
					SET @TIENLAI_QUAHAN= (@SOTIENGUI *(3/12)*(5/100) 
											+ @SOTIENGUI *(6/12)*(6/100) 
											+ @SOTIENGUI*(@SONGAY_QUAHAN2KY/365)*(2/100))
				END	
			IF(@SONGAY_QUAHAN>365)
				SET @SONGAY_QUAHAN3KY =DATEDIFF(DAY,365,@SONGAY_QUAHAN)
				BEGIN
					SET @TIENLAI_QUAHAN =(@SOTIENGUI *(3/12)*(5/100)
											+ @SOTIENGUI *(6/12)*(6/100)
											+ @SOTIENGUI * (12/12)*(8/100)
											+ @SOTIENGUI * (@SONGAY_QUAHAN3KY/365)*(2/100))
				END
			SET @TIENLAI = @TIENLAI_TRONGHAN + @TIENLAI_QUAHAN*/
			DECLARE @SONGAY_QUAHAN REAL,@SOTHANG_QUAHAN REAL,@SONAM_QUAHAN REAL
			SET @SOTHANG_QUAHAN  = DATEDIFF(MONTH,@NGAYRUT,@NGAYDENHAN)
			IF( @SOTHANG_QUAHAN < (SELECT MIN(KYHAN) FROM DICHVU WHERE KYHAN>0))
				SET @SONGAY_QUAHAN= DATEDIFF(DAY,@NGAYRUT,@NGAYDENHAN)
				BEGIN
					SET @TIENLAI = (@SOTIENGUI * (@SONGAY_QUAHAN/365) * (@LAISUATKHONGKYHAN/100))/10000
				END	
			/*SET @SOTHANG_QUAHAN = DATEDIFF(MONTH,@NGAYRUT,@NGAYDENHAN)
			PRINT @SOTHANG_QUAHAN
			SET @SONAM_QUAHAN = DATEDIFF(YEAR,@NGAYRUT,@NGAYDENHAN)
			PRINT @SONAM_QUAHAN
			IF (@sONGAY)*/
			IF(@SOTHANG_QUAHAN > (SELECT KYHAN FROM DICHVU WHERE KYHAN<@SOTHANG_QUAHAN AND KYHAN >0))
				BEGIN
					DECLARE @TIENLAI1 MONEY,@TIENLAI2 MONEY
					SET @TIENLAI1 = @SOTIENGUI
				END
			
			
			/*DECLARE @SOTHANG_QUAHAN REAL,@TIENLAI1 MONEY,@SOTIENGUI MONEY
SET @SOTHANG_QUAHAN ='10'
SET @SOTIENGUI = 100000000
SELECT KYHAN FROM DICHVU WHERE KYHAN<@SOTHANG_QUAHAN AND KYHAN >0*/
		END
			
		
		SET @TONGTIEN = (@SOTIENGUI + @TIENLAI)
		CREATE TABLE #TIENLAI (TIENLAI MONEY,TONGTIEN MONEY,SONGAYGUI real) 
		INSERT INTO #TIENLAI(TIENLAI,TONGTIEN,SONGAYGUI) VALUES (@TIENLAI,@TONGTIEN,@SONGAY_GUI)
		SELECT * FROM #TIENLAI
		
		
			
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_XOAPHIEUGUI]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_XOAPHIEUGUI]
	-- Add the parameters for the stored procedure here
	@MAPHIEU NCHAR(9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM PHIEUGUI WHERE PHIEUGUI.MAPHIEU=@MAPHIEU;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_THEMPHIEURUT]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_THEMPHIEURUT] 
	-- Add the parameters for the stored procedure here
	@MAPHIEU  NCHAR(9),
	@MAGDV_LPRUT NCHAR(10),
	@NGAYRUT DATETIME,
	@SOTIENGUI MONEY,
	@TIENLAI MONEY,
	@SOTIEN_RUT BIGINT
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TIENRUT AS MONEY
	SET @TIENRUT = CONVERT(MONEY,@SOTIEN_RUT)
	
	PRINT @TIENRUT
	
	
	DECLARE  @TONGTIEN MONEY,@RET INT
	SET @RET = 1
	
		
	SET  @TONGTIEN = @SOTIENGUI+@TIENLAI
	
	IF (@TIENRUT <@TONGTIEN OR @TIENRUT = @TONGTIEN)
		BEGIN		
			DECLARE @SOTIEN_CONLAI MONEY
	
			INSERT INTO PHIEURUT(MAPHIEU,MAGDV_LPRUT,NGAYRUT,SOTIEN_RUT,TIENLAI) 
			VALUES (@MAPHIEU,@MAGDV_LPRUT,@NGAYRUT,@TIENRUT,@TIENLAI)
			
			SET @SOTIEN_CONLAI = @TONGTIEN - @TIENRUT
			SET @SOTIEN_CONLAI = @SOTIEN_CONLAI/10000
			
			UPDATE PHIEUGUI SET SOTIEN_GUI = @SOTIEN_CONLAI WHERE PHIEUGUI.MAPHIEU = @MAPHIEU
			

		END
	IF(@TIENRUT > @TONGTIEN)
		BEGIN
			RETURN @RET
		END
	
	
	
	
		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TESTTHEMPHIEURUT]    Script Date: 06/25/2017 01:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[SP_TESTTHEMPHIEURUT] 
	-- Add the parameters for the stored procedure here
	@MAPHIEU  NCHAR(9),
	@MAGDV_LPRUT NCHAR(10),
	@NGAYRUT DATETIME,
	@SOTIENGUI MONEY,
	@TIENLAI MONEY,
	@SOTIEN_RUT BIGINT
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TIENRUT AS MONEY
	SET @TIENRUT = CONVERT(MONEY,@SOTIEN_RUT)
	
	PRINT @TIENRUT
	
	
	DECLARE  @TONGTIEN MONEY,@RET INT
	SET @RET = 1
	
		
	SET  @TONGTIEN = @SOTIENGUI+@TIENLAI
	
	IF (@TIENRUT <@TONGTIEN OR @TIENRUT = @TONGTIEN)
		BEGIN		
			DECLARE @SOTIEN_CONLAI MONEY
	
			INSERT INTO PHIEURUT(MAPHIEU,MAGDV_LPRUT,NGAYRUT,SOTIEN_RUT,TIENLAI) 
			VALUES (@MAPHIEU,@MAGDV_LPRUT,@NGAYRUT,@TIENRUT,@TIENLAI)
			
			SET @SOTIEN_CONLAI = @TONGTIEN - @TIENRUT
			
			UPDATE PHIEUGUI SET SOTIEN_GUI = @SOTIEN_CONLAI WHERE PHIEUGUI.MAPHIEU = @MAPHIEU
			

		END
	IF(@TIENRUT > @TONGTIEN)
		BEGIN
			RETURN @RET
		END
	
	
	
	
		
	
END
GO
/****** Object:  Default [DF__PHIEUGUI__NGAYGU__52593CB8]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI] ADD  CONSTRAINT [DF__PHIEUGUI__NGAYGU__52593CB8]  DEFAULT (getdate()) FOR [NGAYGUI]
GO
/****** Object:  Default [DF__PHIEUGUI__SOTIEN__534D60F1]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI] ADD  CONSTRAINT [DF__PHIEUGUI__SOTIEN__534D60F1]  DEFAULT ((100000)) FOR [SOTIEN_GUI]
GO
/****** Object:  Default [DF__PHIEURUT__TIENLA__5CD6CB2B]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEURUT] ADD  DEFAULT ((0)) FOR [TIENLAI]
GO
/****** Object:  Check [CK__PHIEUGUI__SOTIEN__5441852A]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI]  WITH CHECK ADD  CONSTRAINT [CK__PHIEUGUI__SOTIEN__5441852A] CHECK  (([SOTIEN_GUI]>=(100000)))
GO
ALTER TABLE [dbo].[PHIEUGUI] CHECK CONSTRAINT [CK__PHIEUGUI__SOTIEN__5441852A]
GO
/****** Object:  Check [CK__PHIEURUT__SOTIEN__5BE2A6F2]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEURUT]  WITH CHECK ADD CHECK  (([SOTIEN_RUT]>(0)))
GO
/****** Object:  ForeignKey [FK_LAISUAT_DICHVU]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[LAISUAT]  WITH CHECK ADD  CONSTRAINT [FK_LAISUAT_DICHVU] FOREIGN KEY([MADV])
REFERENCES [dbo].[DICHVU] ([MADV])
GO
ALTER TABLE [dbo].[LAISUAT] CHECK CONSTRAINT [FK_LAISUAT_DICHVU]
GO
/****** Object:  ForeignKey [FK_PHIEUGUI_DICHVU]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI]  WITH CHECK ADD  CONSTRAINT [FK_PHIEUGUI_DICHVU] FOREIGN KEY([MADV])
REFERENCES [dbo].[DICHVU] ([MADV])
GO
ALTER TABLE [dbo].[PHIEUGUI] CHECK CONSTRAINT [FK_PHIEUGUI_DICHVU]
GO
/****** Object:  ForeignKey [FK_PHIEUGUI_GDV]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI]  WITH CHECK ADD  CONSTRAINT [FK_PHIEUGUI_GDV] FOREIGN KEY([MAGDV_LPGUI])
REFERENCES [dbo].[GDV] ([MAGDV])
GO
ALTER TABLE [dbo].[PHIEUGUI] CHECK CONSTRAINT [FK_PHIEUGUI_GDV]
GO
/****** Object:  ForeignKey [FK_PHIEUGUI_KHACHHANG]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEUGUI]  WITH CHECK ADD  CONSTRAINT [FK_PHIEUGUI_KHACHHANG] FOREIGN KEY([CMND])
REFERENCES [dbo].[KHACHHANG] ([CMND])
GO
ALTER TABLE [dbo].[PHIEUGUI] CHECK CONSTRAINT [FK_PHIEUGUI_KHACHHANG]
GO
/****** Object:  ForeignKey [FK_PHIEURUT_GDV]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEURUT]  WITH CHECK ADD  CONSTRAINT [FK_PHIEURUT_GDV] FOREIGN KEY([MAGDV_LPRUT])
REFERENCES [dbo].[GDV] ([MAGDV])
GO
ALTER TABLE [dbo].[PHIEURUT] CHECK CONSTRAINT [FK_PHIEURUT_GDV]
GO
/****** Object:  ForeignKey [FK_PHIEURUT_PHIEUGUI]    Script Date: 06/25/2017 01:19:37 ******/
ALTER TABLE [dbo].[PHIEURUT]  WITH CHECK ADD  CONSTRAINT [FK_PHIEURUT_PHIEUGUI] FOREIGN KEY([MAPHIEU])
REFERENCES [dbo].[PHIEUGUI] ([MAPHIEU])
GO
ALTER TABLE [dbo].[PHIEURUT] CHECK CONSTRAINT [FK_PHIEURUT_PHIEUGUI]
GO
