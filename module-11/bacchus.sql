/*
Ryan Monnier, Zachariah King, Jacob Achenbach
CSD 310
Bacchus Winery Project
21-Feb-2025
*/

-- checks to see if the database bacchus exists, creates it if it doesn't
CREATE DATABASE IF NOT EXISTS bacchus;
USE bacchus;
-- sets user, the fact that we're local, and the password as referenced in the .env file
DROP USER IF EXISTS 'wineboss'@'localhost';
CREATE USER 'wineboss'@'localhost' IDENTIFIED WITH mysql_native_password BY 'wineisgood';

-- allow 'wineboss' to use all database functions, CREATE, INSERT, etc.
GRANT ALL PRIVILEGES ON bacchus.* TO 'wineboss'@'localhost';

-- remove old tables if they exist
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Time_Card;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Wine_Sales;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Supply_Delivery;
DROP TABLE IF EXISTS Distributor;
DROP TABLE IF EXISTS Wine;
DROP TABLE IF EXISTS Supply_Inventory;
DROP TABLE IF EXISTS Supply_Items;

-- create our 10 tables as they're laid out in our ERD
CREATE TABLE Employee (
    Employee_ID         INT             NOT NULL        AUTO_INCREMENT, -- each table will have its primary ID auto incremented
    Employee_Name       VARCHAR(75)     NOT NULL,       -- each field will be mandatory
    Department          VARCHAR(75)     NOT NULL,
    Position            VARCHAR(75)     NOT NULL,
    Employee_Contact    CHAR(12)        NOT NULL,

    PRIMARY KEY(Employee_ID)
);

CREATE TABLE Time_Card (
    Time_Card_ID        INT             NOT NULL        AUTO_INCREMENT,
    Employee_ID INT NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,   -- 1 for January, 2 for February, etc.
    Hours_Worked INT NOT NULL,   -- Total hours worked in that month

    PRIMARY KEY(Time_Card_ID),
    FOREIGN KEY(Employee_ID)
        REFERENCES Employee(Employee_ID)
);

CREATE TABLE Distributor (
    Distributor_ID      INT             NOT NULL        AUTO_INCREMENT,
    Distributor_Name    VARCHAR(75)     NOT NULL,
    Order_Status        VARCHAR(75)     NOT NULL,

    PRIMARY KEY(Distributor_ID)
);

CREATE TABLE Wine (
    Wine_ID             INT             NOT NULL        AUTO_INCREMENT,
    Wine_Type           VARCHAR(75)     NOT NULL,
    Wine_Inventory      INT             NOT NULL,
    Wine_Price          INT             NOT NULL,

    PRIMARY KEY(Wine_ID)
);

CREATE TABLE Orders (
    Order_ID            INT             NOT NULL        AUTO_INCREMENT,
    Order_Date          DATE            NOT NULL,
    Order_Status        VARCHAR(75)  	NOT NULL,
    Distributor_ID      INT            	NOT NULL,

    PRIMARY KEY(Order_ID),
    FOREIGN KEY(Distributor_ID)
        REFERENCES Distributor(Distributor_ID)
);

CREATE TABLE Wine_Sales (
    Sales_ID            INT             NOT NULL        AUTO_INCREMENT,
    Wine_ID             INT             NOT NULL,
    Order_ID            INT             NOT NULL,
    Quantity_Sold       INT             NOT NULL,
    Sales_Date          DATE            NOT NULL,

    PRIMARY KEY(Sales_ID),
    FOREIGN KEY(Wine_ID)
        REFERENCES Wine(Wine_ID),
    FOREIGN KEY(Order_ID)
        REFERENCES Orders(Order_ID)
);

CREATE TABLE Supplier (
    Supplier_ID         INT             NOT NULL        AUTO_INCREMENT,
    Supplier_Name       VARCHAR(75)     NOT NULL,
    Supplier_Contact    CHAR(12)        NOT NULL,
    
    PRIMARY KEY(Supplier_ID)
);

CREATE TABLE Supply_Delivery (
    Delivery_ID                 INT             NOT NULL        AUTO_INCREMENT,
    Supplier_ID                 INT             NOT NULL,
    Expected_Delivery_Date      DATE            NOT NULL,
    Actual_Delivery_Date        DATE,           -- allowing Actual_Delivery_Date to be NULL, in case it hasn't been delivered yet

    PRIMARY KEY(Delivery_ID),
    FOREIGN KEY(Supplier_ID)
        REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE Supply_Inventory (
    Supply_ID           INT             NOT NULL        AUTO_INCREMENT,
    Supply_Name         VARCHAR(75)     NOT NULL,
    Supply_Stock        INT             NOT NULL,
    Supplier_ID         INT             NOT NULL,
    Cost_Per_Unit       INT             NOT NULL,

    PRIMARY KEY(Supply_ID),
    FOREIGN KEY(Supplier_ID)
        REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE Supply_Items (
    Supply_Item_ID      INT             NOT NULL        AUTO_INCREMENT,
    Supply_ID           INT             NOT NULL,
    Delivery_ID         INT             NOT NULL,
    Quantity            INT             NOT NULL,

    PRIMARY KEY(Supply_Item_ID),
    FOREIGN KEY(Supply_ID)
        REFERENCES Supply_Inventory(Supply_ID),
    FOREIGN KEY(Delivery_ID)
        REFERENCES Supply_Delivery(Delivery_ID)
);


-- using INSERT to populate our tables 
INSERT INTO Employee (Employee_Name, Department, Position, Employee_Contact)
VALUES
-- we aren't specifying Employee_ID because its set to AUTO_INCREMENT, this will be the case for each table
('Stan Bacchus', 'Management', 'Co-owner', '111-222-3333'),
('Davis Bacchus', 'Management', 'Co-owner', '444-555-6666'),
('Janet Collins', 'Finance', 'Head of Finance and Payroll', '123-456-7890'),
('Roz Murphy', 'Marketing', 'Head of Marketing', '234-567-8901'),
('Bob Ulrich', 'Marketing', 'Marketing Assistant', '345-678-9012'),
('Henry Doyle', 'Production', 'Production Manager', '456-789-0123'),
('Maria Costanza', 'Distribution', 'Distribution Manager', '567-890-1234');


INSERT INTO Time_Card (Employee_ID, Year, Month, Hours_Worked) 
VALUES
(1, 2024, 1, 160),
(1, 2024, 2, 170),
(1, 2024, 3, 155),
(1, 2024, 4, 180),
(1, 2024, 5, 165),
(1, 2024, 6, 175),
(1, 2024, 7, 160),
(1, 2024, 8, 170),
(1, 2024, 9, 150),
(1, 2024, 10, 175),
(1, 2024, 11, 160),
(1, 2024, 12, 185),
(2, 2024, 1, 150),
(2, 2024, 2, 155),
(2, 2024, 3, 160),
(2, 2024, 4, 165),
(2, 2024, 5, 150),
(2, 2024, 6, 160),
(2, 2024, 7, 155),
(2, 2024, 8, 150),
(2, 2024, 9, 160),
(2, 2024, 10, 155),
(2, 2024, 11, 150),
(2, 2024, 12, 165),
(3, 2024, 1, 145),
(3, 2024, 2, 160),
(3, 2024, 3, 155),
(3, 2024, 4, 170),
(3, 2024, 5, 150),
(3, 2024, 6, 165),
(3, 2024, 7, 160),
(3, 2024, 8, 155),
(3, 2024, 9, 145),
(3, 2024, 10, 160),
(3, 2024, 11, 155),
(3, 2024, 12, 175),
(4, 2024, 1, 155),
(4, 2024, 2, 165),
(4, 2024, 3, 150),
(4, 2024, 4, 160),
(4, 2024, 5, 155),
(4, 2024, 6, 170),
(4, 2024, 7, 160),
(4, 2024, 8, 150),
(4, 2024, 9, 165),
(4, 2024, 10, 160),
(4, 2024, 11, 150),
(4, 2024, 12, 175),
(5, 2024, 1, 160),
(5, 2024, 2, 150),
(5, 2024, 3, 145),
(5, 2024, 4, 155),
(5, 2024, 5, 160),
(5, 2024, 6, 150),
(5, 2024, 7, 155),
(5, 2024, 8, 165),
(5, 2024, 9, 160),
(5, 2024, 10, 145),
(5, 2024, 11, 155),
(5, 2024, 12, 170),
(6, 2024, 1, 175),
(6, 2024, 2, 160),
(6, 2024, 3, 170),
(6, 2024, 4, 160),
(6, 2024, 5, 155),
(6, 2024, 6, 160),
(6, 2024, 7, 165),
(6, 2024, 8, 175),
(6, 2024, 9, 160),
(6, 2024, 10, 155),
(6, 2024, 11, 170),
(6, 2024, 12, 165),
(7, 2024, 1, 160),
(7, 2024, 2, 150),
(7, 2024, 3, 155),
(7, 2024, 4, 165),
(7, 2024, 5, 160),
(7, 2024, 6, 150),
(7, 2024, 7, 145),
(7, 2024, 8, 160),
(7, 2024, 9, 170),
(7, 2024, 10, 155),
(7, 2024, 11, 160),
(7, 2024, 12, 145);


INSERT INTO Distributor (Distributor_Name, Order_Status)
VALUES
('Vino Express', 'Active'),
('Wine Direct', 'Pending'),
('Global Distributors', 'Shipped');

INSERT INTO Wine (Wine_Type, Wine_Inventory, Wine_Price)
VALUES
('Merlot', 1200, 17),
('Cabernet', 900, 22),
('Chablis', 700, 19),
('Chardonnay', 1500, 24);

INSERT INTO Orders (Order_Date, Order_Status, Distributor_ID)
VALUES
('2024-01-05', 'Shipped', 1),
('2024-01-15', 'Shipped', 2),
('2024-01-20', 'Shipped', 3),
('2024-02-02', 'Shipped', 1),
('2024-02-07', 'Shipped', 2),
('2024-02-18', 'Shipped', 3),
('2024-03-01', 'Shipped', 1),
('2024-03-12', 'Shipped', 3),
('2024-03-20', 'Shipped', 2),
('2024-04-05', 'Shipped', 1),
('2024-04-10', 'Shipped', 2),
('2024-04-18', 'Shipped', 3),
('2024-05-02', 'Shipped', 1),
('2024-05-12', 'Shipped', 2),
('2024-05-15', 'Shipped', 3),
('2024-06-05', 'Shipped', 1),
('2024-06-10', 'Shipped', 2),
('2024-06-18', 'Shipped', 3),
('2024-07-01', 'Shipped', 1),
('2024-07-07', 'Shipped', 2),
('2024-07-14', 'Shipped', 3),
('2024-08-02', 'Shipped', 1),
('2024-08-10', 'Shipped', 3),
('2024-08-15', 'Shipped', 2),
('2024-09-05', 'Shipped', 1),
('2024-09-12', 'Shipped', 3),
('2024-09-18', 'Shipped', 2),
('2024-10-01', 'Shipped', 1),
('2024-10-12', 'Shipped', 2),
('2024-10-20', 'Shipped', 3),
('2024-11-03', 'Shipped', 1),
('2024-11-14', 'Shipped', 2);

INSERT INTO Wine_Sales (Wine_ID, Order_ID, Quantity_Sold, Sales_Date)
VALUES
(1, 1, 200, '2024-01-05'),
(2, 2, 150, '2024-01-15'),
(3, 3, 100, '2024-01-20'),
(4, 4, 180, '2024-02-02'),   -- Chardonnay to Distributor 1
(1, 5, 220, '2024-02-07'),
(4, 6, 160, '2024-02-18'),   -- Chardonnay to Distributor 3
(2, 7, 180, '2024-03-01'),
(3, 8, 210, '2024-03-12'),
(4, 9, 230, '2024-03-20'),   -- Chardonnay to Distributor 2
(1, 10, 250, '2024-04-05'),
(4, 11, 200, '2024-04-10'),   -- Chardonnay to Distributor 2
(2, 12, 270, '2024-04-18'),
(3, 13, 150, '2024-05-02'),
(1, 14, 180, '2024-05-12'),
(4, 15, 200, '2024-05-15'),   -- Chardonnay to Distributor 3
(2, 16, 250, '2024-06-05'),
(3, 17, 190, '2024-06-10'),
(4, 18, 210, '2024-06-18'),   -- Chardonnay to Distributor 1
(1, 19, 220, '2024-07-01'),
(2, 20, 200, '2024-07-07'),
(4, 21, 240, '2024-07-14'),   -- Chardonnay to Distributor 3
(3, 22, 250, '2024-08-02'),
(1, 23, 230, '2024-08-10'),
(4, 24, 190, '2024-08-15'),   -- Chardonnay to Distributor 2
(2, 25, 220, '2024-09-05'),
(4, 26, 170, '2024-09-12'),   -- Chardonnay to Distributor 1
(3, 27, 250, '2024-09-18'),
(1, 28, 260, '2024-10-01'),
(2, 29, 210, '2024-10-12'),
(4, 30, 180, '2024-10-20');   -- Chardonnay to Distributor 3

INSERT INTO Supplier (Supplier_Name, Supplier_Contact)
VALUES
('Bottle & Cork Supply Co.', '678-123-4567'),
('Label & Box Supplies', '789-234-5678'),
('Vats & Tubing Suppliers', '890-345-6789');

INSERT INTO Supply_Delivery (Supplier_ID, Expected_Delivery_Date, Actual_Delivery_Date)
VALUES
(1, '2024-01-10', '2024-01-13'),
(2, '2024-01-15', '2024-01-15'),
(3, '2024-01-18', '2024-01-19'),
(1, '2024-02-01', '2024-02-03'),
(2, '2024-02-10', '2024-02-09'),
(3, '2024-02-15', '2024-02-16'),
(1, '2024-03-01', '2024-03-02'),
(2, '2024-03-07', '2024-03-07'),
(3, '2024-03-10', '2024-03-10'),
(1, '2024-04-05', '2024-04-06'),
(2, '2024-04-10', '2024-04-09'),
(3, '2024-04-15', '2024-04-18'),
(1, '2024-05-01', '2024-05-01'),
(2, '2024-05-07', '2024-05-08'),
(3, '2024-05-10', '2024-05-10'),
(1, '2024-06-01', '2024-06-02'),
(2, '2024-06-05', '2024-06-06'),
(3, '2024-06-08', '2024-06-07'),
(1, '2024-07-01', '2024-07-01'),
(2, '2024-07-05', '2024-07-06'),
(3, '2024-07-10', '2024-07-10'),
(1, '2024-08-01', '2024-08-02'),
(2, '2024-08-05', '2024-08-06'),
(3, '2024-08-08', '2024-08-09'),
(1, '2024-09-01', '2024-09-01'),
(2, '2024-09-05', '2024-09-06'),
(3, '2024-09-10', '2024-09-11'),
(1, '2024-10-01', '2024-09-30'),
(2, '2024-10-05', '2024-10-05');

INSERT INTO Supply_Inventory (Supply_Name, Supply_Stock, Supplier_ID, Cost_Per_Unit)
VALUES
('Wine Bottles', 1000, 1, 0.55),
('Corks', 3000, 1, 0.12),
('Wine Labels', 1800, 2, 0.28),
('Wine Boxes', 1500, 2, 1.10),
('Vats', 15, 3, 55.00), 
('Tubing', 600, 3, 2.20);

INSERT INTO Supply_Items (Supply_ID, Delivery_ID, Quantity)
VALUES
(1, 1, 1000),  -- 1000 Wine Bottles
(2, 1, 3000),  -- 3000 Corks
(3, 2, 1800),  -- 1800 Labels
(4, 2, 1500),  -- 1500 Boxes
(5, 3, 15),    -- 15 Vats
(6, 3, 600);   -- 600 Tubing

