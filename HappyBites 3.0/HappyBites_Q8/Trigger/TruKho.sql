USE [HappyBites_Q8]
GO

/****** Object:  Trigger [dbo].[TRG_TruKho]    Script Date: 3/28/2026 12:05:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_TruKho]
ON [dbo].[CHI_TIET_DON_HANG]
AFTER INSERT
AS
BEGIN
    -- 1. CHECK tồn kho trước
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN CONG_THUC CT ON i.MaSP = CT.MaSP
        JOIN DON_HANG DH ON DH.MaDH = i.MaDH
        JOIN NHAN_VIEN NV ON NV.MaNV = DH.MaNV
        JOIN TON_KHO TK ON TK.MaNL = CT.MaNL AND TK.MaCN = NV.MaCN
        WHERE TK.Soluongton < (CT.Soluongcan * i.Soluong)
    )
    BEGIN
        RAISERROR (N'Không đủ nguyên liệu để bán!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- 2. TRỪ KHO
    UPDATE TK
    SET TK.Soluongton = TK.Soluongton - (CT.Soluongcan * i.Soluong)
    FROM TON_KHO TK
    JOIN CONG_THUC CT ON TK.MaNL = CT.MaNL
    JOIN inserted i ON CT.MaSP = i.MaSP
    JOIN DON_HANG DH ON DH.MaDH = i.MaDH
    JOIN NHAN_VIEN NV ON NV.MaNV = DH.MaNV
    WHERE TK.MaCN = NV.MaCN
END
GO

ALTER TABLE [dbo].[CHI_TIET_DON_HANG] ENABLE TRIGGER [TRG_TruKho]
GO

