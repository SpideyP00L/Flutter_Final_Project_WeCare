import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePatientInfoScreen extends StatefulWidget {
  final String patientId;

  UpdatePatientInfoScreen({required this.patientId});

  @override
  _UpdatePatientInfoScreenState createState() =>
      _UpdatePatientInfoScreenState();
}

class _UpdatePatientInfoScreenState extends State<UpdatePatientInfoScreen> {
  late Future<Map<String, dynamic>> _futurePatientData;

  @override
  void initState() {
    super.initState();
    _futurePatientData = fetchPatientData();
  }

  Future<Map<String, dynamic>> fetchPatientData() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:9002/api/patient/${widget.patientId}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Patient Info'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futurePatientData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final patientData = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
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
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 50,
                              end: 50,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Patient ID:', widget.patientId),
                                _buildInfoRow(
                                  'Name:',
                                  patientData['Patient_Name'],
                                ),
                                _buildInfoRow(
                                  'Age:',
                                  '${patientData['Patient_Age']} years',
                                ),
                                _buildInfoRow(
                                  'Address:',
                                  patientData['Patient_Address'],
                                ),
                                _buildInfoRow(
                                  'Gender:',
                                  patientData['Patient_Gender'],
                                ),
                                _buildInfoRow(
                                  'Phone Number:',
                                  patientData['Patient_Phone_Number'],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildUpdatePatientWidget(),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
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

  Widget _buildUpdatePatientWidget() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _patientNameController = TextEditingController();
    TextEditingController _patientAgeController = TextEditingController();
    TextEditingController _patientAddressController = TextEditingController();
    TextEditingController _patientGenderController = TextEditingController();
    TextEditingController _patientPhoneNumberController =
        TextEditingController();

    Future<void> updatePatientData() async {
      if (_formKey.currentState!.validate()) {
        final String patientName = _patientNameController.text;
        final int patientAge = int.parse(_patientAgeController.text);
        final String patientAddress = _patientAddressController.text;
        final String patientGender = _patientGenderController.text;
        final String patientPhoneNumber = _patientPhoneNumberController.text;

        final url = Uri.parse(
            'http://127.0.0.1:9002/api/patient/update/${widget.patientId}');
        try {
          final response = await http.put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'Patient_Name': patientName,
              'Patient_Age': patientAge,
              'Patient_Address': patientAddress,
              'Patient_Gender': patientGender,
              'Patient_Phone_Number': patientPhoneNumber,
            }),
          );

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Patient data updated successfully'),
              ),
            );
          } else {
            throw Exception('Failed to update patient data: ${response.body}');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update patient data: $e'),
            ),
          );
        }
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 1, // Adjust height as needed
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 50),
          Text(
            'Update Patient Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _patientNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
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
                      return 'Please enter patient name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _patientAgeController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Patient Age',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _patientAddressController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Patient Address',
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
                      return 'Please enter patient address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _patientGenderController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Patient Gender',
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
                      return 'Please enter patient gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _patientPhoneNumberController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Patient Phone Number',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                Container(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: updatePatientData,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFFCED5FF);
                          }
                          return Colors.white;
                        },
                      ),
                    ),
                    child: Text(
                      'Update Patient Info',
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
        ],
      ),
    );
  }
}
