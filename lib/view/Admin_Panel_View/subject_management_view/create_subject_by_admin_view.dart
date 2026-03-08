/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/components/custom_app_bar.dart';
import '../../../viewModel/AdminViewModel/subject_management_by_admin_view_model/subject_management_view_model.dart';

class CreateSubjectByAdminView extends StatefulWidget {
  const CreateSubjectByAdminView({super.key});

  @override
  State<CreateSubjectByAdminView> createState() =>
      _CreateSubjectByAdminViewState();
}

class _CreateSubjectByAdminViewState extends State<CreateSubjectByAdminView> {
  final _subjectNameCtrl = TextEditingController();
  final _subjectCodeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isLoading = ValueNotifier(false); // no setState

  @override
  void dispose() {
    _subjectNameCtrl.dispose();
    _subjectCodeCtrl.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SubjectManagementViewModel>();

    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text("Create Subject")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Subject Name
              TextFormField(
                controller: _subjectNameCtrl,
                decoration: const InputDecoration(
                  labelText: "Subject Name",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? "Enter subject name" : null,
              ),
              const SizedBox(height: 16),

              // Subject Code
              TextFormField(
                controller: _subjectCodeCtrl,
                decoration: const InputDecoration(
                  labelText: "Subject Code",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? "Enter subject code" : null,
              ),
              const SizedBox(height: 16),

              // Class Dropdown
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: vm.classesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final classes = snapshot.data ?? [];
                  return Consumer<SubjectManagementViewModel>(
                    builder: (context, vm, _) {
                      return DropdownButtonFormField<String>(
                        initialValue: vm.selectedClass,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Assign Class",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        items: classes.map((cls) {
                          final name =
                              cls['className']?.toString() ?? 'Unnamed';
                          return DropdownMenuItem(
                              value: name, child: Text(name));
                        }).toList(),
                        onChanged: (value) => vm.setSelectedClass(value),
                        validator: (v) =>
                        v == null ? "Please select a class" : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Teacher Dropdown
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: vm.teacherStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final teachers = snapshot.data ?? [];
                  if (teachers.isEmpty) {
                    return const Text(
                      "No Teachers Available",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: vm.selectedTeacherId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Assign Teacher",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                    ),
                    hint: Text("Teacher"),

                    items: teachers.map((t) {
                      return DropdownMenuItem(
                        value: t['uid'] as String?,
                        child: Text( t['displayName']?.toString() ?? 'No Name'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      final teacher = teachers.firstWhere(
                            (t) => t['uid'] == value,
                        orElse: () => <String, dynamic>{},
                      );
                      vm.setSelectedTeacher(
                          value, teacher['displayName']?.toString());
                    },
                    validator: (v) =>
                    v == null ? "Please select a teacher" : null,
                  );
                },
              ),
              const SizedBox(height: 30),

              // Submit Button — only this rebuilds on loading change
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _handleCreateSubject(vm),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Create Subject"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateSubject(SubjectManagementViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    final subjectData = {
      'subjectId': DateTime.now().millisecondsSinceEpoch.toString(),
      'subjectName': _subjectNameCtrl.text.trim(),
      'subjectCode': _subjectCodeCtrl.text.trim(),
      'assignClass': vm.selectedClass ?? 'No Class',
      'assignedTeacherId': vm.selectedTeacherId,
      'assignedTeacherName': vm.selectedTeacherName ?? 'Not Assigned',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final success = await vm.addSubject(subjectData);

    if (!mounted) return;
    _isLoading.value = false;

    if (success) {
      _subjectNameCtrl.clear();
      _subjectCodeCtrl.clear();
      vm.setSelectedClass(null);
      vm.setSelectedTeacher(null, null);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subject Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to Add Subject"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}*/
// By Claude
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/components/custom_app_bar.dart';
import '../../../viewModel/AdminViewModel/subject_management_by_admin_view_model/subject_management_view_model.dart';

class CreateSubjectByAdminView extends StatefulWidget {
  const CreateSubjectByAdminView({super.key});

  @override
  State<CreateSubjectByAdminView> createState() => _CreateSubjectByAdminViewState();
}

class _CreateSubjectByAdminViewState extends State<CreateSubjectByAdminView> {
  final _subjectNameCtrl = TextEditingController();
  final _subjectCodeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _subjectNameCtrl.dispose();
    _subjectCodeCtrl.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SubjectManagementViewModel>();

    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text("Create Subject")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Subject Name
              TextFormField(
                controller: _subjectNameCtrl,
                decoration: const InputDecoration(
                  labelText: "Subject Name",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v?.trim().isEmpty ?? true) ? "Enter subject name" : null,
              ),
              const SizedBox(height: 16),

              // ── Subject Code
              TextFormField(
                controller: _subjectCodeCtrl,
                decoration: const InputDecoration(
                  labelText: "Subject Code",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? "Enter subject code" : null,
              ),
              const SizedBox(height: 16),

              // ── Class Dropdown ──────────────────────────────────────────
              // KEY CHANGE: value is the full class map (not just className string).
              // This allows storing classId + className + classSection on the subject.
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: vm.classesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final classes = snapshot.data ?? [];

                  return Consumer<SubjectManagementViewModel>(
                    builder: (context, vm, _) {
                      return DropdownButtonFormField<Map<String, dynamic>>(
                        initialValue: vm.selectedClassMap,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Assign Class",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        hint: const Text("Select Class"),
                        // Each item is the full class map so we can access classId
                        items: classes.map((cls) {
                          final name = cls['className']?.toString() ?? '';
                          final section = cls['classSection']?.toString() ?? '';
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: cls,
                            child: Text('$name – $section'),
                          );
                        }).toList(),
                        onChanged: (value) => vm.setSelectedClassMap(value),
                        validator: (v) => v == null ? "Please select a class" : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── Teacher Dropdown
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: vm.teacherStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final teachers = snapshot.data ?? [];
                  if (teachers.isEmpty) {
                    return const Text(
                      "No Teachers Available",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: vm.selectedTeacherId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Assign Teacher",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                    ),
                    hint: const Text("Teacher"),
                    items: teachers.map((t) {
                      return DropdownMenuItem(
                        value: t['uid'] as String?,
                        child: Text(t['displayName']?.toString() ?? 'No Name'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      final teacher = teachers.firstWhere(
                            (t) => t['uid'] == value,
                        orElse: () => <String, dynamic>{},
                      );
                      vm.setSelectedTeacher(
                          value, teacher['displayName']?.toString());
                    },
                    validator: (v) =>
                    v == null ? "Please select a teacher" : null,
                  );
                },
              ),
              const SizedBox(height: 30),

              // ── Submit Button
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _handleCreateSubject(vm),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Create Subject"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateSubject(SubjectManagementViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    // KEY CHANGE: store classId + className + classSection on the subject doc.
    // assignClass is kept as display label for backward compatibility in the list UI.
    final subjectData = {
      'subjectId': DateTime.now().millisecondsSinceEpoch.toString(),
      'subjectName': _subjectNameCtrl.text.trim(),
      'subjectCode': _subjectCodeCtrl.text.trim(),
      // ── Class fields (all three stored for attendance filtering) ──
      'classId': vm.selectedClassId ?? '',         // FK used by attendance
      'className': vm.selectedClassName ?? '',     // e.g. "ICS"
      'classSection': vm.selectedClassSection ?? '', // e.g. "A"
      'assignClass': vm.selectedClassLabel ?? '',  // e.g. "ICS – A" (display label)
      // ── Teacher fields ────────────────────────────────────────────
      'assignedTeacherId': vm.selectedTeacherId ?? '',
      'assignedTeacherName': vm.selectedTeacherName ?? 'Not Assigned',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final success = await vm.addSubject(subjectData);

    if (!mounted) return;
    _isLoading.value = false;

    if (success) {
      _subjectNameCtrl.clear();
      _subjectCodeCtrl.clear();
      vm.setSelectedClassMap(null);
      vm.setSelectedTeacher(null, null);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subject Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to Add Subject"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
