-- Tạo và sử dụng cơ sở dữ liệu Quản lý bán hàng
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- Xóa các bảng cũ nếu tồn tại để chạy lại từ đầu an toàn
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

-- 1. Tạo bảng Customer
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

-- 2. Tạo bảng Order
CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 3. Tạo bảng Product
CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

-- 4. Tạo bảng OrderDetail
CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- ========================================================
-- CHÈN DỮ LIỆU MẪU VÀO CÁC BẢNG
-- ========================================================

-- Chèn dữ liệu bảng Customer
INSERT INTO Customer VALUES (1, 'Minh Quan', 10);
INSERT INTO Customer VALUES (2, 'Ngoc Oanh', 20);
INSERT INTO Customer VALUES (3, 'Hong Ha', 50);

-- Chèn dữ liệu bảng Order
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES (1, 1, '2006-03-21', NULL);
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES (2, 2, '2006-03-23', NULL);
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES (3, 1, '2006-03-16', NULL);

-- Chèn dữ liệu bảng Product
INSERT INTO Product VALUES (1, 'May Giat', 3);
INSERT INTO Product VALUES (2, 'Tu Lanh', 5);
INSERT INTO Product VALUES (3, 'Dieu Hoa', 7);
INSERT INTO Product VALUES (4, 'Quat', 1);
INSERT INTO Product VALUES (5, 'Bap Dien', 2); -- Lưu ý: Trong hình ghi 'Bap Dien' tương ứng mã 5

-- Chèn dữ liệu bảng OrderDetail
INSERT INTO OrderDetail VALUES (1, 1, 3);
INSERT INTO OrderDetail VALUES (1, 3, 7);
INSERT INTO OrderDetail VALUES (1, 4, 2);
INSERT INTO OrderDetail VALUES (2, 1, 1);
INSERT INTO OrderDetail VALUES (3, 1, 8);
INSERT INTO OrderDetail VALUES (2, 5, 4);
INSERT INTO OrderDetail VALUES (2, 3, 3);


-- ========================================================
-- CÁC CÂU LỆNH TRUY VẤN (QUERIES) THEO YÊU CẦU
-- ========================================================

-- 1. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order
SELECT oID, oDate, oTotalPrice AS oPrice 
FROM `Order`;

-- 2. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
SELECT DISTINCT c.cID, c.Name, p.pID, p.pName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- 3. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào (Dùng Anti-Join)
SELECT c.cID, c.Name
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- 4. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
-- (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán = odQTY * pPrice)
SELECT o.oID, o.oDate, SUM(od.odQTY * p.pPrice) AS oPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
