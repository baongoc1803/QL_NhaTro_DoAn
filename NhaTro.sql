
drop database NhaTro

create table NhanVien(
	ma_nv varchar(10) not null,
	ten_nv nvarchar(50) not null,
	vai_tro nvarchar(20),
	cccd_nv varchar(15) not null,
	sdt_nv varchar(10)

	constraint PK_NhanVien primary key (ma_nv)
)
go

create table HopDong(
	ma_HD varchar(10) not null,
	ma_nha varchar(10) not null,
	ma_KH varchar (10) not null,
	ma_nv varchar(10) not null,
	ngay_HD date,
	tien_dat int,
	gia_thue int,
	tg_thue nvarchar(20),

	constraint PK_HopDong primary key (ma_HD)
)
go

create table PhieuThu(
	so_phieu int,
	ma_nv varchar(10) not null,
	ma_KH varchar (10) not null,
	ma_nha varchar(10) not null,
	ngay_thu date,
	Tien_Dien_SD int,
	Tien_Nuoc_SD int,
	tien_Phong int,
	tong_Tien int,

	constraint PK_PhieuThu primary key(so_phieu)
)
go

create table SuCo(
	ma_suCo varchar(10),
	ten_SC nvarchar(50)

	constraint PK_SuCo primary key (ma_suCo)
)
go

create table BienBanSuCo(
	so_BBSC varchar(10),
	ma_nha varchar(10) not null,
	ma_KH varchar (10) not null,
	ma_nv varchar(10) not null,
	ma_suCo varchar(10),
	ngay_BB date,
	ND_SuCo nvarchar(255),
	tien_phat int

	constraint PK_BienBanSuCo primary key (so_BBSC)
)
go

create table Nha(
	ma_nha varchar(10) not null,
	dia_chi nvarchar(50) not null,
	dien_tich float not null,
	tien_ich nvarchar(50),
	don_gia int,
	trang_thai nvarchar(15)

	constraint PK_Nha primary key(ma_nha)
)
go


create table Khach(
	ma_KH varchar (10) not null,
	ma_nha varchar(10) not null,
	ten_KH nvarchar(50) not null,
	dia_chiLH nvarchar(50),
	sdt_KH varchar(10),
	cccd_KH varchar(15) not null

	constraint PK_Khach primary key (ma_KH)
)
go

create table HoaDon_BoiThuong(
	so_HDBT int identity,
	ma_KH varchar (10) not null,
	ma_nv varchar(10) not null,
	ngay_thanhToan date,
	so_BBSC varchar(10),
	ho_so_kem nvarchar(10),
	tien_thanhToan int

	constraint PK_HoaDon_BoiThuong primary key (so_HDBT)
)
go


create table account
(
	userName varchar(20) not null,
	name varchar(50),
	password varchar(20),
	secQuestion numeric,
	answer varchar(200),

	constraint PK_account primary key (userName),
)
go




---------------------THÊM KHÓA NGOẠI CHO CÁC BẢNG-----------------------


--------------THÊM KHÓA NGOẠI BẢNG NHÂN VIÊN--------------

alter table HopDong
add constraint FK_NhanVien_HopDong foreign key (ma_nv) references NhanVien(ma_nv)

alter table PhieuThu
add constraint FK_NhanVien_PhieuThu foreign key (ma_nv) references NhanVien(ma_nv)

alter table BienBanSuCo
add constraint FK_NhanVien_BienBanSuCo foreign key (ma_nv) references NhanVien(ma_nv)

alter table HoaDon_BoiThuong
add constraint FK_NhanVien_HoaDon_BoiThuong foreign key (ma_nv) references NhanVien(ma_nv)




--------------THÊM KHÓA NGOẠI BẢNG BIÊN BẢNG SỰ CỐ--------------

alter table BienBanSuCo
add constraint FK_BienBanSuCo_SuCo foreign key (ma_suCo) references SuCo(ma_suCo)


--------------THÊM KHÓA NGOẠI BẢNG NHÀ--------------


alter table HopDong
add constraint FK_Nha_HopDong foreign key (ma_nha) references Nha(ma_nha)

alter table PhieuThu
add constraint FK_Nha_PhieuThu foreign key (ma_nha) references Nha(ma_nha)

alter table BienBanSuCo
add constraint FK_Nha_BienBanSuCo foreign key (ma_nha) references Nha(ma_nha)

alter table Khach
add constraint FK_Nha_Khach foreign key (ma_nha) references Nha(ma_nha)

--------------THÊM KHÓA NGOẠI BẢNG KHÁCH--------------


alter table HopDong
add constraint FK_Khach_HopDong foreign key (ma_KH) references Khach(ma_KH)

alter table PhieuThu
add constraint FK_Khach_PhieuThu foreign key (ma_KH) references Khach(ma_KH)


alter table BienBanSuCo
add constraint FK_Khach_BienBanSuCo foreign key (ma_KH) references Khach(ma_KH)

alter table HoaDon_BoiThuong
add constraint FK_Khach_HoaDon_BoiThuong foreign key (ma_KH) references Khach(ma_KH)


--------------THÊM KHÓA NGOẠI BẢNG HÓA ĐƠN BỒI THƯỜNG--------------

alter table HoaDon_BoiThuong
add constraint FK_HoaDon_BoiThuong_BienBanSuCo foreign key (so_BBSC) references BienBanSuCo(so_BBSC)


--------------CÀI ĐẶT RÀNG BUỘC TOÀN VẸN--------------

--------------DEFAULT--------------

alter table Nha
add constraint DF_trang_thai default N'Chưa thuê' for trang_thai

--------------UNIQUE--------------

alter table NhanVien
add constraint UQ_NhanVien_cccd_nv unique (cccd_nv)

alter table Khach
add constraint UQ_Khach_cccd_KH unique (cccd_KH);


--------------CHECK--------------

alter table PhieuThu
add constraint CHK_PhieuThu_tong_Tien check (tong_Tien > 1500000);


--------------TRIGGER--------------

-- Trigger cho bảng NhanVien

create or alter trigger tr_UniqueSdt_NhanVien
on NhanVien
after insert, UPDATE
as
begin
    if exists (select sdt_nv
               from NhanVien
               group by sdt_nv
               having COUNT(*) > 1)
    begin
        print 'Số điện thoại của nhân viên phải là duy nhất !';
        rollback transaction;
    end
end;
go

-- Trigger cho bảng Khach
create or alter trigger tr_Uniquecccd_Khach
on Khach
after insert, update
as
begin
    if exists (select cccd_KH
               from Khach
               group by cccd_KH
               having COUNT(*) > 1)
    begin
        print 'Căn cước công dân của khách hàng phải là duy nhất !';
        ROLLBACK TRANSACTION;
    end
end;
go

--------------------------------------------------END--------------------------------------------------

----NHẬP XUẤT DỮ LIỆU CHO BẢNG NHÂN VIÊN----
INSERT INTO NHANVIEN(ma_nv,ten_nv,vai_tro,cccd_nv,sdt_nv)
VALUES
('NV001',N'Nguyễn Văn An',N'Sales','072390456123','0934512678'),
('NV002',N'Trần Thị Bi',N'Sales','072390235678','0334512876'),
('NV003',N'Lê văn Cường',N'Sales','072280496123','0584512778'),
('NV004',N'Nguyễn Khánh Nam',N'Sales','072496753127','0894515478'),
('NV005',N'Hồ Thị Thảo',N'Sales','072278956187','0511234654'),
('NV006',N'Hoàng Vân Nguyên',N'Sales','072654561345','0367823416'),
('NV008',N'Dương Thảo Chi',N'Sales','079871235642','0934658971'),
('NV009',N'Trần Liên Anh',N'Sales','073412354687','0397844574')

SELECT * FROM NhanVien

----NHẬP LIỆU CHO BẢNG NHÀ----
INSERT INTO Nha(ma_nha,dia_chi,dien_tich,tien_ich,don_gia, trang_thai)
VALUES
('A0123',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','28.2',N'Máy Lạnh,Wifi,Tủ Lạnh','4200000',N'Chưa Thuê'),
('A0124',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','26.2',N'Wifi,Tủ Lạnh','3800000',N'Chưa Thuê'),
('A0125',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','26.2',N'Máy Lạnh,Wifi','3500000',N'Đã Thuê'),
('A0126',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','28.2',N'Wifi','3200000',N'Đã Đặt Cọc'),
('A0127',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','28.2',N'Máy Lạnh,Wifi,Máy Nước Nóng Lạnh','4800000',N'Chưa Thuê'),
('B0114',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','25.2',N'Wifi','3000000',N'Chưa Thuê'),
('B0115',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','25.2',N'Wifi,Tủ Lạnh','3300000',N'Đã Thuê'),
('B0116',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','24.2',N'Wifi,Máy Nước Nóng Lạnh','3500000',N'Đã Thuê'),
('B0117',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','22.2',N'Wifi,Máy Lạnh','3400000',N'Đã Đặt Cọc'),
('B0118',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','22.2',N'Wifi,Tủ Lạnh','3200000',N'Đã Thuê'),
('C0133',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','22.2',N'Wifi','2800000',N'Đã Thuê'),
('C0134',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','20.2',N'Wifi','2700000',N'Đã Thuê'),
('C0135',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','18.2',N'Wifi','2500000',N'Đã Thuê'),
('C0136',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','16.2',N'Wifi','2200000',N'Đã Thuê'),
('C0137',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','15.2',N'Wifi','2000000',N'Đã Đặt Cọc'),
('D0143',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','18.2',N'Không Có Tiện ích','1800000',N'Đã Đặt Cọc'),
('D0144',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','20.2',N'Tủ Lạnh','2400000',N'Đã Thuê'),
('D0145',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','22.2',N'Máy Lạnh','2200000',N'Đã Thuê'),
('D0146',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','18.2',N'Máy Nước Nóng Lạnh','2500000',N'Chưa Thuê'),
('D0147',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','18.2',N'Máy Quạt','2000000',N'Đã Thuê')
--UPDATE THÔNG TIN--
UPDATE Nha
SET trang_thai = N'Chưa Thuê'
WHERE ma_nha = 'A0126'
---
SELECT * FROM Nha
----Nhập Liệu Bảng Khách Hàng---
INSERT INTO Khach(ma_KH,ma_nha,ten_KH,dia_chiLH,sdt_KH,cccd_KH)
VALUES
('KH001','A0125',N'Nguyễn Thị Mi',N'Bình Thuận','0352346781','072303002445'),
('KH002','A0125',N'Nguyễn Văn Anh',N'Nha Trang','0382346451','072523102445'),
('KH003','B0115',N'Lê Anh Hào',N'Kiên Giang','0952566781','072204556781'),
('KH004','B0115',N'Trần An Nam',N'Vũng Tàu','0842346234','072312345643'),
('KH005','B0116',N'La Vân Hạnh',N'Hậu Giang','0982312456','072612367848'),
('KH006','B0116',N'Phùng Thảo Lan',N'Bình Thuận','0852346231','072334569871'),
('KH007','B0117',N'Hồ Thanh Bình',N'Tây Ninh','0829821345','072198723418'),
('KH008','B0118',N'Nguyễn Thịnh Mi',N'Ninh Thuận','0342344522','072987549876'),
('KH009','B0118',N'Nguyễn Thị Mi',N'Nghệ An','0352346781','072303002445'),
('KH0010','C0133',N'Trần Lan Anh',N'Đà Nẵng','0843219085','072312567642'),
('KH0011','C0134',N'Hoàng Văn Chiến',N'Phan Thiết','0387512345','072309871256'),
('KH0012','C0135',N'Lê Khánh Huyền',N'An Giang','0398712234','072123619876'),
('KH0013','C0136',N'Nguyễn Thảo Mi',N'Hà Nội','0357896543','072123569874'),
('KH0014','C0137',N'Trần Nguyễn An Nhiên',N'Đà Lạt','0987123765','072156802354'),
('KH0015','D0143',N'Dương Hoàng Lan',N'Hậu Giang','0398765123','072209813453'),
('KH0016','D0143',N'Hoàng Khánh Luân',N'Bình Phước','0871246798','072323457654'),
('KH0017','D0144',N'Lê Trần Khánh Băng',N'Long An','0398721654','072303213421'),
('KH0018','D0145',N'Đỗ Tấn Việt',N'Tây Ninh','0398912465','072123456754'),
('KH0019','D0147',N'Đặng An Hòa',N'Bình Dương','0345435678','072256749876'),
('KH0020','D0147',N'Nguyễn Hoàng Việt',N'Nam Định','0352346781','072303009874')
SELECT * FROM Khach

update Khach
set cccd_KH = '072303002225'
where ma_KH = 'KH009'

--Nhập Liệu Bảng Hợp Đồng-----
INSERT INTO HopDong(ma_HD,ma_KH,ma_nha,ma_nv,ngay_HD,tien_dat,gia_thue,tg_thue)
VALUES
('HD001','KH001','A0125','NV001','2022-02-01','2000000','3500000',N'1 Năm'),
('HD002','KH003','B0115','NV002','2022-02-11','2000000','3300000',N'1 Năm 6 tháng'),
('HD003','KH005','B0116','NV003','2022-05-8','2000000','3500000',N'2 Năm'),
('HD004','KH007','B0117','NV004','2023-05-1','1000000','3400000',N'1 Năm'),
('HD005','KH008','B0118','NV005','2022-08-8','2200000','3200000',N'2 Năm'),
('HD006','KH0010','C0133','NV006','2021-11-22','1200000','2800000',N'2 Năm 6 tháng'),
('HD007','KH0011','C0134','NV004','2023-04-12','1100000','2700000',N'2 Năm'),
('HD008','KH0012','C0135','NV008','2022-03-01','800000','2500000',N'1 Năm'),
('HD009','KH0013','C0136','NV009','2023-02-12','1000000','2200000',N'1 Năm 6 tháng'),
('HD0010','KH0014','C0137','NV001','2022-09-18','1200000','2000000',N'2 Năm 6 tháng'),
('HD0011','KH0015','D0143','NV006','2023-04-12','800000','1800000',N'1 Năm'),
('HD0012','KH0017','D0144','NV008','2022-05-21','1000000','2400000',N'1 Năm'),
('HD0013','KH0018','D0145','NV009','2022-04-12','1000000','2200000',N'1 Năm 6 tháng'),
('HD0014','KH0019','D0147','NV002','2023-04-12','1000000','2000000',N'1 Năm')

SELECT * FROM HopDong


---Nhập Liệu Bảng Phiếu Thu-----
INSERT INTO PhieuThu(so_phieu,ma_nv, ma_KH, ma_nha, ngay_thu, Tien_Dien_SD, Tien_Nuoc_SD, tien_Phong, tong_Tien)
VALUES
('001','NV001','KH001','A0125', '2023-12-22' ,'500000','280000','3500000','4330000'),
('002','NV002','KH003','B0115', '2023-12-22' ,'300000','100000','3300000','3700000'),
('003','NV003','KH005','B0116', '2023-12-22' ,'450000','72000','3500000','3707000'),
('004','NV004','KH007','B0117', '2023-12-22' ,'0','0','3400000','3400000'),
('005','NV005','KH008','B0118', '2023-12-22' ,'330000','66000','3200000','3596000'),
('006','NV006','KH0010','C0133', '2023-12-22' ,'280000','58000','2800000','3138000'),
('007','NV004','KH0011','C0134', '2023-12-22' ,'250000','100000','2700000','3050000'),
('008','NV008','KH0012','C0135', '2023-12-22' ,'250000','80000','2500000','2830000'),
('009','NV009','KH0013','C0136', '2023-12-22' ,'220000','82000','2200000','2502000'),
('0010','NV001','KH0014','C0137', '2023-12-22' ,'0','0','2000000','2000000'),
('0011','NV006','KH0015','D0143', '2023-12-22' ,'0','0','1800000','1800000'),
('0012','NV008','KH0017','D0144', '2023-12-22' ,'320000','770000','2400000','2797000'),
('0013','NV009','KH0018','D0145', '2023-12-22' ,'480000','220000','2200000','2900000'),
('0014','NV002','KH0019','D0147', '2023-12-22' ,'200000','78000','2000000','2278000')



SELECT * FROM PhieuThu

---Nhập Liệu Bảng Sự Cố-----
INSERT INTO SuCo(ma_suCo, ten_SC)
VALUES
('SC001',N'Gãy ống nước'),
('SC002',N'Bể gạch nhà bếp'),
('SC003',N'Đóng tiền trọ trễ quá 1/3 thời gian thuê'),
('SC004',N'Sử dụng vật phẩm gây cháy nổ'),
('SC005',N'Sử dụng hư máy lạnh'),
('SC006',N'Làm bể gạch nhà tắm'),
('SC007',N'Làm bể kính cửa số'),
('SC008',N'Không giữ gìn vệ sinh môi trường'),
('SC009',N'Làm hư thiết bị máy nước nóng lạnh')

SELECT * FROM SuCo
---Nhập Liệu Bảng Biên Bản Sự Cố-----
INSERT INTO BienBanSuCo(so_BBSC, ma_nha, ma_KH, ma_nv, ma_suCo, ngay_BB, ND_SuCo, tien_phat)
VALUES
('1','A0125','KH001','NV001','SC002','2023-05-22',N'Làm bể gạch khu vực nhà bếp của phòng trọ','200000'),
('2','C0136','KH0013','NV009','SC009','2023-04-28',N'Làm hư thiết bị máy nước nóng lạnh','500000'),
('3','B0116','KH005','NV003','SC006','2023-02-18',N'Làm bể gạch nhà tắm','200000'),
('4','B0118','KH008','NV005','SC008','2023-03-12',N'Không giữ gìn vệ sinh môi trường bị nhắc nhở quá 3 lần','200000'),
('5','D0147','KH0019','NV002','SC005','2023-02-10',N'Làm hư thiết bị máy lạnh','400000'),
('6','C0134','KH0011','NV004','SC001','2023-03-18',N'Làm gãy ống nước khu vực bếp','250000')

SELECT * FROM BienBanSuCo

---Nhập Liệu Bảng Hoá Đơn Bồi Thường-----
INSERT INTO HoaDon_BoiThuong(so_BBSC, ma_KH, ma_nv,ngay_thanhToan, ho_so_kem, tien_thanhToan)
VALUES
('1','KH001','NV001','2023-05-23',N'CCCD','200000'),
('2','KH0013','NV009','2023-04-29',N'CCCD','500000'),
('3','KH005','NV003','2023-02-19',N'CCCD','200000'),
('4','KH008','NV005','2023-03-12',N'CCCD','200000'),
('5','KH0019','NV002','2023-02-10',N'CCCD','400000'),
('6','KH0011','NV004','2023-03-18',N'CCCD','250000')

SELECT * FROM HoaDon_BoiThuong


-- tìm khách hàng có hóa đơn trên 3tr 


SELECT n.ma_nha, n.dia_chi, n.don_gia, b.ND_SuCo, b.tien_phat
FROM Nha n
JOIN BienBanSuCo b ON n.ma_nha = b.ma_nha


select K.ma_KH as N'Mã Khách Hàng', k.ma_nha as N'Mã Căn Hộ', K.ten_KH as N'Tên Khách Hàng', BBSC.ND_SuCo as N'Nội Dung', BBSC.tien_phat as N'Tiền Phạt' ,(PT.tong_Tien + BBSC.tien_phat) as N'Tổng tiền phải trả'
from Khach K
join PhieuThu PT on K.ma_KH = PT.ma_KH
join BienBanSuCo BBSC on K.ma_KH = BBSC.ma_KH
where PT.tong_Tien + BBSC.tien_phat > 1800000

--1-----tim khach hang que o Bình thuận có thời gian ở là 1 năm
SELECT Khach.ten_KH FROM Khach, HopDong
WHERE Khach.ma_KH = HopDong.ma_KH and (Khach.dia_chiLH = N'Bình Thuận' and HopDong.tg_thue = N'1 Năm')
--2-----tim nha co gia hơn 2 triệu
SELECT *
FROM Nha
WHERE don_gia > 2000000
--3-----Liệt kê bảng hợp đồng B
SELECT *
FROM HopDong
WHERE ma_nha LIKE N'B%'
--4-----Liệt kê chi tiết hợp đồng của nhân vien có mã NV002
SELECT * 
FROM HopDong
WHERE ma_nv = 'NV002'
--5-----Liệt kê các khách hàng có sự cố làm bể gạch nhà tắm
SELECT Khach.ten_KH
FROM Khach, BienBanSuCo
WHERE Khach.ma_KH = BienBanSuCo.ma_KH and BienBanSuCo.ND_SuCo = N'Làm bể gạch nhà tắm'
--6-----Liệt kê hóa đơn bồi thường các khách hàng có số tiền thanh toán trên 200000
SELECT *
FROM HoaDon_BoiThuong
WHERE tien_thanhToan > 200000

--7---Thêm Dữ Liệu---
INSERT INTO Nha(ma_nha,dia_chi,dien_tich,tien_ich,don_gia, trang_thai)
VALUES('A0348',N'405/25 Trường Chinh,Phường 14,Tân Bình,TPHCM','30.2',N'Máy Lạnh,Wifi,Tủ Lạnh,Điện nước Nóng lạnh','4500000',N'Đã Thuê')

INSERT INTO HoaDon_BoiThuong(so_BBSC, ma_KH, ma_nv,ngay_thanhToan, ho_so_kem, tien_thanhToan)
VALUES('7','KH0011','NV002','2023-03-16',N'CCCD','250000')

--Xóa Dữ Liệu--
DELETE FROM Khach
WHERE ma_KH = 'KH009'
SELECT* FROM KHACH

DELETE FROM BienBanSuCo
WHERE ma_suCo = 'SC008'

---UPDATE ---
UPDATE NhanVien
	SET ten_nv = N'Nguyễn Lan Anh'
	wHERE ma_nv = 'NV002'

SELECT * FROM NhanVien

UPDATE HopDong
	SET ma_nha = 'A0198'
	WHERE ma_nv = 'NV008'

SELECT * FROM HopDong


--8Phòng trọ có giá tiền thuê nhỏ nhất
SELECT * FROM NHA
WHERE don_gia <= ALL(SELECT MIN(don_gia) FROM NHA)

--7.Cho biết thông tin nhân viên giới thiệu được từ 2 phòng trọ trở lên và trạng thái đã thuê
SELECT ten_nv AS N'Nhân Viên', NhanVien.ma_nv AS N'Mã Nhân Viên',dia_chi AS N'Địa Chỉ',cccd_nv AS N'CCCD',dia_chi AS N'Địa Chỉ',COUNT(HOPDONG.ma_nha) AS N'Số lượng nhà trọ'
FROM NhanVien,HopDong,Nha
WHERE NhanVien.ma_nv = HopDong.ma_nv AND NHA.ma_nha = HopDong.ma_nha AND trang_thai = N'Đã Thuê'
GROUP BY ten_nv,dia_chi,NhanVien.ma_nv,cccd_nv,dia_chi
HAVING COUNT(HopDong.ma_nha) >=2