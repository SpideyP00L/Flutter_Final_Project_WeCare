import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPatientTestScreen extends StatefulWidget {
  final String patientId;

  const AddPatientTestScreen({Key? key, required this.patientId})
      : super(key: key);

  @override
  _AddPatientTestScreenState createState() => _AddPatientTestScreenState();
}

class _AddPatientTestScreenState extends State<AddPatientTestScreen> {
  late Future<Map<String, dynamic>> _futurePatientData;
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController respiratoryRateController = TextEditingController();
  TextEditingController oxygenSaturationController = TextEditingController();
  TextEditingController bodyTemperatureController = TextEditingController();
  Map<String, String> errorMessages = {};

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

  Widget _buildInfoRow(String label, String value, {String? errorMessage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                value.isEmpty ? 'N/A' : value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (errorMessage != null)
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen =
        screenSize.width < 600; // Adjust this threshold as needed

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Information'),
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
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: isSmallScreen
                        ? _buildVerticalLayout(patientData)
                        : _buildHorizontalLayout(patientData),
                  ),
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
        _buildInfoRow('Name:', patientData['Patient_Name'] ?? 'N/A'),
        _buildInfoRow('Age:', '${patientData['Patient_Age']} years'),
        _buildInfoRow('Address:', patientData['Patient_Address'] ?? 'N/A'),
        _buildInfoRow('Gender:', patientData['Patient_Gender'] ?? 'N/A'),
        _buildInfoRow(
            'Phone Number:', patientData['Patient_Phone_Number'] ?? 'N/A'),
        SizedBox(height: 40),
        Text(
          'Patient Test Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 20),
        _buildTestFields(),
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
              _buildInfoRow('Name:', patientData['Patient_Name'] ?? 'N/A'),
              _buildInfoRow('Age:', '${patientData['Patient_Age']} years'),
              _buildInfoRow(
                  'Address:', patientData['Patient_Address'] ?? 'N/A'),
              _buildInfoRow('Gender:', patientData['Patient_Gender'] ?? 'N/A'),
              _buildInfoRow('Phone Number:',
                  patientData['Patient_Phone_Number'] ?? 'N/A'),
            ],
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Test Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              _buildTestFields(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: bloodPressureController,
          decoration: InputDecoration(
            labelText: 'Blood Pressure',
            hintText: 'Enter blood pressure',
            errorText: errorMessages['Blood Pressure'],
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: heartRateController,
          decoration: InputDecoration(
            labelText: 'Heart Rate',
            hintText: 'Enter heart rate',
            errorText: errorMessages['Heart Rate'],
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: respiratoryRateController,
          decoration: InputDecoration(
            labelText: 'Respiratory Rate',
            hintText: 'Enter respiratory rate',
            errorText: errorMessages['Respiratory Rate'],
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: oxygenSaturationController,
          decoration: InputDecoration(
            labelText: 'Oxygen Saturation',
            hintText: 'Enter oxygen saturation',
            errorText: errorMessages['Oxygen Saturation'],
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: bodyTemperatureController,
          decoration: InputDecoration(
            labelText: 'Body Temperature',
            hintText: 'Enter body temperature',
            errorText: errorMessages['Body Temperature'],
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Perform the saving operation here
            savePatientTests();
          },
          child: Text('Save Tests'),
        ),
      ],
    );
  }

  void savePatientTests() async {
    errorMessages = {
      'Blood Pressure': _validateInput(bloodPressureController.text),
      'Heart Rate': _validateInput(heartRateController.text),
      'Respiratory Rate': _validateInput(respiratoryRateController.text),
      'Oxygen Saturation': _validateInput(oxygenSaturationController.text),
      'Body Temperature': _validateInput(bodyTemperatureController.text),
    };

    if (_validateForm()) {
      final tests = {
        'Blood_Pressure': double.parse(bloodPressureController.text),
        'Heart_Rate': double.parse(heartRateController.text),
        'Respiratory_Rate': double.parse(respiratoryRateController.text),
        'Oxygen_Saturation': double.parse(oxygenSaturationController.text),
        'Body_Temperature': double.parse(bodyTemperatureController.text),
      };

      print('Test Data to be sent to server: $tests');

      try {
        // Encode the tests object to JSON string
        final testsJson = jsonEncode({'tests': tests});

        // Example of sending test data to server
        final response = await http.post(
          Uri.parse(
              'http://127.0.0.1:9002/api/patient/add-tests/${widget.patientId}'),
          headers: {
            'Content-Type': 'application/json'
          }, // Specify content type as JSON
          body: testsJson, // Send tests data as JSON string with 'tests' key
        );

        print('Response from server: ${response.body}');

        if (response.statusCode == 201) {
          // Tests saved successfully
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Tests saved successfully'),
            duration: Duration(seconds: 2),
          ));
          // Clear text fields after saving tests
          bloodPressureController.clear();
          heartRateController.clear();
          respiratoryRateController.clear();
          oxygenSaturationController.clear();
          bodyTemperatureController.clear();
        } else {
          // Failed to save tests
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to save tests'),
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
    } else {
      setState(() {});
    }
  }

  String _validateInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a value';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return ''; // Return an empty string if no error
  }

  bool _validateForm() {
    return errorMessages.values.every((message) => message.isEmpty);
  }
}
