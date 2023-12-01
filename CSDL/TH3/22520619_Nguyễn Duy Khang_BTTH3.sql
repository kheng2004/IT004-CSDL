USE QLBH_2020


--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*)'SLHD'
FROM HOADON INNER JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE KHACHHANG.NGDK IS NULL

--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP) 'SLSP' FROM CTHD
INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE YEAR(HOADON.NGHD) = 2006


--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) 'MAX_TRIGIA', MIN(TRIGIA) 'MIN_TRIGIA'
FROM HOADON

--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) 'AVG_TRIGIA'
FROM HOADON

--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) 'DOANHTHU2006'
FROM HOADON WHERE YEAR(NGHD) = 2006

--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006
SELECT SOHD
FROM HOADON
WHERE TRIGIA IN
(
SELECT MAX(TRIGIA)
FROM HOADON 
WHERE YEAR(NGHD) = 2006
)

--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG INNER JOIN HOADON
ON HOADON.MAKH = KHACHHANG.MAKH
WHERE TRIGIA =
(

SELECT MAX(TRIGIA)
FROM HOADON
WHERE YEAR(NGHD) = 2006
)

--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
GROUP BY MAKH, HOTEN
ORDER BY MAX(DOANHSO) DESC

--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN
(
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' and GIA IN
(
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)
--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' and GIA IN
(
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
	ORDER BY GIA DESC
)

--31. * In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE DOANHSO IN
(
SELECT TOP 3 DOANHSO
FROM KHACHHANG
ORDER BY DOANHSO DESC
)

--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.SELECT COUNT(MASP)
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

--33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(*) 'TONGSP'
FROM SANPHAM
GROUP BY NUOCSX

--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) 'MAX_GIA', MIN(GIA) 'MIN_GIA', AVG(GIA) 'AVG_GIA'
FROM SANPHAM
GROUP BY NUOCSX

--35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) 'DOANH_THU'
FROM HOADON
GROUP BY NGHD

--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, SUM(SL) 'SL'
FROM CTHD
INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY MASP

--37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) 'MONTH', SUM(TRIGIA) 'DOANH_THU'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM CTHD
GROUP BY SOHD
HAVING COUNT(MASP)>=4

--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).SELECT CTHD.SOHDFROM CTHD INNER JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASPWHERE NUOCSX = 'Viet Nam'GROUP BY SOHDHAVING COUNT(SANPHAM.MASP) = 3--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.SELECT MAKH, HOTENFROM KHACHHANGWHERE MAKH =(SELECT TOP 1 MAKHFROM HOADONGROUP BY MAKHORDER BY COUNT(SOHD) DESC)