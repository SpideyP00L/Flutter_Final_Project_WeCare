import 'package:flutter/material.dart';

class NurseLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Login'),
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
          child: Text(
            'This is the Nurse Login Screen',
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
