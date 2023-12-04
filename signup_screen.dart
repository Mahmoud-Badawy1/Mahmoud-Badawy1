import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers to retrieve the current value of TextFormFields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Retrieve user input from the text fields
                  final String firstName = _firstNameController.text;
                  final String lastName = _lastNameController.text;
                  final String email = _emailController.text;
                  final String password = _passwordController.text;

                  // Call the signUp method from the UserProvider
                  Provider.of<UserProvider>(context, listen: false)
                      .signUp(firstName, lastName, email, password)
                      .then((_) {
                    // After successful sign up, navigate to the home page or login page
                    Navigator.pushReplacementNamed(context, '/login');
                  }).catchError((error) {
                    // If an error occurs, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to sign up: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
