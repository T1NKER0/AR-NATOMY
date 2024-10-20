import unittest
from app import app

class AppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_register_user(self):
        response = self.app.post('/register', json={
            'name': 'Test User',
            'username': 'testuser',
            'password': 'password123'
        })
        self.assertEqual(response.status_code, 200)

    def test_get_roles(self):
        response = self.app.get('/roles')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
