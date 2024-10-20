from flask import Blueprint

# Create a blueprint for user-related routes
user_routes = Blueprint('user_routes', __name__)

from .user_routes import *  # Import user routes

