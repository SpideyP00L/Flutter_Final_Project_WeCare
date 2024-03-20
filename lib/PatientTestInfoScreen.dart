import 'package:flutter/material.dart';

class PatientTestInfoScreen extends StatelessWidget {
  final String patientId;

  PatientTestInfoScreen({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Test Info'),
      ),
      body: Center(
        child: Text('Patient ID: $patientId'),
      ),
    );
  }
}
