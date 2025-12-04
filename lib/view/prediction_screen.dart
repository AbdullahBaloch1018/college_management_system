
import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../view/auth_view/login_view.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});
/// APi calling here
  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer(const Duration(minutes: 15), () {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
      // Optionally show a snackBar or toast here
    });
  }

  void resetTimer() {
    _timer.cancel();
    startTimer();
  }

  String remark = '';
  bool isPredicting = false;

  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController assignmentController = TextEditingController();
  final TextEditingController assessmentController = TextEditingController();

  // Post Data Api
  Future<void> postData() async {
    setState(() {
      isPredicting = true;
    });

    try {
      final url = Uri.parse('https://shres58tha.pythonanywhere.com/predict');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "attendance_score": double.parse(attendanceController.text),
        "assignment_score": double.parse(assignmentController.text),
        "assessment_score": double.parse(assessmentController.text),
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          remark = responseData['selected_remark'];
        });

        await Future.delayed(const Duration(seconds: 4));
      } else {
        setState(() {
          remark = 'Failed to fetch data';
        });
      }
    } catch (error) {
      setState(() {
        remark = 'Error: $error';
      });
    } finally {
      setState(() {
        isPredicting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("AI Predictor(Search) Navbar Screen building");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Predictor'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
          resetTimer(); // Reset inactivity timer on interaction
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 20),

                if (isPredicting)
                  Column(
                    children: [
                      Lottie.asset(
                        'animations/ailoadinganimation.json',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Predicting your Case ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  )
                else if (remark.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      remark,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                else
                  Column(
                    children: [
                      _buildInputField(
                        controller: attendanceController,
                        label: 'Attendance Score',
                        icon: Icons.event_available,
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: assignmentController,
                        label: 'Assignment Score',
                        icon: Icons.assignment,
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: assessmentController,
                        label: 'Assessment Score',
                        icon: Icons.assessment,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          postData();
                          resetTimer(); // Reset timer on button press
                        },
                        child: const Text('Predict'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          icon: Icon(icon),
        ),
        onChanged: (_) => resetTimer(), // Reset timer on typing
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    attendanceController.dispose();
    assignmentController.dispose();
    assessmentController.dispose();
    super.dispose();
  }
}
