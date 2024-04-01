import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientTestInfoScreen extends StatefulWidget {
  final String patientId;

  PatientTestInfoScreen({required this.patientId});

  @override
  _PatientTestInfoScreenState createState() => _PatientTestInfoScreenState();
}

class _PatientTestInfoScreenState extends State<PatientTestInfoScreen> {
  late Future<Map<String, dynamic>> _futurePatientData;

  @override
  void initState() {
    super.initState();
    _futurePatientData = fetchPatientData();
  }

  Future<Map<String, dynamic>> fetchPatientData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:9002/api/patient/${widget.patientId}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _deleteTests(context);
      },
      child: Text('Delete Tests'),
    );
  }

  Future<void> _deleteTests(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:9002/api/patient/delete-tests/${widget.patientId}'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tests deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the patient data after deletion
        setState(() {
          _futurePatientData = fetchPatientData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete tests'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Test Info'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futurePatientData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final patientData = snapshot.data!;
              final isSmallScreen = MediaQuery.of(context).size.width < 600; // Adjust this threshold as needed
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 50), // Adjust padding based on screen size
                        child: isSmallScreen
                            ? _buildVerticalLayout(patientData)
                            : _buildHorizontalLayout(patientData),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildDeleteButton(context), // Add the delete button here
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildVerticalLayout(Map<String, dynamic> patientData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Patient ID:', widget.patientId),
        _buildInfoRow('Name:', patientData['Patient_Name']),
        _buildInfoRow('Age:', '${patientData['Patient_Age']} years'),
        _buildInfoRow('Address:', patientData['Patient_Address']),
        _buildInfoRow('Gender:', patientData['Patient_Gender']),
        _buildInfoRow('Phone Number:', patientData['Patient_Phone_Number']),
        SizedBox(height: 20),
        Text(
          'Test Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 20),
        if (patientData['Tests'] != null && (patientData['Tests'] as Map).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Blood Pressure:', patientData['Tests']['Blood_Pressure'] ?? 'N/A'),
              _buildInfoRow('Heart Rate:', patientData['Tests']['Heart_Rate'] ?? 'N/A'),
              _buildInfoRow('Respiratory Rate:', patientData['Tests']['Respiratory_Rate'] ?? 'N/A'),
              _buildInfoRow('Oxygen Saturation:', patientData['Tests']['Oxygen_Saturation'] ?? 'N/A'),
              _buildInfoRow('Body Temperature:', patientData['Tests']['Body_Temperature'] ?? 'N/A'),
            ],
          ),
        if (patientData['Tests'] == null || (patientData['Tests'] as Map).isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No Tests Have Been Taken, Please Add Tests Data',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalLayout(Map<String, dynamic> patientData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Patient ID:', widget.patientId),
              _buildInfoRow('Name:', patientData['Patient_Name']),
              _buildInfoRow('Age:', '${patientData['Patient_Age']} years'),
              _buildInfoRow('Address:', patientData['Patient_Address']),
              _buildInfoRow('Gender:', patientData['Patient_Gender']),
              _buildInfoRow('Phone Number:', patientData['Patient_Phone_Number']),
            ],
          ),
        ),
        VerticalDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              if (patientData['Tests'] != null && (patientData['Tests'] as Map).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Blood Pressure:', patientData['Tests']['Blood_Pressure'] ?? 'N/A'),
                    _buildInfoRow('Heart Rate:', patientData['Tests']['Heart_Rate'] ?? 'N/A'),
                    _buildInfoRow('Respiratory Rate:', patientData['Tests']['Respiratory_Rate'] ?? 'N/A'),
                    _buildInfoRow('Oxygen Saturation:', patientData['Tests']['Oxygen_Saturation'] ?? 'N/A'),
                    _buildInfoRow('Body Temperature:', patientData['Tests']['Body_Temperature'] ?? 'N/A'),
                  ],
                ),
              if (patientData['Tests'] == null || (patientData['Tests'] as Map).isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No Tests Have Been Taken, Please Add Tests Data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
