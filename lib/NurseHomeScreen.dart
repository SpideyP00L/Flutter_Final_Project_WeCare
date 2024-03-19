import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurseHomeScreen extends StatefulWidget {
  final String email;

  NurseHomeScreen({required this.email});

  @override
  _NurseHomeScreenState createState() => _NurseHomeScreenState();
}

class _NurseHomeScreenState extends State<NurseHomeScreen> {
  int _selectedIndex = 0;

  late Widget _homeWidget;
  late Widget _addPatientWidget;

  @override
  void initState() {
    super.initState();
    _homeWidget = _buildHomeWidget();
    _addPatientWidget = _buildAddPatientWidget();
  }

  Widget _buildHomeWidget() {
    return FutureBuilder<String>(
      future: getNurseName(widget.email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final nurseName = snapshot.data!;
          return Center(
            // Wrap the Column with a Center widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, $nurseName!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Hope you are doing well today!',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }
      },
    );
  }

// Add Patient Screen
  Widget _buildAddPatientWidget() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _patientNameController = TextEditingController();
    TextEditingController _patientAgeController = TextEditingController();
    TextEditingController _patientAddressController = TextEditingController();
    TextEditingController _patientGenderController = TextEditingController();
    TextEditingController _patientPhoneNumberController =
        TextEditingController();

    Future<void> savePatientData() async {
      if (_formKey.currentState!.validate()) {
        final String patientName = _patientNameController.text;
        final int patientAge = int.parse(_patientAgeController.text);
        final String patientAddress = _patientAddressController.text;
        final String patientGender = _patientGenderController.text;
        final String patientPhoneNumber = _patientPhoneNumberController.text;

        final url = Uri.parse('http://127.0.0.1:9002/api/patient/save');
        try {
          final response = await http.post(
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

          if (response.statusCode == 201) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Patient data saved successfully'),
              ),
            );
          } else {
            throw Exception('Failed to save patient data: ${response.body}');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save patient data: $e'),
            ),
          );
        }
      }
    }

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        SizedBox(
          child: Image.asset(
            'New_Patient.png',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  onPressed: savePatientData,
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
                    'Save Patient Data',
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
    );
  }

  Future<String> getNurseName(String email) async {
    final url = Uri.parse('http://127.0.0.1:9002/api/nurse/name?email=$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['Nurse_Full_Name'];
      } else {
        throw Exception('Failed to fetch nurse name');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Home'),
        backgroundColor: Colors.blue,
      ),
      body: _selectedIndex == 0 ? _homeWidget : _addPatientWidget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Patient',
          ),
        ],
      ),
    );
  }
}
