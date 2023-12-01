--I. Ng�n ng? ??nh ngh?a d? li?u (Data Definition Language):
--1. T?o quan h? v� khai b�o t?t c? c�c r�ng bu?c kh�a ch�nh, kh�a ngo?i. Th�m v�o 3 thu?c t�nh GHICHU, DIEMTB, XEPLOAI cho quan h? HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR
ALTER TABLE HOCVIEN ADD DIEMTB FLOAT
ALTER TABLE HOCVIEN ADD XEPLOAI TINYINT
--2. M� h?c vi�n l� m?t chu?i 5 k� t?, 3 k� t? ??u l� m� l?p, 2 k� t? cu?i c�ng l� s? th? t? h?c vi�n trong l?p. VD: �K1101�
--skip question 2
--3. Thu?c t�nh GIOITINH ch? c� gi� tr? l� �Nam� ho?c �Nu�.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHECK_GTINH CHECK(GIOITINH IN ('Nam', 'Nu'))
--4. ?i?m s? c?a m?t l?n thi c� gi� tr? t? 0 ??n 10 v� c?n l?u ??n 2 s? l? (VD: 6.22).
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_DIEM CHECK (DIEM BETWEEN 0 AND 10)
--5. K?t qu? thi l� �Dat� n?u ?i?m t? 5 ??n 10 v� �Khong dat� n?u ?i?m nh? h?n 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_KQ CHECK ((KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10) OR (KQUA = 'Khong dat' and DIEM < 5))
--6. H?c vi�n thi m?t m�n t?i ?a 3 l?n.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHECK_LANTHI CHECK (LANTHI <=3)
--7. H?c k? ch? c� gi� tr? t? 1 ??n 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CHECK_HK CHECK (HOCKY BETWEEN 1 AND 3)
--8. H?c v? c?a gi�o vi�n ch? c� th? l� �CN�, �KS�, �Ths�, �TS�, �PTS�.ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))--11. H?c vi�n �t nh?t l� 18 tu?i.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHECK_TUOI CHECK(2023 - YEAR(NGSINH) >= 18)
--12. Gi?ng d?y m?t m�n h?c ng�y b?t ??u (TUNGAY) ph?i nh? h?n ng�y k?t th�c (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CHECK_NGAY CHECK (TUNGAY < DENNGAY)
--13. Gi�o vi�n khi v�o l�m �t nh?t l� 22 tu?i.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHECK_TUOI CHECK (2023 - YEAR(NGSINH) >= 22)
--14. T?t c? c�c m�n h?c ??u c� s? t�n ch? l� thuy?t v� t�n ch? th?c h�nh ch�nh l?ch nhau kh�ng qu� 3.
ALTER TABLE MONHOC ADD CONSTRAINT CHECK_TINCHI CHECK (ABS(TCLT - TCTH) <= 3)

--II. Ng�n ng? thao t�c d? li?u (Data Manipulation Language):
--1. T?ng h? s? l??ng th�m 0.2 cho nh?ng gi�o vi�n l� tr??ng khoa.
UPDATE GIAOVIEN SET HESO = HESO * 1.2 
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA)
--2. C?p nh?t gi� tr? ?i?m trung b�nh t?t c? c�c m�n h?c (DIEMTB) c?a m?i h?c vi�n (t?t c? c�c m�n h?c ??u c� h? s? 1 v� n?u h?c vi�n thi m?t m�n nhi?u l?n, ch? l?y ?i?m c?a l?n thi sau c�ng).
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
--3. C?p nh?t gi� tr? cho c?t GHICHU l� �Cam thi� ??i v?i tr??ng h?p: h?c vi�n c� m?t m�n b?t k? thi l?n th? 3 d??i 5 ?i?m.
--4. C?p nh?t gi� tr? cho c?t XEPLOAI trong quan h? HOCVIEN nh? sau:
--N?u DIEMTB ? 9 th� XEPLOAI =�XS�
--N?u 8 ? DIEMTB < 9 th� XEPLOAI = �G�
--N?u 6.5 ? DIEMTB < 8 th� XEPLOAI = �K�
--N?u 5 ? DIEMTB < 6.5 th� XEPLOAI = �TB�
--N?u DIEMTB < 5 th� XEPLOAI = �Y�--III. Ng�n ng? truy v?n d? li?u:
--1. In ra danh s�ch (m� h?c vi�n, h? t�n, ng�y sinh, m� l?p) l?p tr??ng c?a c�c l?p.
--2. In ra b?ng ?i?m khi thi (m� h?c vi�n, h? t�n , l?n thi, ?i?m s?) m�n CTRR c?a l?p �K12�, s?p x?p theo t�n, h? h?c vi�n.
--3. In ra danh s�ch nh?ng h?c vi�n (m� h?c vi�n, h? t�n) v� nh?ng m�n h?c m� h?c vi�n ?� thi l?n th? nh?t ?� ??t.
--4. In ra danh s�ch h?c vi�n (m� h?c vi�n, h? t�n) c?a l?p �K11� thi m�n CTRR kh�ng ??t (? l?n thi 1).
--5. * Danh s�ch h?c vi�n (m� h?c vi�n, h? t�n) c?a l?p �K� thi m�n CTRR kh�ng ??t (? t?t c? c�c l?n thi).
--6. T�m t�n nh?ng m�n h?c m� gi�o vi�n c� t�n �Tran Tam Thanh� d?y trong h?c k? 1 n?m 2006.
--7. T�m nh?ng m�n h?c (m� m�n h?c, t�n m�n h?c) m� gi�o vi�n ch? nhi?m l?p �K11� d?y trong h?c k? 1 n?m 2006.
--8. T�m h? t�n l?p tr??ng c?a c�c l?p m� gi�o vi�n c� t�n �Nguyen To Lan� d?y m�n �Co So Du Lieu�.
--9. In ra danh s�ch nh?ng m�n h?c (m� m�n h?c, t�n m�n h?c) ph?i h?c li?n tr??c m�n �Co So Du Lieu�.
--10. M�n �Cau Truc Roi Rac� l� m�n b?t bu?c ph?i h?c li?n tr??c nh?ng m�n h?c (m� m�n h?c, t�n m�n h?c) n�o.
--11. T�m h? t�n gi�o vi�n d?y m�n CTRR cho c? hai l?p �K11� v� �K12� trong c�ng h?c k? 1 n?m 2006.
--12. T�m nh?ng h?c vi�n (m� h?c vi�n, h? t�n) thi kh�ng ??t m�n CSDL ? l?n thi th? 1 nh?ng ch?a thi l?i m�n n�y.
--13. T�m gi�o vi�n (m� gi�o vi�n, h? t�n) kh�ng ???c ph�n c�ng gi?ng d?y b?t k? m�n h?c n�o.
--14. T�m gi�o vi�n (m� gi�o vi�n, h? t�n) kh�ng ???c ph�n c�ng gi?ng d?y b?t k? m�n h?c n�o thu?c khoa gi�o vi�n ?� ph? tr�ch.
--15. T�m h? t�n c�c h?c vi�n thu?c l?p �K11� thi m?t m�n b?t k? qu� 3 l?n v?n �Khong dat� ho?c thi l?n th? 2 m�n CTRR ???c 5 ?i?m.
--16. T�m h? t�n gi�o vi�n d?y m�n CTRR cho �t nh?t hai l?p trong c�ng m?t h?c k? c?a m?t n?m h?c.
--17. Danh s�ch h?c vi�n v� ?i?m thi m�n CSDL (ch? l?y ?i?m c?a l?n thi sau c�ng).
--18. Danh s�ch h?c vi�n v� ?i?m thi m�n �Co So Du Lieu� (ch? l?y ?i?m cao nh?t c?a c�c l?n thi).
--19. Khoa n�o (m� khoa, t�n khoa) ???c th�nh l?p s?m nh?t.
--20. C� bao nhi�u gi�o vi�n c� h?c h�m l� �GS� ho?c �PGS�.