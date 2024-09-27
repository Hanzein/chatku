import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              ElevatedButton(
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0096C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result =
                        await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() =>
                          error = 'Could not sign in with those credentials');
                    }
                    // If sign in is successful, the AuthWrapper will automatically navigate to ChatScreen
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
                child: Text('Don\'t have an account? Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
