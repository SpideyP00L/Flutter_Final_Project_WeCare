import 'package:flutter/material.dart';

class UpdatePatientTestScreen extends StatelessWidget {
  final String patientId;

  const UpdatePatientTestScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Update Test for Patient ID: $patientId',
              style: TextStyle(fontSize: 20),
            ),
            // Add your form fields or other widgets for updating a test here
          ],
        ),
      ),
    );
  }
}
