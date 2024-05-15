tạo bảng tblPhong

CREATE TABLE tblPhong (
   PhongID INT PRIMARY KEY AUTO_INCREMENT,
   Ten_Phong VARCHAR(20),
   Trang_thai TINYINT
);

tạo bảng tblGhe

CREATE TABLE tblGhe (
   GheID INT PRIMARY KEY AUTO_INCREMENT,
   PhongID INT,
   FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID),
   So_ghe VARCHAR(10)
);

tạo bảng tblPhim

CREATE TABLE tblPhim (
   PhimID INT PRIMARY KEY AUTO_INCREMENT,
   Ten_phim VARCHAR(30),
   Loai_phim VARCHAR(25),
   Thoi_gian INT
);

tạo bảng tblVe
CREATE TABLE tblVe(
    PhimID INT,
    FOREIGN KEY (PhimID) REFERENCES tblPhim(PhimID),
    GheID INT,
    FOREIGN KEY (GheID) REFERENCES tblGhe(GheID),
    Ngay_chieu DATE,
    Trang_thai VARCHAR(20)
)

thêm dữ liệu vào tblPhim

INSERT INTO tblPhim (Ten_phim, Loai_phim, Thoi_gian) VALUES ('Em bé Hà Nội', 'Tâm lý', 90),
 ('Nhiệm vụ bất khả thi', 'Hành động', 100),
  ('Dị nhân', 'Viễn tưởng', 90),
   ('Cuốn theo chiều gió', 'Tình cảm', 120);

thêm dữ liệu vào tblPhong

INSERT INTO tblPhong (Ten_Phong, Trang_thai) VALUES ('Phòng chiếu 1', 1),
 ('Phòng chiếu 2', 1),
  ('Phòng chiếu 3', 0);
  
  thêm dữ liệu vào tblGhe

INSERT INTO tblGhe (PhongID, So_ghe) VALUES 
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

thêm dữ liệu vào tblVe

INSERT INTO tblVe (PhimID, GheID, Ngay_chieu, Trang_thai) VALUES 
(1, 1, '2008-10-20', 'Đã bán'),
(1, 3, '2008-11-20', 'Đã bán'),
(1, 4, '2008-12-23', 'Đã bán'),
(2, 1, '2009-02-14', 'Đã bán'),
(3, 1, '2009-02-14', 'Đã bán'),
(2, 5, '2009-03-08', 'Chưa bán'),
(3, 3, '2009-03-08', 'Chưa bán');

2. Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
SELECT * FROM tblPhim ORDER BY Thoi_gian;

3. Hiển thị Ten_phim có thời gian chiếu dài nhất
SELECT Ten_phim FROM tblPhim ORDER BY Thoi_gian DESC LIMIT 1;

4. Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
SELECT Ten_phim FROM tblPhim ORDER BY Thoi_gian ASC LIMIT 1;

5. Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
SELECT So_ghe FROM tblGhe WHERE So_ghe LIKE 'A%';

6. Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)
ALTER TABLE tblPhong MODIFY Trang_thai NVARCHAR(25);

7. Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
Sau đó hiển thị bảng tblPhong (Yêu cầu dùng procedure để hiển thị đồng thời sau khi update)
DELIMITER //

CREATE PROCEDURE UpdateAndDisplayTblPhong()
BEGIN
    UPDATE tblPhong
    SET Trang_thai = CASE
        WHEN Trang_thai = 0 THEN 'Đang sửa'
        WHEN Trang_thai = 1 THEN 'Đang sử dụng'
        ELSE 'Unknow'
    END;

    SELECT * FROM tblPhong;
END //

DELIMITER ;

**8. Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự **
SELECT Ten_phim FROM tblPhim WHERE LENGTH(Ten_phim) > 15 AND LENGTH(Ten_phim) < 25;

9. Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
SELECT CONCAT(Ten_Phong, ' - ', Trang_thai) AS 'Trạng thái phòng chiếu' FROM tblPhong;

10. Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
CREATE VIEW tblRank AS
SELECT ROW_NUMBER() OVER (ORDER BY Ten_phim) AS STT, Ten_phim, Thoi_gian
FROM tblphim;

11. Trong bảng tblPhim :
Thêm trường Mo_ta kiểu nvarchar(max)
ALTER TABLE tblPhim
ADD Mo_ta VARCHAR(50);
Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường Loai_Phim
Hiển thị bảng tblPhim sau khi cập nhật
UPDATE tblPhim
SET Mo_ta = CONCAT('Đây là bộ phim thể loại ', Loai_Phim);
SELECT * FROM tblPhim;
Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film” (Dùng replace)
Hiển thị bảng tblPhim sau khi cập nhật
UPDATE tblPhim
SET Mo_ta = REPLACE(Mo_ta, 'bộ phim', 'film');
SELECT * FROM tblPhim;
12. Xóa tất cả các khóa ngoại trong các bảng trên.
ALTER TABLE tblVe DROP FOREIGN KEY PhimID;

13. Xóa dữ liệu ở bảng tblGhe
DELETE FROM tblGhe;

14. Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe
SELECT Ngay_chieu, DATE_ADD(Ngay_chieu, INTERVAL 5000 MINUTE) FROM tblVe;