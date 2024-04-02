import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UpdatePatientTestScreen extends StatefulWidget {
  final String patientId;

  const UpdatePatientTestScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _UpdatePatientTestScreenState createState() => _UpdatePatientTestScreenState();
}


class _UpdatePatientTestScreenState extends State<UpdatePatientTestScreen> {
  late Future<Map<String, dynamic>> _futurePatientData;

  @override
  void initState() {
    super.initState();
    _futurePatientData = fetchPatientData();
  }

  Future<Map<String, dynamic>> fetchPatientData() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:9002/api/patient/${widget.patientId}'),
    );
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
        title: Text('Update Test'),
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
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          // Large screen layout (Horizontal)
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPatientInfo(patientData),
                              ),
                              Expanded(
                                child: _buildTestInfo(patientData),
                              ),
                            ],
                          );
                        } else {
                          // Small screen layout (Vertical)
                          return ListView(
                            children: [
                              _buildPatientInfo(patientData),
                              SizedBox(height: 20),
                              _buildTestInfo(patientData),
                            ],
                          );
                        }
                      },
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

  Widget _buildPatientInfo(Map<String, dynamic> patientData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
          _buildInfoRow('Patient ID:', widget.patientId),
          _buildInfoRow('Name:', patientData['Patient_Name']),
          _buildInfoRow('Age:', '${patientData['Patient_Age']} years'),
          _buildInfoRow('Address:', patientData['Patient_Address']),
          _buildInfoRow('Gender:', patientData['Patient_Gender']),
          _buildInfoRow('Phone Number:', patientData['Patient_Phone_Number']),
        ],
      ),
    );
  }

  Widget _buildTestInfo(Map<String, dynamic> patientData) {
    final bloodPressureController = TextEditingController();
    final heartRateController = TextEditingController();
    final respiratoryRateController = TextEditingController();
    final oxygenSaturationController = TextEditingController();
    final bodyTemperatureController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                _buildTextField('Blood Pressure:', bloodPressureController, patientData['Tests']['Blood_Pressure']),
                _buildTextField('Heart Rate:', heartRateController, patientData['Tests']['Heart_Rate']),
                _buildTextField('Respiratory Rate:', respiratoryRateController, patientData['Tests']['Respiratory_Rate']),
                _buildTextField('Oxygen Saturation:', oxygenSaturationController, patientData['Tests']['Oxygen_Saturation']),
                _buildTextField('Body Temperature:', bodyTemperatureController, patientData['Tests']['Body_Temperature']),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Update tests data
                    updatePatientTests(
                      bloodPressureController.text,
                      heartRateController.text,
                      respiratoryRateController.text,
                      oxygenSaturationController.text,
                      bodyTemperatureController.text,
                    );
                  },
                  child: Text('Update Tests'),
                ),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, dynamic initialValue) {
    controller.text = initialValue.toString(); // Initialize text field with initial value

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
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number, // Set keyboard type to number
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
        ],
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

  void updatePatientTests(String bloodPressure, String heartRate, String respiratoryRate, String oxygenSaturation, String bodyTemperature) async {
    final tests = {
      'Blood_Pressure': double.parse(bloodPressure),
      'Heart_Rate': double.parse(heartRate),
      'Respiratory_Rate': double.parse(respiratoryRate),
      'Oxygen_Saturation': double.parse(oxygenSaturation),
      'Body_Temperature': double.parse(bodyTemperature),
    };

    print('Test Data to be sent to server: $tests');

    try {
      // Encode the tests object to JSON string
      final testsJson = jsonEncode({'tests': tests});

      // Example of sending test data to server
      final response = await http.put(
        Uri.parse('http://127.0.0.1:9002/api/patient/update-tests/${widget.patientId}'),
        headers: {'Content-Type': 'application/json'}, // Specify content type as JSON
        body: testsJson, // Send tests data as JSON string with 'tests' key
      );

      print('Response from server: ${response.body}');

      if (response.statusCode == 200) {
        // Tests updated successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tests updated successfully'),
          duration: Duration(seconds: 2),
        ));
      } else {
        // Failed to update tests
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update tests'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (error) {
      // Catch any exceptions during HTTP request
      print('Error during HTTP request: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
