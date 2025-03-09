# Program: Reports for Bacchus Winery
# Authors: Red Team - Ryan Monnier, Zachariah King, Jacob Achenbach
# Date: 3/2/25
# Description: This program uses a variety of modules and sql connections
#              to create reports needed for Bacchus Winery that deal with
#              supplier deliveries, wine sales, and employee hours.

import mysql.connector
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime  # For adding date/time to the reports

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

# Get the current date and time
current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# 1. Report: Are all suppliers delivering on time?
def supplier_delivery_report():
    query = """
        SELECT 
            Supplier.Supplier_Name,
            YEAR(Supply_Delivery.Expected_Delivery_Date) AS delivery_year,
            MONTH(Supply_Delivery.Expected_Delivery_Date) AS delivery_month,
            COUNT(*) AS total_deliveries,
            AVG(DATEDIFF(Supply_Delivery.Actual_Delivery_Date, Supply_Delivery.Expected_Delivery_Date)) AS avg_delivery_delay
        FROM Supplier
        JOIN Supply_Delivery ON Supplier.Supplier_ID = Supply_Delivery.Supplier_ID
        GROUP BY Supplier.Supplier_Name, delivery_year, delivery_month
        ORDER BY delivery_year ASC, delivery_month ASC, Supplier.Supplier_Name;
    """
    cursor.execute(query)
    result = cursor.fetchall()
    
    print(f"Supplier Delivery Report - Generated on {current_time}")
    print("--------------------------------------------------\n")
    
    current_month = None
    for row in result:
        supplier_name, year, month, total_deliveries, avg_delay = row
        
        # Format the month and year
        month_name = f"{year}-{month:02d}"  # Example: 2024-03
        
        # Print headers for new months
        if month_name != current_month:
            if current_month is not None:
                print("\n")  # Add space between months
            print(f"Month: {month_name}")
            print("--------------------------------------------------")
            print("{:<25}  {:<20}  {:<20}".format("Supplier", "Total Deliveries", "Avg Delay"))
            print("-" * 70)
            current_month = month_name
        
        # Print the report for the supplier
        delay_status = f"{avg_delay:.2f} days"
        print("{:<25}  {:<20}  {:<20}".format(supplier_name, total_deliveries, delay_status))
    
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

    print(f"Wine Distribution and Sales Report - Generated on {current_time}")
    print("--------------------------------------------------")
    print("{:<20}  {:<20}  {:<20}".format("Wine Type", "Distributor", "Total Sold (YTD)"))
    print("-" * 60)
    
    # Prepare data for plotting
    distributors = sorted(set([row[2] for row in result]))  # Unique list of distributors
    wine_types = sorted(set([row[0] for row in result]))  # Unique list of wine types

    # Create a dictionary to store the sales data for each distributor
    sales_data = {distributor: {wine_type: 0 for wine_type in wine_types} for distributor in distributors}

    # Fill the sales data dictionary
    for row in result:
        wine_type, total_sold, distributor_name = row
        sales_data[distributor_name][wine_type] = total_sold

    # Print the table
    for wine_type in wine_types:
        for distributor in distributors:
            total_sold = sales_data[distributor][wine_type]
            print("{:<20}  {:<20}  {:<20}".format(wine_type, distributor, total_sold))

    print("\n")

    # Create a bar plot for each distributor
    fig, ax = plt.subplots(figsize=(10, 6))
    
    bar_width = 0.15  # Width of each bar
    index = np.arange(len(wine_types))  # X-axis positions for wine types

    # Set up the bar positions and data for each distributor
    for i, distributor in enumerate(distributors):
        sales = [sales_data[distributor][wine_type] for wine_type in wine_types]
        ax.bar(index + i * bar_width, sales, bar_width, label=distributor)

    # Formatting the plot
    ax.set_xlabel('Wine Type')
    ax.set_ylabel('Total Sold (YTD)')
    ax.set_title('Wine Sales by Distributor')
    ax.set_xticks(index + bar_width * (len(distributors) - 1) / 2)  # Position x-ticks at the middle of the bars
    ax.set_xticklabels(wine_types, rotation=45, ha="right")
    ax.legend(title='Distributors')

    plt.tight_layout()
    plt.show()

    print("\n")

# 3. Report: Employee work hours over the last four quarters
def employee_work_hours_report():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Get the current timestamp

    query = """
        SELECT 
            Employee.Employee_Name, 
            SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 1 AND 3 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q1,
            SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 4 AND 6 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q2,
            SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 7 AND 9 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q3,
            SUM(CASE WHEN Time_Card.Year = 2024 AND Time_Card.Month BETWEEN 10 AND 12 THEN Time_Card.Hours_Worked ELSE 0 END) AS Q4,
            SUM(Time_Card.Hours_Worked) AS Total_Hours_Worked
        FROM Employee
        LEFT JOIN Time_Card ON Employee.Employee_ID = Time_Card.Employee_ID
        WHERE Time_Card.Year = 2024
        GROUP BY Employee.Employee_Name
        ORDER BY Employee.Employee_Name;
    """
    cursor.execute(query)
    result = cursor.fetchall()

    print(f"Employee Work Hours Report (Last Four Quarters) - Generated on {current_time}")
    print("--------------------------------------------------\n")
    
    # Print the header with the timespan for each quarter and Average Hours Worked
    print("{:<25}  {:<20}  {:<20}  {:<20}  {:<20}  {:<20}  {:<20}".format(
        "Employee", "Q1 (Jan-Mar)", "Q2 (Apr-Jun)", "Q3 (Jul-Sep)", "Q4 (Oct-Dec)", "Total Hours Worked", "Avg Hours Worked Per Q"
    ))
    print("-" * 140)
    
    for row in result:
        employee_name, q1, q2, q3, q4, total_hours = row
        
        # Calculate average hours worked (based on 4 quarters)
        quarters_with_hours = len([q for q in [q1, q2, q3, q4] if q > 0])  # Count non-zero quarters
        average_hours = total_hours / quarters_with_hours if quarters_with_hours > 0 else 0  # Avoid division by zero
        
        print("{:<25}  {:<20}  {:<20}  {:<20}  {:<20}  {:<20}  {:<20}".format(
            employee_name, q1, q2, q3, q4, total_hours, round(average_hours, 2)
        ))
    
    print("\n")

# Generate all reports
supplier_delivery_report()
wine_sales_report()
employee_work_hours_report()

# Close cursor and connection
cursor.close()
connection.close()
