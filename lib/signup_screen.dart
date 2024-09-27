import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFF0096C7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Color(0xFFADE8F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFADE8F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (val) =>
                    val != password ? 'Passwords do not match' : null,
                onChanged: (val) {
                  setState(() => confirmPassword = val);
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Color(0xFFADE8F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0096C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      setState(() => error = 'Please supply a valid email');
                    } else {
                      // Registration successful, return to login screen
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('Already have an account? Sign In'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
