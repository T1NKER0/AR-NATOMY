from flask import Flask, request, jsonify, render_template, session, redirect, url_for, flash
from models import db, create_default_user, User, Role, UserRole  # Import the necessary models and db instance
from werkzeug.security import generate_password_hash

app = Flask(__name__)

# Configure the database URI
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:Marcos0206@127.0.0.1/arnatomy'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = 'your_secret_key_here'  # Secret key for session management
db.init_app(app)  # Initialize the db instance with the app

# Push context manually to app
with app.app_context():
    db.create_all()  # Create the database tables
    create_default_user()  # Check and create the default admin user

# Root endpoint
@app.route('/', methods=['GET'])
def home():
    return render_template('index.html')  # Render the HTML page

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password):  # Assuming you have a method to check passwords
            session['username'] = user.username
            
            # Fetch and set the user's role
            role = db.session.query(Role).join(User.roles).filter(User.id == user.id).first()
            if role:
                session['role'] = role.role_name  # Set 'role' for consistency
            else:
                session['role'] = 'user'  # Default role if none found
            
            print(f"User logged in: {session['username']}, Role: {session['role']}")  # Debug print
            
            return redirect(url_for('main_menu'))

    return render_template('login.html')

@app.route('/logout')  # Ensure this route is defined
def logout():
    # Clear the session
    session.clear()
    return redirect(url_for('login'))  # Redirect to login page


@app.route('/userValidation', methods=['GET', 'POST'])
def user_validation():
    if request.method == 'POST':
        username = request.form.get('username')
        
        if not username:
            return "No username provided in POST request", 400

        # Store the username in session for further use
        session['username'] = username
    else:
        username = session.get('username')

    if not username:
        return redirect(url_for('login'))

    # Query the user by username
    user = User.query.filter_by(username=username).first()

    if user:
        # Ensure to use the proper relationship for roles
        roles = user.roles  # Assuming a many-to-many relationship
        if roles:
            # Check for all roles associated with the user
            role_names = [role.role.role_name for role in roles]  # Get a list of role names
            session['role'] = role_names  # Store all roles in session
            
            # Flash all roles or just the first one based on your requirement
            flash(f"User role(s) validated: {', '.join(role_names)}")  # Flashing the role names
            
            return redirect(url_for('main_menu'))
        else:
            return "No roles found for user", 404
    else:
        return "User not found", 404




# Route for the main menu
@app.route('/mainMenu', methods=['GET'])
def main_menu():
    if 'username' not in session:
        return redirect(url_for('login'))

    # Fetch the role from the session
    role = session.get('role', [])  # Ensure this matches how you set the role in the session

    if 'administrator' in role:
        message = f"Welcome, Admin! Your role is: {role}"
        show_add_user_button = True  # Show button for admin
    else:
        message = f"Welcome, User! Your role is: {role}"
        show_add_user_button = False  # Do not show button for regular users

    return render_template('main_menu.html', message=message, show_add_user_button=show_add_user_button)



@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    username = session.get('username')

    if not username:
        return redirect(url_for('login'))

    user = User.query.filter_by(username=username).first()

    if user:
        roles = db.session.query(Role).join(UserRole).filter(UserRole.user_id == user.id).all()
        is_admin = any(role.role_name == 'administrator' for role in roles)

        if not is_admin:
            flash("You do not have permission to access this page.", "danger")
            return redirect(url_for('main_menu'))

        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            role_name = request.form['role']
            name = request.form.get('name')  # Make sure to get the name from the form

            if not username or not password or not role_name or not name:
                flash("All fields are required.", "danger")
                return redirect(url_for('add_user'))

            hashed_password = generate_password_hash(password)
            new_user = User(name=name, username=username, hash=hashed_password)

            # Find the role
            role = Role.query.filter_by(role_name=role_name).first()
            if not role:
                flash("Role does not exist.", "danger")
                return redirect(url_for('add_user'))

            # Create UserRole association instead of appending to roles
            user_role = UserRole(user=new_user, role=role)
            db.session.add(user_role)  # Add the association to the session

            db.session.add(new_user)  # Add the new user to the session
            db.session.commit()  # Commit changes to the database

            flash("User added successfully!", "success")
            return redirect(url_for('main_menu'))

        all_roles = Role.query.all()
        return render_template('add_user.html', roles=all_roles)

    return "User not found", 404





# Endpoint to test database connection
@app.route('/test-db', methods=['GET'])
def test_db_connection():
    try:
        connection = db.engine.connect()  # Check if the connection can be made
        connection.close()  # Close the connection
        return jsonify({"success": "Connected to database!"}), 200
    except Exception as e:
        return jsonify({"error": f"Failed to connect to database: {e}"}), 500

if __name__ == '__main__':
    app.run(debug=True)
