/*
// lib/view/TeacherPanel/attendance/attendance_view.dart
// UPDATED: now shows subject name and passes subjectId

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rise_college/viewModel/TeacherViewModel/attendance_by_teacher_view_model/claude/attendance_by_teacher_view_model_claude.dart';

class AttendanceViewByTeacher extends StatefulWidget {
  final String classId;
  final String className;
  final String subjectId;    // NEW
  final String subjectName;  // NEW
  final List<String> studentUids;

  const AttendanceViewByTeacher({
    super.key,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.studentUids,
  });

  @override
  State<AttendanceViewByTeacher> createState() => _AttendanceViewByTeacherState();
}

class _AttendanceViewByTeacherState extends State<AttendanceViewByTeacher> {
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceByTeacherViewModelClaude>().loadAttendance(
        classId: widget.classId,
        subjectId: widget.subjectId,  // pass subject
        date: _today,
        studentUids: widget.studentUids,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.subjectName),
            Text('${widget.className} · $_today'),
          ],
        ),           // shows subject name
      ),
      body: Consumer<AttendanceByTeacherViewModelClaude>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          if (vm.attendance.isEmpty) {
            return const Center(child: Text('No students found'));
          }

          // Count present students
          final presentCount = vm.attendance.values.where((v) => v).length;

          return Column(
            children: [
              // Summary bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Total: ${vm.attendance.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Present: $presentCount',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text('Absent: ${vm.attendance.length - presentCount}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Student list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vm.attendance.length,
                  itemBuilder: (context, index) {
                    final uid = vm.attendance.keys.elementAt(index);
                    final isPresent = vm.attendance[uid] ?? true;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isPresent
                          ? Colors.green.withOpacity(0.05)
                          : Colors.red.withOpacity(0.05),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPresent ? Colors.green : Colors.red,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('Student UID: $uid',
                            style: const TextStyle(fontSize: 12)),
                        subtitle: Text(
                          isPresent ? '✓ Present' : '✗ Absent',
                          style: TextStyle(
                            color: isPresent ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Switch(
                          value: isPresent,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                          onChanged: (_) => vm.toggleAttendance(uid),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: vm.isSaving
                        ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.save),
                    label: Text(vm.isSaving ? 'Saving...' : 'Save Attendance'),
                    onPressed: vm.isSaving ? null : () async {
                      await vm.saveAttendance(
                        classId: widget.classId,
                        subjectId: widget.subjectId,  // pass subject
                        date: _today,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Attendance saved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}*/
