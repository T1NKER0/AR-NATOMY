from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash

db = SQLAlchemy()  # Create a SQLAlchemy instance

# Define your models here
class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    username = db.Column(db.String(255), unique=True, nullable=False)
    hash = db.Column(db.String(255), nullable=False)

    # Establish relationships
    roles = db.relationship('UserRole', back_populates='user', cascade='all, delete-orphan')
    grades = db.relationship('Grade', back_populates='student', cascade='all, delete-orphan')

class Role(db.Model):
    __tablename__ = 'roles'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    role_name = db.Column(db.String(255), unique=True, nullable=False)

    # Establish relationship
    users = db.relationship('UserRole', back_populates='role', cascade='all, delete-orphan')

class UserRole(db.Model):
    __tablename__ = 'user_roles'

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), primary_key=True)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), primary_key=True)

    # Establish relationships
    user = db.relationship('User', back_populates='roles')
    role = db.relationship('Role', back_populates='users')

class Grade(db.Model):
    __tablename__ = 'grades'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    student_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    grade = db.Column(db.Numeric(4, 2), nullable=False)

    # Establish relationship
    student = db.relationship('User', back_populates='grades')

def create_default_user():
    # Check if the 'admin' role exists
    admin_role = Role.query.filter_by(role_name='administrator').first()

    if not admin_role:
        admin_role = Role(role_name='administrator')
        db.session.add(admin_role)
        db.session.commit()

    # Check if the 'admin' user exists
    admin_user = User.query.filter_by(username='admin').first()

    if not admin_user:
        hashed_password = generate_password_hash('admin')  # Hash the password
        new_admin = User(name='Administrator', username='admin', hash=hashed_password)
        db.session.add(new_admin)
        db.session.commit()  # Commit new user to the database

        # Create a UserRole association for the new admin user
        user_role = UserRole(user_id=new_admin.id, role_id=admin_role.id)
        db.session.add(user_role)
        db.session.commit()  # Commit the association to the database

        print("Default admin user and role created.")
    else:
        print("Admin user already exists.")
