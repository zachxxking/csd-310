""" import statements """
import mysql.connector # to connect
from mysql.connector import errorcode

import dotenv # to use .env file
from dotenv import dotenv_values

#using our .env file
secrets = dotenv_values(".env")

""" database config object """
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True #not in .env file
}

try:
    """ try/catch block for handling potential MySQL database errors """ 

    db = mysql.connector.connect(**config) # connect to the movies database

    
    # output the connection status 
    print("\n  Database user {} connected to MySQL on host {} with database {}\n".format(config["user"], config["host"], config["database"]))

    # cursor to retrieve all fields from Studio table
    print("--DISPLAYING Studio RECORDS--")
    cursor = db.cursor()
    cursor.execute("SELECT studio_id, studio_name FROM studio")
    studio = cursor.fetchall()
    for studio in studio:
        print("Studio ID: {}\n Studio Name: {}\n".format(studio[0], studio[1]))
        
    # cursor to retrieve all fields from Genre table
    print("--DISPLAYING Genre RECORDS--")
    cursor = db.cursor()
    cursor.execute("SELECT genre_id, genre_name FROM genre")
    genre = cursor.fetchall()
    for genre in genre:
        print("Genre ID: {}\n Genre Name: {}\n".format(genre[0], genre[1]))

    # cursor to retrieve movie names for films that are less than two hours
    print("--DISPLAYING Short Film RECORDS--")
    cursor = db.cursor()
    cursor.execute("SELECT film_name, film_runtime FROM film WHERE film_runtime < 120")
    film = cursor.fetchall()
    for film in film:
        print("Film Name: {}\n Runtime: {}\n".format(film[0], film[1]))
      
    # cursor to retrieve movie names and directors grouped by director
    print("--DISPLAYING Director RECORDS in Order--")
    cursor = db.cursor()
    cursor.execute("SELECT film_name, film_director FROM film ORDER BY film_director")
    film = cursor.fetchall()
    for film in film:
        print("Film Name: {}\n Director: {}\n".format(film[0], film[1]))
        
    input("\n\n  Press any key to continue...")

except mysql.connector.Error as err:
    """ on error code """

    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("  The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("  The specified database does not exist")

    else:
        print(err)

finally:
    """ close the connection to MySQL """

    db.close()
    