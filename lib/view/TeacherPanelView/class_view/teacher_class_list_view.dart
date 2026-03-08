/*
// lib/view/TeacherPanel/attendance/teacher_class_list_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/TeacherViewModel/teacher_class_view_model/teacher_class_view_model.dart';

/// Teacher sees all classes (fetched in real-time from Firebase).
/// Taps a class → goes to AttendanceView for that class.
class TeacherClassListView extends StatelessWidget {
  const TeacherClassListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Class')),
      body: Consumer<TeacherClassViewModel>(
        builder: (context, viewModel, _) {
          // Show loading spinner while fetching
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // No classes found
          if (viewModel.classes.isEmpty) {
            return const Center(child: Text('No classes found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: viewModel.classes.length,
            itemBuilder: (context, index) {
              final classData = viewModel.classes[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    classData['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Section: ${classData['section'] ?? ''}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectListViewByClaude(
                          classId: classData['id'],
                          className: classData['name'],
                          studentUids: List<String>.from(classData['studentUids'] ?? []),
                          teacherUid: 'LOGGED_IN_TEACHER_UID', // replace with FirebaseAuth.instance.currentUser!.uid
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/
