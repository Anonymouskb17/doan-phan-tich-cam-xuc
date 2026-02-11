create database bth5

create table CANBO(
    maCanBo varchar(5) not null primary key,
	hoTen nvarchar(20),
	gioiTinh char(5),
	ngaySinh datetime,
	queQuan nvarchar(30),
	maDonvi varchar(5),
	foreign key (maDonvi) references DONVI(maDonvi),
)

create table DONVI(
    maDonvi varchar(5) not null primary key,
	tenDonvi nvarchar(20),
	truongDonvi varchar(5)
)

create table NGOAINGU(
    tenNgoaiNgu nvarchar(20) not null primary key,
    maCanBo varchar(5),
	foreign key (maCanBo) references CANBO,
	trinhDo varchar(10)
)

drop table NGOAINGU
drop table CANBO
drop table DONVI

insert into DONVI (maDonvi, tenDonvi, truongDonvi) values
('P1', N'Phòng Hành chính', 'NV01'),
('P2', N'Phòng Tổ chức', 'NV03'),
('P3', N'Phòng Nhân sự', 'NV05');


insert into CANBO (maCanBo, hoTen, gioiTinh, ngaySinh, queQuan, maDonvi) values
('CB01', N'Nguyễn Văn A', 'Nam', '1980-05-12', N'Hà Nội', 'P1'),
('CB02', N'Trần Thị B', 'Nữ', '1985-08-20', N'Hải Phòng', 'P1'),
('CB03', N'Lê Văn C', 'Nam', '1978-03-15', N'Nam Định', 'P2'),
('CB04', N'Phạm Thị D', 'Nữ', '1990-11-30', N'Thái Bình', 'P2'),
('CB05', N'Hoàng Văn F', 'Nam', '1998-01-25', N'Hà Giang', 'P3');


insert into NGOAINGU (tenNgoaiNgu, maCanBo, trinhDo) values
(N'Tiếng Anh', 'CB01', 'B2'),
(N'Tiếng Pháp', 'CB02', 'A2'),
(N'Tiếng Trung', 'CB03', 'B1'),
(N'Tiếng Nhật', 'CB04', 'N3');


select hoTen,maCanBo from CANBO where gioiTinh ='Nam' and queQuan= N'Hà Giang'
select tenNgoaiNgu from NGOAINGU
select hoTen from CANBO, DONVI where DONVI.maDonvi= 'P1' and CANBO.maDonvi = DONVI.maDonvi
select tenDonvi from CANBO, DONVI where CANBO.maCanBo = 'CB05' and CANBO.maDonvi = DONVI.maDonvi
select hoTen from CANBO, DONVI where tenDonvi = N'Phòng Tổ chức' and CANBO.maDonvi = DONVI.maDonvi


	

