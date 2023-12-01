--I. Ngôn ng? ??nh ngh?a d? li?u (Data Definition Language):
--1. T?o quan h? và khai báo t?t c? các ràng bu?c khóa chính, khóa ngo?i. Thêm vào 3 thu?c tính GHICHU, DIEMTB, XEPLOAI cho quan h? HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR
ALTER TABLE HOCVIEN ADD DIEMTB FLOAT
ALTER TABLE HOCVIEN ADD XEPLOAI TINYINT
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
--8. H?c v? c?a giáo viên ch? có th? là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))--11. H?c viên ít nh?t là 18 tu?i.
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
--2. C?p nh?t giá tr? ?i?m trung bình t?t c? các môn h?c (DIEMTB) c?a m?i h?c viên (t?t c? các môn h?c ??u có h? s? 1 và n?u h?c viên thi m?t môn nhi?u l?n, ch? l?y ?i?m c?a l?n thi sau cùng).
UPDATE HOCVIEN SET DIEMTB =
(
	SELECT AVG(DIEM)
	FROM KETQUATHI
	WHERE MAHV = KETQUATHI.MAHV AND LANTHI =
	(
		SELECT MAX(LANTHI)
		FROM KETQUATHI KQ
		WHERE KQ.MAHV = KETQUATHI.MAHV
		GROUP BY KQ.MAHV
	)
	GROUP BY MAHV
)
--3. C?p nh?t giá tr? cho c?t GHICHU là “Cam thi” ??i v?i tr??ng h?p: h?c viên có m?t môn b?t k? thi l?n th? 3 d??i 5 ?i?m.
--4. C?p nh?t giá tr? cho c?t XEPLOAI trong quan h? HOCVIEN nh? sau:
--N?u DIEMTB ? 9 thì XEPLOAI =”XS”
--N?u 8 ? DIEMTB < 9 thì XEPLOAI = “G”
--N?u 6.5 ? DIEMTB < 8 thì XEPLOAI = “K”
--N?u 5 ? DIEMTB < 6.5 thì XEPLOAI = “TB”
--N?u DIEMTB < 5 thì XEPLOAI = ”Y”--III. Ngôn ng? truy v?n d? li?u:
--1. In ra danh sách (mã h?c viên, h? tên, ngày sinh, mã l?p) l?p tr??ng c?a các l?p.
--2. In ra b?ng ?i?m khi thi (mã h?c viên, h? tên , l?n thi, ?i?m s?) môn CTRR c?a l?p “K12”, s?p x?p theo tên, h? h?c viên.
--3. In ra danh sách nh?ng h?c viên (mã h?c viên, h? tên) và nh?ng môn h?c mà h?c viên ?ó thi l?n th? nh?t ?ã ??t.
--4. In ra danh sách h?c viên (mã h?c viên, h? tên) c?a l?p “K11” thi môn CTRR không ??t (? l?n thi 1).
--5. * Danh sách h?c viên (mã h?c viên, h? tên) c?a l?p “K” thi môn CTRR không ??t (? t?t c? các l?n thi).
--6. Tìm tên nh?ng môn h?c mà giáo viên có tên “Tran Tam Thanh” d?y trong h?c k? 1 n?m 2006.
--7. Tìm nh?ng môn h?c (mã môn h?c, tên môn h?c) mà giáo viên ch? nhi?m l?p “K11” d?y trong h?c k? 1 n?m 2006.
--8. Tìm h? tên l?p tr??ng c?a các l?p mà giáo viên có tên “Nguyen To Lan” d?y môn “Co So Du Lieu”.
--9. In ra danh sách nh?ng môn h?c (mã môn h?c, tên môn h?c) ph?i h?c li?n tr??c môn “Co So Du Lieu”.
--10. Môn “Cau Truc Roi Rac” là môn b?t bu?c ph?i h?c li?n tr??c nh?ng môn h?c (mã môn h?c, tên môn h?c) nào.
--11. Tìm h? tên giáo viên d?y môn CTRR cho c? hai l?p “K11” và “K12” trong cùng h?c k? 1 n?m 2006.
--12. Tìm nh?ng h?c viên (mã h?c viên, h? tên) thi không ??t môn CSDL ? l?n thi th? 1 nh?ng ch?a thi l?i môn này.
--13. Tìm giáo viên (mã giáo viên, h? tên) không ???c phân công gi?ng d?y b?t k? môn h?c nào.
--14. Tìm giáo viên (mã giáo viên, h? tên) không ???c phân công gi?ng d?y b?t k? môn h?c nào thu?c khoa giáo viên ?ó ph? trách.
--15. Tìm h? tên các h?c viên thu?c l?p “K11” thi m?t môn b?t k? quá 3 l?n v?n “Khong dat” ho?c thi l?n th? 2 môn CTRR ???c 5 ?i?m.
--16. Tìm h? tên giáo viên d?y môn CTRR cho ít nh?t hai l?p trong cùng m?t h?c k? c?a m?t n?m h?c.
--17. Danh sách h?c viên và ?i?m thi môn CSDL (ch? l?y ?i?m c?a l?n thi sau cùng).
--18. Danh sách h?c viên và ?i?m thi môn “Co So Du Lieu” (ch? l?y ?i?m cao nh?t c?a các l?n thi).
--19. Khoa nào (mã khoa, tên khoa) ???c thành l?p s?m nh?t.
--20. Có bao nhiêu giáo viên có h?c hàm là “GS” ho?c “PGS”.