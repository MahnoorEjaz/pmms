// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:project/homepage.dart';
import 'package:project/mainmenu.dart';
import 'package:project/DesignerScreen.dart';
import 'package:project/PrinterScreen.dart';
import 'package:project/AdminScreen.dart';
import 'package:project/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/ApplyJob.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> loginUsers() async {
    try {
      // Check if email and password are not empty
      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        // Query Firestore for the user with the given email
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _emailController.text)
            .get();

        // Check if a user with the given email exists
        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first.data();

          // Check if the password matches
          if (userData['password'] == _passwordController.text) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // Store user information in shared preferences
            prefs.setString('userEmail', _emailController.text);
            prefs.setString('userPassword', _passwordController.text);

            // Successful login

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logged in successfully'),
                duration: Duration(seconds: 2),
              ),
            );

            // Check user role and navigate accordingly
            if (userData.containsKey("role")) {
              String userRole = userData["role"];
              switch (userRole) {
                case "user":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainmenuActivity(
                        userEmail: _emailController.text,
                        userPassword: _passwordController.text,
                      ),
                    ),
                  );
                  break;
                case "designer":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DesignerScreen(
                        userEmail: _emailController.text,
                        userPassword: _passwordController.text,
                      ),
                    ),
                  );
                  break;
                case "printer":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrinterScreen(
                        userEmail: _emailController.text,
                        userPassword: _passwordController.text,
                      ),
                    ),
                  );
                  break;
                default:
                // Handle other roles or show an error
                  print('Unknown role: $userRole');
              }
            }
          } else {
            // Incorrect password
            showLoginError('Invalid credentials');
          }
        } else {
          // User not found
          showLoginError('User not found');
        }
      } else {
        // Display a message if email or password is empty
        showLoginError('Please fill in both email and password.');
      }
    } catch (e) {
      // Handle other errors
      print('Error during login: $e');
      showLoginError('An unexpected error occurred');
    }
  }
  void showLoginError(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF880A35),
        automaticallyImplyLeading: false,
        title: Text('Print Express'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or image
              Image.asset(
                'assets/images/icon.png', // Replace with your image path
                height: 100.0, // Adjust the height as needed
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Email text field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              // Password text field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 32),
              // Login button
              ElevatedButton(
                onPressed: () {
                  // Add your login logic here
                  loginUser();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                  primary: Color(0xFF880A35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              // Link to sign-up page
              GestureDetector(
                onTap: () {
                  // Navigate to the sign-up screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  'Create an Account? Sign Up',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              // Link to apply for designer or printer
              GestureDetector(
                onTap: () {
                  // Navigate to the apply screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyScreen(),
                    ),
                  );
                },
                child: Text(
                  'Apply for designer or printer',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
























































































  void loginUser() async {
    if (!_emailController.text.isEmpty || !_passwordController.text.isEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      var response = await http.post(
        Uri.parse('http://192.168.225.207:3000/api/users/loginf'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      // Check if it's an admin login
      if (_emailController.text == 'admin' && _passwordController.text == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          ),
        );
      } else if (response.statusCode == 200) {
        // Successful login
        var userData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Check user role and navigate accordingly
        if (userData.containsKey("role")) {
          String userRole = userData["role"];
          switch (userRole) {
            case "user":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainmenuActivity(
                    userEmail: _emailController.text,
                    userPassword: _passwordController.text,
                  ),
                ),
              );
              break;
            case "designer":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DesignerScreen(
                    userEmail: _emailController.text,
                    userPassword: _passwordController.text,
                  ),
                ),
              );
              break;
            case "printer":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrinterScreen(
                    userEmail: _emailController.text,
                    userPassword: _passwordController.text,
                  ),
                ),
              );
              break;
            default:
            // Handle other roles or show an error
              print('Unknown role: $userRole');
          }
        }
      } else {
        // Unsuccessful login, show an error message
        print('Login failed');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid credentials'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Display a message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both email and password.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
