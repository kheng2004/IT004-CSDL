USE QUANLIGIAOVU_0208
--I. Ngôn ng? ??nh ngh?a d? li?u (Data Definition Language):
--1. T?o quan h? và khai báo t?t c? các ràng bu?c khóa chính, khóa ngo?i. Thêm vào 3 thu?c tính GHICHU, DIEMTB, XEPLOAI cho quan h? HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(10)
ALTER TABLE HOCVIEN ADD DIEMTB FLOAT
ALTER TABLE HOCVIEN ADD XEPLOAI VARCHAR(10)

--2. Mã h?c viên là m?t chu?i 5 ký t?, 3 ký t? ??u là mã l?p, 2 ký t? cu?i cùng là s? th? t? h?c viên trong l?p. VD: “K1101”
--skip question 2
--3. Thu?c tính GIOITINH ch? có giá tr? là “Nam” ho?c “Nu”.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHECK_GTINH CHECK(GIOITINH IN ('Nam', 'Nu'))
--4. ?i?m s? c?a m?t l?n thi có giá tr? t? 0 ??n 10 và c?n l?u ??n 2 s? l? (VD: 6.22).
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_DIEM CHECK (DIEM BETWEEN 0 AND 10)
--5. K?t qu? thi là “Dat” n?u ?i?m t? 5 ??n 10 và “Khong dat” n?u ?i?m nh? h?n 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_KQ CHECK ((KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10) OR (KQUA = 'Khong dat' and DIEM < 5))
--6. H?c viên thi m?t môn t?i ?a 3 l?n.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_LANTHI CHECK (LANTHI <=3)
--7. H?c k? ch? có giá tr? t? 1 ??n 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CHECK_HK CHECK (HOCKY BETWEEN 1 AND 3)
--8. H?c v? c?a giáo viên ch? có th? là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))
--11. H?c viên ít nh?t là 18 tu?i.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHECK_TUOI CHECK(2023 - YEAR(NGSINH) >= 18)
--12. Gi?ng d?y m?t môn h?c ngày b?t ??u (TUNGAY) ph?i nh? h?n ngày k?t thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CHECK_NGAY CHECK (TUNGAY < DENNGAY)
--13. Giáo viên khi vào làm ít nh?t là 22 tu?i.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_TUOI CHECK (2023 - YEAR(NGSINH) >= 22)
--14. T?t c? các môn h?c ??u có s? tín ch? lý thuy?t và tín ch? th?c hành chênh l?ch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CHECK_TINCHI CHECK (ABS(TCLT - TCTH) <= 3)

--II. Ngôn ng? thao tác d? li?u (Data Manipulation Language):
--1. T?ng h? s? l??ng thêm 0.2 cho nh?ng giáo viên là tr??ng khoa.
UPDATE GIAOVIEN SET HESO = HESO * 1.2 
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA)
--2. Cập nhật giá trị điểm trung bình tất cả các môn học  (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng)
UPDATE HOCVIEN
SET DIEMTB = 
(
    SELECT AVG(DIEM)
    FROM 
	(
        SELECT MAHV, MAMH, DIEM
        FROM KETQUATHI AS K1
        WHERE LANTHI = 
		(
            SELECT MAX(LANTHI)
            FROM KETQUATHI AS K2
            WHERE K2.MAHV = K1.MAHV AND K2.MAMH = K1.MAMH
		)
    ) AS KQ
    WHERE KQ.MAHV = HOCVIEN.MAHV
)


--3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm. 
UPDATE HOCVIEN SET GHICHU = 'Cam thi'
WHERE MAHV IN
(
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = 3 AND DIEM < 5
)
--4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau: 
/*o Nếu DIEMTB >= 9 thì XEPLOAI =”XS” 
o Nếu  8 <= DIEMTB < 9 thì XEPLOAI = “G” 
o Nếu  6.5 <= DIEMTB < 8 thì XEPLOAI = “K” 
o Nếu  5  <=  DIEMTB < 6.5 thì XEPLOAI = “TB” 
o Nếu  DIEMTB < 5 thì XEPLOAI = ”Y” 
*/
UPDATE HOCVIEN
SET XEPLOAI = 
    CASE
        WHEN DIEMTB >= 9 THEN 'XS'
        WHEN DIEMTB >= 8 THEN 'G'
        WHEN DIEMTB >= 6.5 THEN 'K'
        WHEN DIEMTB >= 5 THEN 'TB'
        ELSE 'Y'
    END
--III. Ngôn ngữ truy vấn dữ liệu
--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, MALOP
FROM HOCVIEN
WHERE MAHV IN
(
	SELECT TRGLOP
	FROM LOP
)
--2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp  theo tên, họ học viên. 
SELECT HOCVIEN.MAHV, HO, TEN, LANTHI, DIEM
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV AND HOCVIEN.MALOP ='K12' AND MAMH = 'CTRR'
ORDER BY TEN, HO

--3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MAHV IN
(
	SELECT MAHV
	FROM KETQUATHI
	WHERE KQUA = 'Dat' and LANTHI = 1
)
--4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1). 
SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MALOP = 'K11' AND MAHV IN
(
	SELECT MAHV
	FROM KETQUATHI
	WHERE MAMH = 'CTRR' AND KQUA = 'Khong dat' AND LANTHI = 1
)

--5.  Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT DISTINCT HOCVIEN.MAHV, HO, TEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV AND MALOP LIKE 'K%' AND MAMH = 'CTRR' AND NOT EXISTS
(
	SELECT* FROM KETQUATHI AS KQ
	WHERE MAMH = 'CTRR' AND KQUA = 'Dat' AND HOCVIEN.MAHV = KQ.MAHV
)
--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006. 
SELECT TENMH
FROM MONHOC
WHERE MAMH IN
(
SELECT Distinct MAMH
FROM GIANGDAY, GIAOVIEN
WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV AND HOCKY = 1 AND NAM = 2006 AND HOTEN = 'Tran Tam Thanh'
)
--7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT DISTINCT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN
(
	SELECT MAMH
	FROM GIANGDAY
	WHERE HOCKY = 1 AND NAM = 2006 AND MAGV IN
	(
		SELECT MAGVCN
		FROM LOP
		WHERE MALOP = 'K11'
	)
)
--8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”
SELECT HO, TEN
FROM HOCVIEN
WHERE MAHV IN
(
	SELECT TRGLOP
	FROM LOP
	WHERE MAGVCN IN
	(
		SELECT GIAOVIEN.MAGV
		FROM GIAOVIEN, GIANGDAY
		WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV AND HOTEN = 'Nguyen To Lan' AND MAMH = 
		(
			SELECT DISTINCT MAMH FROM MONHOC WHERE TENMH ='Co So Du Lieu'
		)
	)
)
--9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN
(
	SELECT MAMH_TRUOC FROM DIEUKIEN WHERE MAMH =
	(SELECT MAMH FROM MONHOC WHERE TENMH ='Co So Du Lieu')
)

--10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào. 
SELECT MAMH, TENMH 
FROM MONHOC
WHERE MAMH IN
(
	SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC =
	(SELECT MAMH FROM MONHOC WHERE TENMH = 'Cau Truc Roi Rac')
)
--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006. 
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV =
(
	SELECT MAGV
	FROM GIANGDAY
	WHERE HOCKY = 1 AND NAM = 2006 AND MALOP ='K11' AND MAMH = 'CTRR'
	INTERSECT
	SELECT MAGV
	FROM GIANGDAY
	WHERE HOCKY = 1 AND NAM = 2006 AND MALOP ='K12' AND MAMH = 'CTRR'
)
--12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.

SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MAHV IN
(
	SELECT MAHV
	FROM KETQUATHI KQ
	WHERE KQ.LANTHI = 1 AND KQ.MAMH = 'CSDL' AND KQ.KQUA = 'Khong dat' AND NOT EXISTS
	(
		SELECT *
		FROM KETQUATHI KQ1
		WHERE KQ1.MAMH ='CSDL' AND KQ1.LANTHI > 1 AND KQ.MAHV = KQ1.MAHV
	)
)

--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào. 
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN
(
	SELECT MAGV
	FROM GIANGDAY
)

--14.Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT A.MAGV, A.HOTEN
FROM GIAOVIEN A
WHERE A.MAGV NOT IN
(
	SELECT MAGV
	FROM GIANGDAY
	WHERE MAMH IN
	(
		SELECT MAMH
		FROM MONHOC
		WHERE MONHOC.MAKHOA = A.MAKHOA 
	)
)
--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO, TEN
FROM HOCVIEN
WHERE MALOP = 'K11' AND MAHV IN
(
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = 2 AND MAMH = 'CTRR' AND DIEM = 5

	UNION 
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = 3 AND KQUA = 'Khong dat'

)
--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN
(
SELECT MAGV
FROM GIANGDAY
WHERE MAMH = 'CTRR' 
GROUP BY HOCKY, NAM, MAGV
HAVING COUNT(MALOP)>=2
)


--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, DIEM
FROM HOCVIEN INNER JOIN 
(
    SELECT MAHV, MAMH, DIEM, MAX(LANTHI) AS 'Lan thi gan nhat'
    FROM KETQUATHI
    WHERE MAMH = 'CSDL'
    GROUP BY MAHV, MAMH, DIEM
) AS LanThiGanNhat
ON HOCVIEN.MAHV = LanThiGanNhat.MAHV
ORDER BY HOCVIEN.MAHV

--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, MAX(KETQUATHI.DIEM) AS 'Diem cao nhat'
FROM HOCVIEN, KETQUATHI, MONHOC
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV AND KETQUATHI.MAMH = MONHOC.MAMH
AND MONHOC.TENMH = 'Co So Du Lieu'
GROUP BY  HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN

--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT TOP 1 KHOA.MAKHOA, KHOA.TENKHOA
FROM KHOA
GROUP BY KHOA.MAKHOA, KHOA.TENKHOA, KHOA.NGTLAP
ORDER BY KHOA.NGTLAP

--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(GIAOVIEN.MAGV) AS 'So luong giao vien'
FROM GIAOVIEN
GROUP BY GIAOVIEN.HOCHAM
HAVING GIAOVIEN.HOCHAM = 'GS' OR GIAOVIEN.HOCHAM = 'PGS'

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT KHOA.MAKHOA, KHOA.TENKHOA,
SUM(CASE WHEN GIAOVIEN.HOCVI = 'CN' THEN 1 ELSE 0 END) AS 'CN',
SUM(CASE WHEN GIAOVIEN.HOCVI = 'KS' THEN 1 ELSE 0 END) AS 'KS',
SUM(CASE WHEN GIAOVIEN.HOCVI = 'ThS' THEN 1 ELSE 0 END) AS 'ThS',
SUM(CASE WHEN GIAOVIEN.HOCVI = 'TS' THEN 1 ELSE 0 END) AS 'TS',
SUM(CASE WHEN GIAOVIEN.HOCVI = 'PTS' THEN 1 ELSE 0 END) AS 'PTS'
FROM KHOA LEFT OUTER JOIN GIAOVIEN
ON KHOA.MAKHOA = GIAOVIEN.MAKHOA
GROUP BY KHOA.MAKHOA, KHOA.TENKHOA
--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MONHOC.TENMH, 
SUM(CASE WHEN KETQUATHI.KQUA = 'Dat' THEN 1 ELSE 0 END) AS 'Dat', 
SUM(CASE WHEN KETQUATHI.KQUA = 'Khong dat' THEN 1 ELSE 0 END) AS 'Khong dat'
FROM MONHOC LEFT OUTER JOIN KETQUATHI
ON MONHOC.MAMH = KETQUATHI.MAMH
GROUP BY MONHOC.MAMH, MONHOC.TENMH

-- III.23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN, LOP, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV AND LOP.MALOP = GIANGDAY.MALOP
GROUP BY GIAOVIEN.MAGV, GIAOVIEN.HOTEN
HAVING COUNT(DISTINCT GIANGDAY.MAMH) >= 1

-- III.24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN INNER JOIN LOP
ON HOCVIEN.MALOP = LOP.MALOP
WHERE LOP.SISO = 
(
	SELECT MAX(SISO) FROM LOP
)
AND HOCVIEN.MAHV = LOP.TRGLOP