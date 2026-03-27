USE [HappyBites_Q7]
GO

/****** Object:  Trigger [dbo].[TRG_SetDonGia]    Script Date: 3/28/2026 12:04:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_SetDonGia]
ON [dbo].[CHI_TIET_DON_HANG]
AFTER INSERT
AS
BEGIN
    UPDATE CT
    SET DonGia = SP.GiaBan
    FROM CHI_TIET_DON_HANG CT
    JOIN inserted i ON CT.MaDH = i.MaDH AND CT.MaSP = i.MaSP
    JOIN SAN_PHAM SP ON SP.MaSP = CT.MaSP
END
GO

ALTER TABLE [dbo].[CHI_TIET_DON_HANG] ENABLE TRIGGER [TRG_SetDonGia]
GO

