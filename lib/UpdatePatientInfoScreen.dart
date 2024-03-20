import 'package:flutter/material.dart';

class UpdatePatientInfoScreen extends StatelessWidget {
  final String patientId;

  UpdatePatientInfoScreen({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Patient Info'),
      ),
      body: Center(
        child: Text('Patient ID: $patientId'),
      ),
    );
  }
}
