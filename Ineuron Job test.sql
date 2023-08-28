-- Create the Student table
CREATE TABLE Student (
    ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(20) NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(25)
);
INSERT INTO Student (ID, Name, Age, Address)
VALUES
    (1, 'John Doe', 20, '123 Main St'),
    (2, 'Jane Smith', 22, '456 Elm St'),
    (3, 'Michael Johnson', 19, '789 Oak Ave'),
    (4, 'Emily Brown', 21, '567 Pine Rd'),
    (5, 'David Lee', 18, '987 Maple Ln');
    
SELECT *
FROM Student
ORDER BY Age ASC
LIMIT 1;

CREATE TABLE Coordinates (
    X INT,
    Y INT
);

INSERT INTO Coordinates (X, Y)
VALUES
    (-1, -1),
    (0, 0),
    (-1, -2);


SELECT p.Name, a.Address
FROM Person p
JOIN Address a ON p.PersonID = a.PersonID;
SELECT MAX(Age) AS SecondHighest
FROM Student
WHERE Age < (SELECT MAX(Age) FROM Student);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary DECIMAL(10, 2)
);


INSERT INTO Employee (EmployeeID, Name, Salary)
VALUES
    (1, 'John Doe', 50000.00),
    (2, 'Jane Smith', 60000.00),
    (3, 'Michael Johnson', 75000.00),
    (4, 'Emily Brown', 55000.00),
    (5, 'David Lee', 65000.00);
    
    SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;

SELECT
    Company,
    AVG(Salary) AS MedianSalary
FROM (
    SELECT
        Company,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary DESC) AS RowDesc
    FROM Employee
) AS Subquery
WHERE RowAsc = RowDesc
   OR RowAsc + 1 = RowDesc
   OR RowAsc = RowDesc + 1
GROUP BY Company;

WITH SalaryPeriods AS (
    SELECT
        EmployeeID,
        DATE_TRUNC('month', SalaryDate) AS SalaryMonth,
        Salary
    FROM EmployeeSalary
    WHERE SalaryDate < DATEADD(month, -1, GETDATE())  -- Exclude most recent month
)
SELECT
    EmployeeID,
    SalaryMonth,
    SUM(Salary) OVER (PARTITION BY EmployeeID ORDER BY SalaryMonth DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS CumulativeSalary
FROM SalaryPeriods
ORDER BY EmployeeID ASC, SalaryMonth DESC;


CREATE TABLE Coordinates (
    X INT,
    Y INT
);


INSERT INTO Coordinates (X, Y)
VALUES
    (-1, -1),
    (0, 0),
    (-1, -2);
    
    SELECT
    p1.PointID AS Point1,
    p2.PointID AS Point2,
    SQRT(POW(p2.X - p1.X, 2) + POW(p2.Y - p1.Y, 2)) AS Distance
FROM Points p1
JOIN Points p2 ON p1.PointID < p2.PointID
ORDER BY Distance ASC
LIMIT 1;

SELECT
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY OrderCount DESC, c.CustomerName ASC
LIMIT 5;

SELECT
    b.title AS BookTitle,
    SUM(o.quantity) AS TotalQuantitySold
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title
ORDER BY TotalQuantitySold DESC
LIMIT 3;
