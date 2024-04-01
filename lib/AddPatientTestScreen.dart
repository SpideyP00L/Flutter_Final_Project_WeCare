import 'package:flutter/material.dart';

class AddPatientTestScreen extends StatelessWidget {
  final String patientId;

  const AddPatientTestScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Test for Patient ID: $patientId',
              style: TextStyle(fontSize: 20),
            ),
            // Add your form fields or other widgets for adding a test here
          ],
        ),
      ),
    );
  }
}
