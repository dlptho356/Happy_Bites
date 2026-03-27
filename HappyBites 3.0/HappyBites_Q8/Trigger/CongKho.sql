USE [HappyBites_Q8]
GO

/****** Object:  Trigger [dbo].[TRG_CongKho]    Script Date: 3/28/2026 12:06:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_CongKho]
ON [dbo].[CHI_TIET_NHAP]
AFTER INSERT
AS
BEGIN
    -- 1. CẬP NHẬT nếu đã tồn tại trong kho
    UPDATE TK
    SET TK.Soluongton = TK.Soluongton + i.Soluong
    FROM TON_KHO TK
    JOIN inserted i ON TK.MaNL = i.MaNL
    JOIN NHAP_KHO NK ON NK.MaNK = i.MaNK
    JOIN NHAN_VIEN NV ON NV.MaNV = NK.MaNV
    WHERE TK.MaCN = NV.MaCN

    -- 2. THÊM MỚI nếu chưa có trong kho
    INSERT INTO TON_KHO (Soluongton, MaCN, MaNL)
    SELECT 
        i.Soluong,
        NV.MaCN,
        i.MaNL
    FROM inserted i
    JOIN NHAP_KHO NK ON NK.MaNK = i.MaNK
    JOIN NHAN_VIEN NV ON NV.MaNV = NK.MaNV
    WHERE NOT EXISTS (
        SELECT 1
        FROM TON_KHO TK
        WHERE TK.MaNL = i.MaNL 
          AND TK.MaCN = NV.MaCN
    )
END
GO

ALTER TABLE [dbo].[CHI_TIET_NHAP] ENABLE TRIGGER [TRG_CongKho]
GO

