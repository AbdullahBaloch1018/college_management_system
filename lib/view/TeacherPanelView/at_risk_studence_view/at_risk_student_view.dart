import 'package:flutter/material.dart';

class AtRiskStudentsView extends StatelessWidget {
  const AtRiskStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('At-Risk Students')),
      body: const Center(
        child: Text(
          'AI-based At-Risk Students List',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
