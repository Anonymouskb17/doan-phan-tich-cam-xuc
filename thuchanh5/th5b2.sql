create database th5b2


create table NHAXUATBAN(
     maNXB varchar(10) not null primary key,
	 tenNXB nvarchar(30),
	 diachi nvarchar(20)
)

create table THELOAISACH(
     maTheLoai varchar(10) not null primary key,
	 tenloai nvarchar(30),
	 ngonngu nvarchar(20)
)

create table DAUSACH(
    maDS varchar(10) not null primary key,
	maNXB varchar(10),
	maTheLoai varchar(10),
	tens nvarchar(30),
	namxb date,
	tacgia nvarchar(30),
	soluong int,
	foreign key (maNXB) references NHAXUATBAN(maNXB),
	foreign key (maTheLoai) references THELOAISACH(maTheLoai)
)


insert into NHAXUATBAN values
('NXB01',N'Nhà xuất bản Hội nhà văn',N'Hà Nội'),
('NXB02',N'Nhà xuất bản Hồ Chỉ Minh',N'Hồ Chỉ Minh'),
('NXB03',N'Nhà xuất bản Thanh Niên',N'Hà Nội'),
('NXB04',N'Nhà xuất bản Nhi Đồng',N'Hà Nội');

insert into THELOAISACH values
('TL01',N'Báo',N'Tiếng Hàn'),
('TL02',N'Thơ',N'Tiếng Nga'),
('TL03',N'Tiểu thuyết',N'Tiếng Pháp'),
('TL04',N'Kịch',N'Tiếng Anh');

insert into DAUSACH values 
('DS01','NXB01','TL01',N'Số đỏ','2001',N'Vũ Trọng Phụng',10),
('DS02','NXB01','TL01',N'Người ăn chay','2025',N'Han Kang',10),
('DS03','NXB02','TL02',N'Đất vỡ hoang','2000',N'Mikhail Sholokhov',9),
('DS04','NXB03','TL03',N'Những người khốn khổ','1899',N'Victor Hugo',4),
('DS05','NXB04','TL04',N'Hamlet','1688',N'William Shakespeare',3);

select maDS, tens from DAUSACH where tacgia= N'Vũ Trọng Phụng';
select tenNXB from NHAXUATBAN where diachi = N'Hà Nội';
select tens from THELOAISACH, DAUSACH where THELOAISACH.ngonngu = N'Tiếng Nga' and THELOAISACH.maTheLoai = DAUSACH.maTheLoai;
select maDS from DAUSACH, THELOAISACH where DAUSACH.maNXB = 'NXB01'and DAUSACH.maTheLoai = THELOAISACH.maTheLoai   and THELOAISACH.ngonngu = N'Tiếng Hàn';
select maDS from DAUSACH, THELOAISACH where DAUSACH.maNXB = 'NXB01'and DAUSACH.maTheLoai = THELOAISACH.maTheLoai   and THELOAISACH.ngonngu = N'Tiếng Hàn' and DAUSACH.namxb= '2025';
select tenNXB from NHAXUATBAN where maNXB in (select DS1.maNXB from DAUSACH DS1, DAUSACH DS2 where DS1.tens = N'Số đỏ' and DS2.tens = N'Đất vỡ hoang' and DS1.maNXB = DS2.maNXB);
select DS.tens from DAUSACH DS, NHAXUATBAN NXB, THELOAISACH TL where DS.maNXB = NXB.maNXB and DS.maTheLoai = TL.maTheLoai and NXB.tenNXB = N'Nhà xuất bản Hội nhà văn' and TL.ngonngu = N'Tiếng Nga';
select NXB.tenNXB from NHAXUATBAN NXB, DAUSACH DS, THELOAISACH TL where DS.maNXB = NXB.maNXB and DS.maTheLoai = TL.maTheLoai and TL.ngonngu = N'Tiếng Pháp' group by NXB.tenNXB;
select NXB.tenNXB from NHAXUATBAN NXB where NXB.maNXB in (
    select DS.maNXB
    from DAUSACH DS, THELOAISACH TL
    where DS.maTheLoai = TL.maTheLoai
      and TL.ngonngu = N'Tiếng Pháp'
    group by DS.maNXB
)
and NXB.maNXB not in (
    select DS.maNXB
    from DAUSACH DS, THELOAISACH TL
    where DS.maTheLoai = TL.maTheLoai
      and TL.ngonngu = N'Tiếng Anh'
    group by DS.maNXB
);



