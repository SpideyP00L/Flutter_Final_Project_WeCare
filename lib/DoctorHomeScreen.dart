import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  List<Map<String, dynamic>> _patientsAnalysis = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientsAnalysis();
  }

  Future<void> _fetchPatientsAnalysis() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:9002/api/patients/analysis'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _patientsAnalysis = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load patients analysis');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Home'),
      ),
      body: _patientsAnalysis.isNotEmpty
          ? ListView.builder(
              itemCount: _patientsAnalysis.length,
              itemBuilder: (context, index) {
                final patientData = _patientsAnalysis[index]['patient'];
                final analysisData = _patientsAnalysis[index]['analysis'];
                return Column(
                  children: [
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: 10),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: MediaQuery.of(context).size.width > 600
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Patient Name: ${patientData['Patient_Name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Age: ${patientData['Patient_Age']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Gender: ${patientData['Patient_Gender']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Address: ${patientData['Patient_Address']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Phone Number: ${patientData['Patient_Phone_Number']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Patient Test Information',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        _buildTestResult(
                                          'Blood Pressure',
                                          patientData['Tests']
                                              ['Blood_Pressure'],
                                          analysisData['Blood_Pressure'],
                                        ),
                                        _buildTestResult(
                                          'Heart Rate',
                                          patientData['Tests']['Heart_Rate'],
                                          analysisData['Heart_Rate'],
                                        ),
                                        _buildTestResult(
                                          'Respiratory Rate',
                                          patientData['Tests']
                                              ['Respiratory_Rate'],
                                          analysisData['Respiratory_Rate'],
                                        ),
                                        _buildTestResult(
                                          'Oxygen Saturation',
                                          patientData['Tests']
                                              ['Oxygen_Saturation'],
                                          analysisData['Oxygen_Saturation'],
                                        ),
                                        _buildTestResult(
                                          'Body Temperature',
                                          patientData['Tests']
                                              ['Body_Temperature'],
                                          analysisData['Body_Temperature'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Patient Name: ${patientData['Patient_Name']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Age: ${patientData['Patient_Age']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Gender: ${patientData['Patient_Gender']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Address: ${patientData['Patient_Address']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Phone Number: ${patientData['Patient_Phone_Number']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Test Results:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  _buildTestResult(
                                    'Blood Pressure',
                                    patientData['Tests']['Blood_Pressure'],
                                    analysisData['Blood_Pressure'],
                                  ),
                                  _buildTestResult(
                                    'Heart Rate',
                                    patientData['Tests']['Heart_Rate'],
                                    analysisData['Heart_Rate'],
                                  ),
                                  _buildTestResult(
                                    'Respiratory Rate',
                                    patientData['Tests']['Respiratory_Rate'],
                                    analysisData['Respiratory_Rate'],
                                  ),
                                  _buildTestResult(
                                    'Oxygen Saturation',
                                    patientData['Tests']['Oxygen_Saturation'],
                                    analysisData['Oxygen_Saturation'],
                                  ),
                                  _buildTestResult(
                                    'Body Temperature',
                                    patientData['Tests']['Body_Temperature'],
                                    analysisData['Body_Temperature'],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Divider(),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildTestResult(String testName, num testValue, String analysis) {
    Color valueColor = Colors.black;
    Color analysisColor = Colors.black;

    switch (analysis) {
      case 'High':
      case 'Low':
        valueColor = Color.fromARGB(255, 255, 0, 0);
        analysisColor = Color.fromARGB(255, 255, 0, 0);
        break;
      case 'Normal':
        analysisColor = const Color.fromARGB(255, 0, 255, 8);
        break;
      default:
        break;
    }

    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '$testName: ',
                ),
                TextSpan(
                  text: '$testValue ',
                  style: TextStyle(color: valueColor),
                ),
                TextSpan(
                  text: analysis,
                  style: TextStyle(color: analysisColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}