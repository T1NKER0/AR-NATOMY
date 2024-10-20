from flask import Blueprint, request, jsonify
import mysql.connector
from mysql.connector import Error
import hashlib
from config import Config

user_routes = Blueprint('user_routes', __name__)

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=Config.HOST,
            database=Config.DATABASE,
            user=Config.USER,
            password=Config.PASSWORD
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL database: {e}")
        return None

# Endpoint to register a new user
@user_routes.route('/register', methods=['POST'])
def register_user():
    data = request.json
    name = data.get('name')
    username = data.get('username')
    password = data.get('password')  # Ensure to hash this password
    hashed_password = hashlib.sha256(password.encode()).hexdigest()

    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "Failed to connect to database"}), 500

    try:
        cursor = connection.cursor()
        insert_user_query = "INSERT INTO users (name, username, hash) VALUES (%s, %s, %s)"
        cursor.execute(insert_user_query, (name, username, hashed_password))
        user_id = cursor.lastrowid  # Get the ID of the new user
        connection.commit()

        # Assign default role (example: student)
        default_role_id = 1  # Assuming 1 is the ID for student role
        insert_role_query = "INSERT INTO user_roles (user_id, role_id) VALUES (%s, %s)"
        cursor.execute(insert_role_query, (user_id, default_role_id))
        connection.commit()

        return jsonify({"success": True, "message": "User registered successfully"})
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Endpoint to get all roles
@user_routes.route('/roles', methods=['GET'])
def get_roles():
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "Failed to connect to database"}), 500

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM roles")
        roles = cursor.fetchall()
        return jsonify(roles)
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Endpoint to upload a grade
@user_routes.route('/grades', methods=['POST'])
def upload_grade():
    data = request.json
    student_id = data.get('student_id')
    grade = data.get('grade')

    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "Failed to connect to database"}), 500

    try:
        cursor = connection.cursor()
        insert_query = "INSERT INTO grades (student_id, grade) VALUES (%s, %s)"
        cursor.execute(insert_query, (student_id, grade))
        connection.commit()
        return jsonify({"success": True, "message": "Grade uploaded successfully"})
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
