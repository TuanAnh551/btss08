tạo bảng Class
CREATE TABLE class (
    ClassID INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    ClassName VARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    Status Bit 
);

tạo bảng student
CREATE TABLE student (
    StudentID INT PRIMARY KEY NOT NULL,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status Bit,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES class(ClassID)
);

tạo bảng subject
CREATE TABLE subject (
    SubID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1 ),
    Status Bit DEFAULT 1
);

tạo bảng mark
CREATE TABLE mark (
    MarkID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    SubID INT NOT NULL,
    FOREIGN KEY (SubID) REFERENCES subject(SubID),
    StudentID INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES student(StudentID),
    Mark FLOAT NOT NULL CHECK (Mark >= 0 AND Mark <= 100),
    ExamTimes TINYINT NOT NULL DEFAULT 1
);

nhập dữ liệu vào class
INSERT INTO class (ClassName, StartDate, Status) VALUES 
('A1', '2008-12-01', 1),
('A2', '2008-12-01', 1),
('B3', CURDATE(), 0);

nhập dữ liệu vào student
INSERT INTO student (StudentID, StudentName, Address, Phone, Status, ClassID) VALUES 
(1, 'Hung', 'Hà Nội', '0912113113', 1, 1),
(2, 'Hoa', 'Hải Phòng', '', 1, 1),
(3, 'Manh', 'HCM', '0123123123', 0, 2);

nhập dữ liệu vào subject
INSERT INTO subject (SubName, Credit, Status) VALUES 
('CF', 5, 1),
('C', 6, 1),
('HDJ', 5, 1),
('RDBMS', 10, 1);

nhập dữ liệu vào mark
INSERT INTO mark (SubID, StudentID, Mark, ExamTimes) VALUES 
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);
5.Cập nhật dữ liệu.
Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
UPDATE student
SET ClassID = 2
WHERE StudentName = 'Hung';
Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
UPDATE student
SET Phone = 'No phone'
WHERE Phone IS NULL;



Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
UPDATE class
SET ClassName = CONCAT('New ', ClassName)
WHERE Status = 0;

Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
UPDATE class
SET ClassName = REPLACE(ClassName, 'New', 'Old')
WHERE Status = 1 AND ClassName LIKE 'New%';

Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
UPDATE class
SET Status = 0
WHERE ClassID NOT IN (SELECT ClassID FROM student);

Cập nhật trạng thái của môn học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
UPDATE subject
SET Status = 0
WHERE SubID NOT IN (SELECT SubID FROM mark);


6.Hiện thị thông tin.
Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
SELECT * FROM student WHERE StudentName LIKE 'h%';

Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
SELECT * FROM class WHERE MONTH(StartDate) = 12;

Hiển thị giá trị lớn nhất của credit trong bảng subject.
SELECT MAX(Credit) FROM subject;

Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
SELECT * FROM subject WHERE Credit = (SELECT MAX(Credit) FROM subject);

Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
SELECT * FROM subject WHERE Credit BETWEEN 3 AND 5;

Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
SELECT class.ClassID, class.ClassName, student.StudentName, student.Address 
FROM Class 
INNER JOIN student ON class.ClassID = student.ClassID;


Hiển thị các thông tin môn học chưa có sinh viên dự thi.
SELECT * FROM subject WHERE Status = 0;


Hiển thị các thông tin môn học có điểm thi lớn nhất.
SELECT * FROM subject 
INNER JOIN mark ON subject.SubID = mark.SubID 
WHERE mark.Mark = (SELECT MAX(mark.Mark) FROM mark);

Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
SELECT student.StudentName, AVG(mark.Mark) AS AverageScore 
FROM student 
INNER JOIN mark ON student.StudentID = mark.StudentID 
GROUP BY student.StudentName;

Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
SELECT student.StudentName, AVG(mark.Mark) AS AverageScore, 
RANK() OVER (ORDER BY AVG(mark.Mark) DESC) AS RankOrder
FROM student 
INNER JOIN mark ON student.StudentID = mark.StudentID 
GROUP BY student.StudentName;

Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
SELECT student.StudentName, AVG(mark.Mark) AS AverageScore 
FROM student
INNER JOIN mark ON student.StudentID = mark.StudentID 
GROUP BY student.StudentName 
HAVING AVG(mark.Mark) > 10;

Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
SELECT student.StudentName, subject.SubName, mark.Mark 
FROM student
INNER JOIN mark ON student.StudentID = mark.StudentID 
INNER JOIN subject ON mark.SubID = subject.SubID
ORDER BY mark.Mark DESC, student.StudentName;


Xóa dữ liệu.
Xóa tất cả các lớp có trạng thái là 0.
DELETE FROM class WHERE Status = 0;

Xóa tất cả các môn học chưa có sinh viên dự thi.
DELETE FROM subject 
WHERE SubID NOT IN (SELECT SubID FROM mark);

Thay đổi.
Xóa bỏ cột ExamTimes trên bảng Mark.
ALTER TABLE mark DROP COLUMN mark.ExamTimes;

Sửa đổi cột status trên bảng class thành tên ClassStatus.
ALTER TABLE class
CHANGE COLUMN Status ClassStatus BIT(1);


Đổi tên bảng Mark thành SubjectTest.
ALTER TABLE mark RENAME TO SubjectTest;
