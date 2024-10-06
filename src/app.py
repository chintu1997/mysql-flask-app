from flask import Flask
import mysql.connector

app = Flask(__name__)

def connect_to_database():
    try:
        connection = mysql.connector.connect(
            host='mysql',
            user='root',
            password='password',
            database='test_database'
        )
        cursor = connection.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS test_database;")
        cursor.close()
        connection.close()
        return "Database connected successfully!"
    except mysql.connector.Error as err:
        return f"Error: {err}"

@app.route('/')
def hello_world():
    db_message = connect_to_database()
    return f"Hello, World!<br>{db_message}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
