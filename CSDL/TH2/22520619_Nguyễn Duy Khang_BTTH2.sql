USE QLBH_2020
--BAI I
-- CAU2 Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
ALTER TABLE SANPHAM add GHICHU varchar(20) 

-- CAU3 Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG add LOAIKH TINYINT

-- CAU4 Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100)

-- CAU5 Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU 

--Cau6 Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20) 

-- cau7 Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM ADD CONSTRAINT check_DVT CHECK (DVT in ('cay', 'hop', 'cai', 'quyen', 'chuc'))

-- cau8 Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM ADD CHECK (GIA >= 500) 

-- CAU9 Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD ADD CHECK (SL > 0 ) 

 --CAU10 Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó
ALTER TABLE KHACHHANG ADD CHECK (NGDK > NGSINH)

-- BAI II
--CAU2 Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT * INTO KHACHHANG_1 FROM KHACHHANG 
SELECT * INTO SANPHAM_1 FROM SANPHAM 

--CAU3 Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM_1 SET GIA=GIA+(GIA*5/100) WHERE NUOCSX='Thai Lan' 

--Cau4 Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM_1 SET GIA=GIA-(GIA*5/100) WHERE NUOCSX='Trung Quoc' AND GIA<=10000 

/*CAU5 Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước
ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ
1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).*/
UPDATE KHACHHANG_1 SET LOAIKH = 'Vip'  WHERE ((NGDK < '2007/01/01' AND DOANHSO >= 10000000) OR (NGDK >= '2007/01/01' AND DOANHSO >2000000)) 

-- BAI III
-- CAU1 In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX='Trung Quoc' 

-- CAU2 In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP,TENSP FROM SANPHAM WHERE DVT='cay' OR DVT='quyen' 

-- CAU3 In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP,TENSP FROM SANPHAM WHERE MASP LIKE'B%01' 

-- CAU4 In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX='Trung Quoc' AND GIA BETWEEN 30000 AND 40000 

-- CAU5 In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP,TENSP FROM SANPHAM WHERE (NUOCSX='Trung Quoc' OR NUOCSX='Thai Lan') AND GIA BETWEEN 30000 AND 40000

-- CAU6 In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD,TRIGIA FROM HOADON WHERE NGHD='2007/1/1' OR NGHD='2007/1/2'  

-- CAU7 In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD,TRIGIA FROM HOADON WHERE YEAR (NGHD)=2007 AND MONTH (NGHD)=1 ORDER BY NGHD ASC, TRIGIA DESC 

-- CAU8 In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, HOTEN FROM KHACHHANG  INNER JOIN HOADON  ON KHACHHANG.MAKH = HOADON.MAKH WHERE NGHD = '2007/01/01'

-- CAU9 In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT SOHD, TRIGIA FROM HOADON INNER JOIN NHANVIEN ON HOADON.MANV = NHANVIEN.MANV WHERE HOTEN = 'Nguyen Van B' and NGHD = '2006/10/28' 

-- CAU10 In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT SANPHAM.MASP, TENSP FROM SANPHAM 
INNER JOIN CTHD ON SANPHAM.MASP = CTHD.MASP 
INNER JOIN HOADON ON HOADON.SOHD = CTHD.SOHD 
INNER JOIN KHACHHANG ON KHACHHANG.MAKH = HOADON.MAKH 
WHERE HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
--CACH2
SELECT MASP, TENSP
FROM SANPHAM, CTHD, KHACHHANG
WHERE SANPHAM.MASP = CTHD.MASP  AND HOADON.SOHD = CTHD.SOHD AND KHACHHANG.MAKH = HOADON.MAKH 
AND HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006

-- CAU11 Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”. 
SELECT SOHD FROM CTHD WHERE MASP = 'BB01'
UNION 
SELECT SOHD FROM CTHD WHERE MASP = 'BB02'

 -- CAU12 Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20. 
SELECT SOHD FROM CTHD WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
UNION
SELECT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

 -- CAU13 Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20. - 
SELECT SOHD FROM CTHD WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

 -- CAU 14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT SANPHAM.MASP, TENSP FROM SANPHAM, CTHD, HOADON WHERE SANPHAM.MASP = CTHD.MASP AND CTHD.SOHD = HOADON.SOHD  AND NGHD = '2007/01/01'
 
 -- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được
SELECT MASP, TENSP FROM SANPHAM
EXCEPT
SELECT SANPHAM.MASP, TENSP FROM SANPHAM,CTHD, HOADON
WHERE SANPHAM.MASP = CTHD.MASP AND CTHD.SOHD = HOADON.SOHD

 --16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
 SELECT MASP, TENSP FROM SANPHAM
 EXCEPT
 SELECT SANPHAM.MASP, TENSP FROM SANPHAM,CTHD, HOADON
 WHERE SANPHAM.MASP = CTHD.MASP AND CTHD.SOHD = HOADON.SOHD AND NGHD = 2006

 --17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
EXCEPT 
SELECT SANPHAM.MASP, TENSP FROM SANPHAM,CTHD, HOADON
WHERE SANPHAM.MASP = CTHD.MASP AND CTHD.SOHD = HOADON.SOHD AND YEAR(NGHD) = 2006

 --18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT distinct SOHD FROM CTHD CT1
WHERE NOT EXISTS
(
	(SELECT MASP FROM SANPHAM WHERE NUOCSX = 'Singapore')
	EXCEPT
	(SELECT MASP FROM CTHD CT2 WHERE CT1.SOHD = CT2.SOHD)
)
--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT SOHD
FROM HOADON
WHERE year(NGHD)=2006
and NOT EXISTS
(
    SELECT *
    FROM SANPHAM
    WHERE NUOCSX = 'Singapore' and MASP NOT IN
    (
        SELECT masp 
        FROM CTHD 
        WHERE SOHD = HOADON.SOHD
    )
)

