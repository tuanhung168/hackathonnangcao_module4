create database svdh2;
use svdh2;

create table dmkhoa(
Makhoa nvarchar(20) primary key ,
TenKhoa nvarchar(255)
);

create table dmnganh(
MaNganh int primary key auto_increment,
TenNganh nvarchar(255),
MaKhoa nvarchar(20),
foreign key (Makhoa) references dmkhoa(Makhoa)
);

create table dmlop(
Malop nvarchar(20) primary key ,
Tenlop nvarchar(255),
MaNganh int,
KhoaHoc int,
HeDT nvarchar(255),
NamNhapHoc int,
foreign key (MaNganh) references dmnganh(MaNganh)
);

create table dmhocphan(
MaHp int primary key auto_increment,
TenHp nvarchar(255),
Sodvht int,
MaNganh int,
HocKy int,
foreign key (MaNganh) references dmnganh(MaNganh)
);

create table sinhvien(
MaSV int primary key auto_increment,
HoTen nvarchar(255),
Malop nvarchar(20),
GioiTinh tinyint(1),
NgaySinh date,
Diachi nvarchar(255)
);

create table diemhp(
masv int,
mahp int,
diemhp float,
foreign key (masv) references sinhvien(masv),
foreign key (mahp) references dmhocphan(mahp)
);



-- Thêm dữ liệu vào bảng dmkhoa 
insert into dmkhoa (Makhoa, TenKhoa) 
values
	('CNTT','Công Nghệ Thông Tin'),
    ('KT','Kế Toán'),
    ('SP','Sư Phạm');

-- thêm dữ liệu vào bảng dmnganh
insert into dmnganh (MaNganh, TenNganh, MaKhoa)
values
	(140902,'Sư phạm toán tin','SP'),
    (480202,'Tin học ứng dụng','CNTT');
    
-- thêm dữ liệu vào bảng dmlop
insert into dmlop (MaLop, TenLop, MaNganh, KhoaHoc, HeDT, NamNhapHoc)
values 
	('CT11','Cao đẳng tin học',480202,11,'TC',2013),
	('CT12','Cao đẳng tin học',480202,12,'CĐ',2013),
	('CT13','Cao đẳng tin học',480202,13,'TC',2014);
    
-- thêm dữ liệu vào bảng dmhocphan
insert into dmhocphan (MaHP, TenHP, Sodvht, Manganh, HocKy)
values 
	(1,'Toán cao cấp A1',4,480202,1),
	(2,'Tiếng Anh 1',3,480202,1),
	(3,'Vật lý đại cương',4,480202,1),
	(4,'Tiếng Anh 2',7,480202,1),
	(5,'Tiếng Anh 1',3,140902,2),
	(6,'Xác suất thống kê',3,480202,2);
    
-- thêm dữ liệu vào bảng sinhvien
insert into sinhvien (MaSV, HoTen, MaLop, GioiTinh, NgaySinh, DiaChi)
values
	(1,'Phan Thanh','CT12',0,'1990-09-12','Tuy Phước'),
	(2,'Nguyễn Thị Cẩm','CT12',1,'1990-01-12','Quy Nhơn'),
	(3,'Võ Thị Hà','CT12',1,'1990-07-02','An Nhơn'),
	(4,'Trần Hoài Nam','CT12',0,'1990-04-05','Tây Sơn'),
	(5,'Trần Văn Hoàng','CT13',0,'1990-08-04','Vĩnh Thạnh'),
	(6,'Đặng Thị Thảo','CT13',1,'1990-06-12','Quy Nhơn'),
	(7,'Lê Thị Sen','CT13',1,'1990-08-12','Phú Mỹ'),
	(8,'Nguyễn Văn Huy','CT11',0,'1990-06-04','Tuy Phước'),
	(9,'Trần Thị Hoa','CT11',1,'1990-08-09','Hoài Nhơn');
    
-- thêm dữ liệu vào bảng diemhp
insert into diemhp value 
(2,2,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4.0),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4.0),
(7,1,6.2);

-- 1. Cho biết họ tên sinh viên KHÔNG học học phần nào (5đ)
select sv.MaSV,sv.HoTen
from sinhvien sv
left join diemhp dh on sv.MaSV = dh.MaSV
where dh.MaSV is null;

-- 2. Cho biết họ tên sinh viên CHƯA học học phần nào có mã 1 (5đ)
select sv.MaSV,sv.HoTen
from sinhvien sv
left join diemhp dh on sv.MaSV = dh.MaSV and dh.MaHP = 1
where dh.MaHP is null;

-- 3. Cho biết Tên học phần KHÔNG có sinh viên điểm HP <5. (5đ)
select MaHp,TenHp from dmhocphan where mahp not in(select mahp from diemhp where diemhp < 5);

-- 4. Cho biết Họ tên sinh viên KHÔNG có học phần điểm HP<5 (5đ)
select maSv,hoten from sinhvien where masv not in(select masv from diemhp where diemhp<5);

-- 5. Cho biết Tên lớp có sinh viên tên Hoa (5đ)
select TenLop from dmlop where Malop in (select Malop from sinhvien where HoTen like '%Hoa%');

-- 6. Cho biết HoTen sinh viên có điểm học phần 1 là <5.
select HoTen from sinhvien where MaSV in (select masv from diemhp where MaHP = 1 and DiemHP < 5);

-- 7. Cho biết danh sách các học phần có số đơn vị học trình lớn hơn hoặc bằng số đơn vị học trình của học phần mã 1.
select MaHP,TenHP,Sodvht,MaNganh,HocKy from dmhocphan where Sodvht >= (select Sodvht from dmhocphan where MaHP = 1);

-- 8. Cho biết HoTen sinh viên có DiemHP cao nhất. (ALL)
select sv.masv, sv.hoten, diemhp.mahp, diemhp.diemhp from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all(select diemhp.diemhp from diemhp);

-- 9. Cho biết MaSV, HoTen sinh viên có điểm học phần mã 1 cao nhất. (ALL)
select sv.masv, sv.hoten from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all(select max(diemhp.diemhp) from diemhp where diemhp.mahp = 1);

-- 10. Cho biết MaSV, MaHP có điểm HP lớn hơn bất kì các điểm HP của sinh viên mã 3 (ANY).
select distinct sv.masv, diemhp.mahp
from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp > any (
    select diemhp.diemhp
    from sinhvien sv
    join diemhp on diemhp.masv = sv.masv
    where sv.masv = 3
);

-- 11. Cho biết MaSV, HoTen sinh viên ít nhất một lần học học phần nào đó. (EXISTS)
select sv.masv, sv.hoten
from sinhvien sv
where exists (
    select 1
    from diemhp dh
    where dh.masv = sv.masv
);

-- 12. Cho biết MaSV, HoTen sinh viên đã không học học phần nào. (EXISTS)
select sv.masv, sv.hoten from sinhvien sv
where not exists (
select 1 from diemhp
where diemhp.masv = sv.masv
);

-- 13. Cho biết MaSV đã học ít nhất một trong hai học phần có mã 1, 2.
select masv
from diemhp
where mahp = 1
union
select masv
from diemhp
where mahp = 2;

-- 14. Tạo thủ tục có tên KIEM_TRA_LOP cho biết HoTen sinh viên KHÔNG có điểm HP <5 ở lớp có mã chỉ định (tức là tham số truyền vào procedure là mã lớp). Phải kiểm tra MaLop chỉ định có trong danh mục hay không, nếu không thì hiển thị thông báo ‘Lớp này không có trong danh mục’. Khi lớp tồn tại thì đưa ra kết quả.
-- Ví dụ gọi thủ tục: Call KIEM_TRA_LOP(‘CT12’).
DELIMITER //
CREATE PROCEDURE KIEM_TRA_LOP(IN MaLopParam NVARCHAR(20))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dmlop WHERE Malop = MaLopParam) THEN
        SELECT 'Lớp này không có trong danh mục' AS ThongBao;
    ELSE
        SELECT sv.HoTen
        FROM sinhvien sv
        JOIN diemhp dh ON sv.MaSV = dh.MaSV
        WHERE sv.Malop = MaLopParam AND dh.DiemHP < 5;
    END IF;
END //
DELIMITER ;
CALL KIEM_TRA_LOP('CT12');

-- 15 --
DELIMITER //
CREATE TRIGGER trigger_kiem_tra_masv
BEFORE INSERT ON sinhvien
FOR EACH ROW
BEGIN
    IF NEW.masv IS NULL OR NEW.masv = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mã sinh viên phải được nhập';
    END IF;
END //
DELIMITER ;















