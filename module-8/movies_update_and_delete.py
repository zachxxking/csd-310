"""
Program: Movies Database
Author: Zachariah King
Date: 02/17/25
Description: This program connects to a database and then uses
            a function and a cursor to show the contents of that
            database multiple times with modifications each time.
"""

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

def show_films(cursor, title):
    # method to execute an inner join on all tables,
    #      iterate over the dataset and output the results to the terminal window.
        
    # inner join query
    cursor = db.cursor()
    cursor.execute("SELECT film_name AS Name, film_director AS Director, genre_name as Genre, studio_name AS 'Studio Name' FROM film INNER JOIN genre ON film.genre_id=genre.genre_id INNER JOIN studio ON film.studio_id=studio.studio_id")
    # get the results from the cursor object
    films = cursor.fetchall()
    print("\n -- {} --".format(title))
    #iterate over the film data set and display the results
    for film in films:
        print("Film Name: {}\nDirector: {}\nGenre Name ID: {}\nStudio Name: {}\n".format(film[0], film[1], film[2], film[3]))
            
try:
    """ try/catch block for handling potential MySQL database errors """ 

    db = mysql.connector.connect(**config) # connect to the movies database 
    
    # output the connection status 
    print("\n  Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))
    
    # Call show_films function initially and after each modification
    show_films(db.cursor(), "DISPLAYING FILMS")
    show_films(db.cursor(), "DISPLAYING FILMS AFTER INSERT")
    show_films(db.cursor(), "DISPLAYING FILMS AFTER UPDATE- Changed Alien to Horror")
    show_films(db.cursor(), "DISPLAYING FILMS AFTER DELETE")

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
    