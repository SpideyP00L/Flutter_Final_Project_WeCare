import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurseHomeScreen extends StatelessWidget {
  final String email;

  NurseHomeScreen({required this.email});

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getNurseName(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Nurse Home'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Nurse Home'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final nurseName = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Nurse Home'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, $nurseName! Hope you are doing well today!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
