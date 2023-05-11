CREATE DATABASE QLKH
GO

USE QLKH
GO

CREATE TABLE Lecturers(
LID char(4) NOT NULL,
FullName nchar(30) NOT NULL,
Address nvarchar(50) NOT NULL,
DOB date NOT NULL,
CONSTRAINT pkLecturers PRIMARY KEY (LID)
)
GO

CREATE TABLE Projects(
PID char(4) NOT NULL,
Title nvarchar(50) NOT NULL,
Level nchar(12) NOT NULL,
Cost integer,
CONSTRAINT pkProjects PRIMARY KEY (PID)
)
GO

CREATE TABLE Participation(
LID char(4) NOT NULL,
PID char(4) NOT NULL,
Duration smallint,
CONSTRAINT pkParticipation PRIMARY KEY (LID, PID),
CONSTRAINT fk1 FOREIGN KEY (LID) REFERENCES Lecturers (LID),
CONSTRAINT fk2 FOREIGN KEY (PID) REFERENCES Projects (PID)
)
GO

INSERT INTO Lecturers VALUES('GV01',N'Vu Tuyet Trinh',N'Hoang Mai, Hanoi',
'1975/10/10'),
('GV02',N'Nguyen Nhat Quang',N'Hai Ba Trung, Hanoi','19761103'),
('GV03',N'Tran Duc Khanh',N'Dong Da, Hanoi','19770604'),
('GV04',N'Nguyen Hong Phuong',N'Tay Ho, Hanoi','19831210'),
('GV05',N'Le Thanh Huong',N'Hai Ba Trung, Hanoi','19761010')
INSERT INTO Projects VALUES ('DT01',N'Grid Computing',N'A','700'),
('DT02',N'Knowledge Discovery',N'B','300'),
('DT03',N'Text Classification',N'B','270'),
('DT04',N'Automatic English-Vietnamese Translation',N'C','30')
INSERT INTO Participation VALUES ('GV01','DT01','100'),
('GV01','DT02','80'),
('GV01','DT03','80'),
('GV02','DT01','120'),
('GV02','DT03','140'),
('GV03','DT03','150'),
('GV04','DT04','180')


SELECT *
FROM dbo.Lecturers
WHERE Address LIKE 'Hai Ba Trung%'
ORDER BY FullName DESC

SELECT FullName, Address, DOB
FROM dbo.Lecturers JOIN dbo.Participation
ON dbo.Lecturers.LID = dbo.Participation.LID
JOIN dbo.Projects ON Projects.PID = Participation.PID
WHERE dbo.Projects.Title LIKE '%Grid Computing%'

SELECT FullName, Address, DOB
FROM dbo.Lecturers JOIN dbo.Participation
ON dbo.Lecturers.LID = dbo.Participation.LID
JOIN dbo.Projects ON Projects.PID = Participation.PID
WHERE dbo.Projects.Title LIKE '%Grid Computing%' OR dbo.Projects.Title LIKE '%Automatic English-Vietnamese Translation%'

SELECT * FROM dbo.Lecturers
WHERE LID IN (SELECT LID FROM dbo.Participation
						 GROUP BY LID HAVING COUNT(LID) > 1)

SELECT FullName 
FROM dbo.Lecturers 
WHERE LID IN (SELECT LID FROM dbo.Participation
	  GROUP BY LID HAVING COUNT(LID) >= ALL ( SELECT COUNT(LID) FROM dbo.Participation
											  GROUP BY LID ))

--7.Show the name and DOB of lecturers who live in "Tay Ho" district and their project's title
SELECT Lec.FullName, Lec.DOB, Pro.Title 
FROM dbo.Lecturers Lec JOIN dbo.Participation Par
ON Par.LID = Lec.LID
JOIN dbo.Projects Pro ON Pro.PID = Par.PID
WHERE Lec.Address LIKE '%Tay Ho%' 


--8.Find the name of lecturers who was born before 1980 and joined the "Text Classification" project.
SELECT FullName 
FROM dbo.Lecturers JOIN dbo.Participation
ON Participation.LID = Lecturers.LID
JOIN dbo.Projects ON Projects.PID = Participation.PID
WHERE YEAR(DOB) < '19800101' AND dbo.Projects.Title LIKE '%Text Classification%'

--9.	For each lecturers, list LID, full name and the total of duration. 
SELECT Lec.FullName, Lec.LID, ParS.SUM
FROM dbo.Lecturers Lec
JOIN (SELECT LID, SUM(Duration) AS SUM FROM dbo.Participation GROUP BY LID) ParS
ON ParS.LID = Lec.LID

--10.	Lecturer named Ngo Tuan Phong, born on 08/09/1986, lives in "Dong Da, Hanoi", join doing scientific research. Please insert this information into Lecturers table.

INSERT INTO dbo.Lecturers
(
    LID,
    FullName,
    Address,
    DOB
)
VALUES
(   'GV06',       -- LID
    'Ngo Tuan Phong',      -- FullName
    'Dong Da, Hanoi',      -- Address
    '19860908' -- DOB
    )

-- 11.	Lecturer named Vu Tuyet Trinh moved to "Tay Ho, Hanoi". Please update this information.
UPDATE dbo.Lecturers SET Address = 'Tay Ho, Hanoi'
WHERE FullName = 'Vu Tuyet Trinh'

-- 12.	Lecturer with LID "GV02" no longer participate any projects. The information relating to this lecturer should be crossed out of database. Please complete this command.

--13
SELECT COUNT(LID)
FROM dbo.Participation 
WHERE PID IN (SELECT PID FROM dbo.Projects