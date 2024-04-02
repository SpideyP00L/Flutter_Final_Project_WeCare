import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> NurseNewLoginData(
    String Nurse_Full_Name, String Nurse_Email, String Nurse_Password) async {
  final url = Uri.parse('http://127.0.0.1:9002/api/nurse/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Nurse_Full_Name': Nurse_Full_Name,
        'Nurse_Email': Nurse_Email,
        'Nurse_Password': Nurse_Password,
      }),
    );

    if (response.statusCode == 201) {
      print('New Nurse Login Created successfully with data: \n Nurse Full Name : $Nurse_Full_Name, \n Nurse Email ID: $Nurse_Email, \n Nurse Password: $Nurse_Password');
    } else {
      throw Exception('Failed to Create New Nurse Login: ${response.body}');
    }
  } catch (e) {
    print('Error In Creating New Nurse Login : $e');
    throw Exception('Failed to Create New Nurse Login: $e');
  }
}

class NurseNewLoginScreen extends StatefulWidget {
  const NurseNewLoginScreen({Key? key}) : super(key: key);

  @override
  State<NurseNewLoginScreen> createState() => _NurseNewLoginScreenState();
}

class _NurseNewLoginScreenState extends State<NurseNewLoginScreen> {
  final _NurseCreateNewAccountKey = GlobalKey<FormState>();

  late TextEditingController _NurseFullNameController;
  late TextEditingController _NurseEmailController;
  late TextEditingController _NursePasswordController;
  late TextEditingController _ConfirmPasswordController;

  @override
  void initState() {
    super.initState();
    _NurseFullNameController = TextEditingController();
    _NurseEmailController = TextEditingController();
    _NursePasswordController = TextEditingController();
    _ConfirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _NurseFullNameController.dispose();
    _NurseEmailController.dispose();
    _NursePasswordController.dispose();
    _ConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Nurse Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -2.50),
            end: Alignment(0, 1),
            colors: [Colors.white, Colors.white, Color(0xFFFFD7E9)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Form(
                key: _NurseCreateNewAccountKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Image.asset(
                        'Nurse.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextFormField(
                      controller: _NurseFullNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Nurse Full Name',
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
                      controller: _NurseEmailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Nurse Email ID',
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
                      controller: _NursePasswordController,
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
                        } else if (value != _NursePasswordController.text) {
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
                          if (_NurseCreateNewAccountKey.currentState!.validate()) {
                            try {
                              await NurseNewLoginData(
                                _NurseFullNameController.text,
                                _NurseEmailController.text,
                                _NursePasswordController.text,
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
                          backgroundColor: Colors.transparent,
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
