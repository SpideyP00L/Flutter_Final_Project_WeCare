import 'package:flutter/material.dart';

class DoctorLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.50),
            end: Alignment(0, 1),
            colors: [Colors.white, Colors.white, Color(0xFF00FFFF)],
          ),
        ),
        child: Center(
          child: Text(
            'This is the Doctor Login Screen',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

