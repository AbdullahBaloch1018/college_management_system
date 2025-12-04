import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../viewModel/predictor_view_model.dart';

class PerformancePredictorView extends StatefulWidget {
  const PerformancePredictorView({super.key});

  @override
  State<PerformancePredictorView> createState() =>
      _PerformancePredictorViewState();
}

class _PerformancePredictorViewState extends State<PerformancePredictorView> {
  final attendanceController = TextEditingController();
  final assignmentController = TextEditingController();
  final assessmentController = TextEditingController();

  @override
  void dispose() {
    attendanceController.dispose();
    assignmentController.dispose();
    assessmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final predictorVM = Provider.of<PredictorViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('AI Performance Predictor'),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.deepPurple.withOpacity(0.4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: predictorVM.isPredicting
              ? _buildLoadingState()
              : predictorVM.remark.isNotEmpty
              ? _buildResultCard(context, predictorVM)
              : _buildInputForm(context, predictorVM),
        ),
      ),
    );
  }

  /// 🔹 Loading animation while predicting
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('animations/ailoadinganimation.json', height: 180),
          const SizedBox(height: 20),
          const Text(
            "Analyzing your performance...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    PredictorViewModel predictorVM,
  ) {
    // Mock data visualization
    final mockScores = {'Attendance': 85, 'Assignments': 78, 'Assessments': 90};

    return Center(
      child: Card(
        elevation: 6,
        shadowColor: Colors.deepPurple.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.analytics, color: Colors.deepPurple, size: 60),
              const SizedBox(height: 15),
              Text(
                predictorVM.remark,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Mock Data Visualization:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              ...mockScores.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key),
                      Text(
                        "${e.value}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    predictorVM.clearRemark();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "Predict Again",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Input form for scores
  Widget _buildInputForm(BuildContext context, PredictorViewModel predictorVM) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter Your Scores",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            attendanceController,
            'Attendance Score',
            Icons.event_available,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            assignmentController,
            'Assignment Score',
            Icons.assignment,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            assessmentController,
            'Assessment Score',
            Icons.assessment,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              if (kDebugMode) print("Predict button pressed");

              predictorVM.predict(
                attendanceScore:
                    double.tryParse(attendanceController.text) ?? 0.0,
                assignmentScore:
                    double.tryParse(assignmentController.text) ?? 0.0,
                assessmentScore:
                    double.tryParse(assessmentController.text) ?? 0.0,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            child: const Text(
              'Predict',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Modernized text field with better design
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.8),
        ),
      ),
    );
  }
}
