import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PatientTestInfoScreen.dart';
import 'UpdatePatientInfoScreen.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(Icons.person, size: 48),
          title: FutureBuilder<String>(
            future: getNurseName(widget.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final nurseName = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $nurseName!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Hope you are doing well today!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Expanded(
          child: _buildPatientList(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
          child: ElevatedButton(
            onPressed: deleteAllPatients,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Delete All Patients',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientList() {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalMargin = screenWidth * 0.05;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Patients Records :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: getAllPatients(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final patients = snapshot.data!;
                      return ListView.separated(
                        itemCount: patients.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              leading: Icon(Icons.person),
                              title: Text(
                                patient['Patient_Name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text('Age: ${patient['Patient_Age']}'),
                                  SizedBox(height: 4),
                                  Text(
                                      'Address: ${patient['Patient_Address']}'),
                                  SizedBox(height: 4),
                                  Text('Gender: ${patient['Patient_Gender']}'),
                                  SizedBox(height: 4),
                                  Text(
                                      'Phone Number: ${patient['Patient_Phone_Number']}'),
                                  SizedBox(height: 20),
                                  if (patient['Tests'] != null &&
                                      (patient['Tests'] as Map).isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                            'Blood Pressure:',
                                            patient['Tests']
                                                        ['Blood_Pressure'] !=
                                                    null
                                                ? patient['Tests']
                                                        ['Blood_Pressure']
                                                    .toString()
                                                : 'N/A'),
                                        _buildInfoRow(
                                            'Heart Rate:',
                                            patient['Tests']['Heart_Rate'] !=
                                                    null
                                                ? patient['Tests']['Heart_Rate']
                                                    .toString()
                                                : 'N/A'),
                                        _buildInfoRow(
                                            'Respiratory Rate:',
                                            patient['Tests']
                                                        ['Respiratory_Rate'] !=
                                                    null
                                                ? patient['Tests']
                                                        ['Respiratory_Rate']
                                                    .toString()
                                                : 'N/A'),
                                        _buildInfoRow(
                                            'Oxygen Saturation:',
                                            patient['Tests']
                                                        ['Oxygen_Saturation'] !=
                                                    null
                                                ? patient['Tests']
                                                        ['Oxygen_Saturation']
                                                    .toString()
                                                : 'N/A'),
                                        _buildInfoRow(
                                            'Body Temperature:',
                                            patient['Tests']
                                                        ['Body_Temperature'] !=
                                                    null
                                                ? patient['Tests']
                                                        ['Body_Temperature']
                                                    .toString()
                                                : 'N/A'),
                                      ],
                                    ),
                                  if (patient['Tests'] == null ||
                                      (patient['Tests'] as Map).isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdatePatientInfoScreen(
                                                  patientId: patient['_id']),
                                        ),
                                      );
                                      setState(() {
                                        _homeWidget = _buildHomeWidget();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deletePatient(patient['_id']);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientTestInfoScreen(
                                        patientId: patient['_id']),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4),
        Text(value),
      ],
    );
  }

  Future<void> deletePatient(String id) async {
    final url = Uri.parse('http://127.0.0.1:9002/api/patient/delete/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient deleted successfully'),
          ),
        );
        // Update the list of patients after deleting a patient
        setState(() {
          _homeWidget = _buildHomeWidget(); // Rebuild the home widget
        });
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete patient: $e'),
        ),
      );
    }
  }

  Future<void> deleteAllPatients() async {
    final url = Uri.parse('http://127.0.0.1:9002/api/patients/delete-all');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All patients deleted successfully'),
          ),
        );
        // Update the list of patients after deleting all patients
        setState(() {
          _homeWidget = _buildHomeWidget(); // Rebuild the home widget
        });
      } else {
        throw Exception('Failed to delete all patients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete all patients: $e'),
        ),
      );
    }
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

            // Update the list of patients after saving a new patient
            setState(() {
              _homeWidget = _buildHomeWidget(); // Rebuild the home widget
            });
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
                    backgroundColor: Colors.transparent,
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

Future<List<dynamic>> getAllPatients() async {
  final url = Uri.parse('http://127.0.0.1:9002/api/patients');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch patients');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
