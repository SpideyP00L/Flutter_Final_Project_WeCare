import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> DoctorNewLoginData(
    String Doctor_Full_Name, String Doctor_Email, String Doctor_Password) async {
  final url = Uri.parse('http://127.0.0.1:9002/api/doctor/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Doctor_Full_Name': Doctor_Full_Name,
        'Doctor_Email': Doctor_Email,
        'Doctor_Password': Doctor_Password,
      }),
    );

    if (response.statusCode == 201) {
      print('New Doctor Login Created successfully with data: \n Doctor Full Name : $Doctor_Full_Name, \n Doctor Email ID: $Doctor_Email, \n Doctor Password: $Doctor_Password');
    } else {
      throw Exception('Failed to Create New Doctor Login: ${response.body}');
    }
  } catch (e) {
    print('Error In Creating New Doctor Login : $e');
    throw Exception('Failed to Create New Doctor Login: $e');
  }
}

class DoctorNewLoginScreen extends StatefulWidget {
  const DoctorNewLoginScreen({Key? key}) : super(key: key);

  @override
  State<DoctorNewLoginScreen> createState() => _DoctorNewLoginScreenState();
}

class _DoctorNewLoginScreenState extends State<DoctorNewLoginScreen> {
  final _DoctorCreateNewAccountKey = GlobalKey<FormState>();

  late TextEditingController _DoctorFullNameController;
  late TextEditingController _DoctorEmailController;
  late TextEditingController _DoctorPasswordController;
  late TextEditingController _ConfirmPasswordController;

  @override
  void initState() {
    super.initState();
    _DoctorFullNameController = TextEditingController();
    _DoctorEmailController = TextEditingController();
    _DoctorPasswordController = TextEditingController();
    _ConfirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _DoctorFullNameController.dispose();
    _DoctorEmailController.dispose();
    _DoctorPasswordController.dispose();
    _ConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Doctor Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -2.50),
            end: Alignment(0, 1),
            colors: [Colors.white, Colors.white, Color(0xFF00FFFF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Form(
                key: _DoctorCreateNewAccountKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Image.asset(
                        'Doctor.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextFormField(
                      controller: _DoctorFullNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Doctor Full Name',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _DoctorEmailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Doctor Email ID',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _DoctorPasswordController,
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _ConfirmPasswordController,
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _DoctorPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_DoctorCreateNewAccountKey.currentState!.validate()) {
                            try {
                              await DoctorNewLoginData(
                                _DoctorFullNameController.text,
                                _DoctorEmailController.text,
                                _DoctorPasswordController.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sign Up Successful'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to sign up: $e'),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color(0xFFCED5FF);
                              }
                              return Colors.white;
                            },
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
