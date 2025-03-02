
# Ryan Monnier, Zachariah King, Jacob Achenbach
# CSD 310
# Bacchus Winery Project
# 21-Feb-2025



""" import statements """
import mysql.connector # to connect
from mysql.connector import errorcode
# importing os to handle relative file path locations
import os

# to use .env file
import dotenv 
from dotenv import dotenv_values

#make sure we can access are .env file, even if we aren't in the correct directory
pwd = "\\".join(os.path.realpath(__file__).split("\\")[:-1])

#using our .env file
secrets = dotenv_values(pwd + ".env")

# database params from .env
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True 
}

# function to connect to our database
def connect():
    try:
        db = mysql.connector.connect(**config)
        if db.is_connected():
            print(f"Connected to {secrets['DATABASE']} database")
            return db
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

# tables to get data from
tables = [
    'Employee',
    'Time_Card',
    'Distributor',
    'Wine',
    'Orders',
    'Wine_Sales',
    'Supplier',
    'Supply_Delivery',
    'Supply_Inventory',
    'Supply_Items'
]
# function to call 
def data(table_name):
    try:
        # call the connect() function
        connection = connect()
        if connection:
            # create a cursor object and return the results as dictionaries
            cursor = connection.cursor(dictionary=True)
            # select all data from table so taht we can print it
            query = f"SELECT * FROM {table_name};"
            cursor.execute(query)
            # gets all rows from the query result
            results = cursor.fetchall()

            print(f"\nData from {table_name} table:")
            # print each row of the results
            for i in results:
                print(i)

            # close cursor and connection
            cursor.close()
            connection.close() 
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# function to call data() for each table, which in turn calls connect() to establish/tear down the connection to the database
def print_data():
    for i in tables:
        data(i)

# call the main function
if __name__ == "__main__":
    print_data()