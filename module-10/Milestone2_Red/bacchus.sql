/*
Ryan Monnier, Zachariah King, Jacob Achenbach
CSD 310
Bacchus Winery Project
21-Feb-2025
*/

-- checks to see if the database bacchus exists, creates it if it doesn't
CREATE DATABASE IF NOT EXISTS bacchus;

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
    Employee_ID         INT             NOT NULL,
    Punch_Date          DATE            NOT NULL,
    Start_Time          TIME            NOT NULL,
    End_Time            TIME            NOT NULL,

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

INSERT INTO Time_Card (Employee_ID, Punch_Date, Start_Time, End_Time)
VALUES
(1, '2025-02-20', '08:15:00', '16:15:00'),  -- Stan
(2, '2025-02-20', '08:30:00', '16:30:00'),  -- Davis
(3, '2025-02-20', '09:05:00', '17:05:00'),  -- Janet
(4, '2025-02-20', '09:20:00', '17:20:00'),  -- Roz
(5, '2025-02-20', '09:10:00', '17:10:00'),  -- Bob
(6, '2025-02-20', '08:50:00', '16:50:00'),  -- Henry
(7, '2025-02-20', '08:40:00', '16:40:00');  -- Maria

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
('2025-02-01', 'Shipped', 1),
('2025-02-02', 'Pending', 2),
('2025-02-05', 'Shipped', 3),
('2025-02-07', 'Shipped', 1),
('2025-02-10', 'Pending', 2),
('2025-02-12', 'Shipped', 3);

INSERT INTO Wine_Sales (Wine_ID, Order_ID, Quantity_Sold, Sales_Date)
VALUES
(1, 1, 200, '2025-02-01'),  -- 200 Merlot
(2, 2, 150, '2025-02-02'),  -- 150 Cabernet
(3, 3, 120, '2025-02-05'),  -- 120 Chablis
(4, 4, 180, '2025-02-07'),  -- 180 Chardonnay
(1, 5, 220, '2025-02-10'),  -- 220 Merlot
(2, 6, 160, '2025-02-12');  -- 160 Cabernet

INSERT INTO Supplier (Supplier_Name, Supplier_Contact)
VALUES
('Bottle & Cork Supply Co.', '678-123-4567'),
('Label & Box Supplies', '789-234-5678'),
('Vats & Tubing Suppliers', '890-345-6789');

INSERT INTO Supply_Delivery (Supplier_ID, Expected_Delivery_Date, Actual_Delivery_Date)
VALUES
(1, '2025-02-01', '2025-02-02'),
(2, '2025-02-03', '2025-02-04'),
(3, '2025-02-07', '2025-02-07'),
(1, '2025-02-10', '2025-02-12'),
(2, '2025-02-15', '2025-02-16'),
(3, '2025-02-18', '2025-02-20');

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

