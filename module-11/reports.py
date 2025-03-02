import mysql.connector
import os

# Load database credentials from .env (you may want to use dotenv for this step)
USER = "wineboss"
PASSWORD = "wineisgood"
HOST = "localhost"
DATABASE = "bacchus"

# Establish connection to the MySQL database
connection = mysql.connector.connect(
    host=HOST,
    user=USER,
    password=PASSWORD,
    database=DATABASE
)

cursor = connection.cursor()

# 1. Report: Are all suppliers delivering on time?
def supplier_delivery_report():
    query = """
        SELECT Supplier.Supplier_Name, Supply_Delivery.Expected_Delivery_Date, Supply_Delivery.Actual_Delivery_Date, 
               DATEDIFF(Supply_Delivery.Actual_Delivery_Date, Supply_Delivery.Expected_Delivery_Date) AS Delivery_Delay
        FROM Supplier
        JOIN Supply_Delivery ON Supplier.Supplier_ID = Supply_Delivery.Supplier_ID
        ORDER BY Supply_Delivery.Expected_Delivery_Date;
    """
    cursor.execute(query)
    result = cursor.fetchall()
    
    print("Monthly Supplier Delivery Report")
    print("--------------------------------------------------")
    for row in result:
        supplier_name, expected, actual, delay = row
        on_time = "On time" if delay <= 0 else f"Delayed by {delay} days"
        print(f"{supplier_name} - Expected: {expected}, Actual: {actual}, Status: {on_time}")
    print("\n")

# 2. Report: Wine distribution and sales
def wine_sales_report():
    query = """
        SELECT Wine.Wine_Type, SUM(Wine_Sales.Quantity_Sold) AS Total_Sold, Distributor.Distributor_Name
        FROM Wine
        LEFT JOIN Wine_Sales ON Wine.Wine_ID = Wine_Sales.Wine_ID
        LEFT JOIN Orders ON Wine_Sales.Order_ID = Orders.Order_ID
        LEFT JOIN Distributor ON Orders.Distributor_ID = Distributor.Distributor_ID
        GROUP BY Wine.Wine_Type, Distributor.Distributor_Name
        ORDER BY Wine.Wine_Type;
    """
    cursor.execute(query)
    result = cursor.fetchall()

    print("Wine Distribution and Sales Report")
    print("--------------------------------------------------")
    for row in result:
        wine_type, total_sold, distributor_name = row
        print(f"Wine: {wine_type} - Sold: {total_sold} - Distributor: {distributor_name}")
    print("\n")

# 3. Report: Employee work hours over the last four quarters
def employee_work_hours_report():
    query = """
        SELECT Employee.Employee_Name, 
               SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 1 AND 3 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q1,
               SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 4 AND 6 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q2,
               SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 7 AND 9 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q3,
               SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 10 AND 12 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q4
        FROM Employee
        LEFT JOIN Time_Card ON Employee.Employee_ID = Time_Card.Employee_ID
        GROUP BY Employee.Employee_Name
        ORDER BY Employee.Employee_Name;
    """
    cursor.execute(query)
    result = cursor.fetchall()

    print("Employee Work Hours Report (Last Four Quarters)")
    print("--------------------------------------------------")
    for row in result:
        employee_name, q1, q2, q3, q4 = row
        print(f"Employee: {employee_name} - Q1: {q1} hours, Q2: {q2} hours, Q3: {q3} hours, Q4: {q4} hours")
    print("\n")

# Generate all reports
supplier_delivery_report()
wine_sales_report()
employee_work_hours_report()

# Close cursor and connection
cursor.close()
connection.close()
