import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data Upload API'),
      ),
      body: Stack(
        children: [
          // Background logo with fixed width
          Center(
            child: Opacity(
              opacity: 0.2, // make it faded
              child: Image.asset(
                "assets/logo.png",
                width: 600, // fixed width
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Foreground form
          const Center(
            child: StudentForm(),
          ),
        ],
      ),
    );
  }
}

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  void sendStudentData() async {
    Map<String, dynamic> data = {
      'name': nameController.text,
      'roll': rollController.text,
      'id': idController.text,
    };

    await uploadData(apiUrl, data);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Upload to API Screen building");
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Student Name'),
          ),
          TextField(
            controller: rollController,
            decoration: const InputDecoration(labelText: 'Roll'),
          ),
          TextField(
            controller: idController,
            decoration: const InputDecoration(labelText: 'Student ID'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: sendStudentData,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

Future<void> uploadData(String apiUrl, Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        throw('Data uploaded successfully');
      }
    } else {
      if (kDebugMode) {
        throw('Error uploading data: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      throw('Exception during data upload: $e');
    }
  }
}
