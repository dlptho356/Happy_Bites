USE [HappyBites_Q8]
GO

/****** Object:  Trigger [dbo].[TRG_TinhTongTien]    Script Date: 3/28/2026 12:05:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_TinhTongTien]
ON [dbo].[CHI_TIET_DON_HANG]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE DON_HANG
    SET Tongtien = (
        SELECT SUM(Soluong * Dongia)
        FROM CHI_TIET_DON_HANG CT
        WHERE CT.MaDH = DON_HANG.MaDH
    )
    WHERE MaDH IN (
        SELECT MaDH FROM inserted
        UNION
        SELECT MaDH FROM deleted
    )
END
GO

ALTER TABLE [dbo].[CHI_TIET_DON_HANG] ENABLE TRIGGER [TRG_TinhTongTien]
GO

