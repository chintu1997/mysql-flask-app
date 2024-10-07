from flask import Flask
import mysql.connector
from mysql.connector import Error
import os
import logging

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

MYSQL_HOST = os.getenv('MYSQL_HOST', 'mysql')
MYSQL_USER = os.getenv('MYSQL_USER', 'root')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', 'password')
MYSQL_DATABASE = os.getenv('MYSQL_DATABASE', 'test_database')

def connect_to_database():
    connection = None
    try:
        logger.info("Connecting to MySQL server...")
        connection = mysql.connector.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD
        )
        cursor = connection.cursor()
        
        logger.info(f"Creating database '{MYSQL_DATABASE}' if it doesn't exist...")
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {MYSQL_DATABASE};")
        
        cursor.close()
        connection.close()
        
        logger.info(f"Connecting to the '{MYSQL_DATABASE}' database...")
        connection = mysql.connector.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD,
            database=MYSQL_DATABASE
        )
        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE();")
        record = cursor.fetchone()
        logger.info(f"Successfully connected to database: {record[0]}")
        return f"Connected to database: {record[0]}"
    except Error as e:
        logger.error(f"Error connecting to the database: {e}")
        return f"Error: {e}"
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()
            logger.info("MySQL connection is closed.")

@app.route('/')
def hello_world():
    db_status = connect_to_database()
    return f"Hello, world! {db_status}"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
