/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes/routes_name.dart';
import '../../../viewModel/AdminViewModel/subject_management_by_admin_view_model/subject_management_view_model.dart';

class SubjectManagementViewByAdmin extends StatelessWidget {
  const SubjectManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SubjectManagementViewModel>();

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Subject Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RoutesName.createSubjectByAdminView,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Real-time subject list
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: viewModel.subjectsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final subjects = snapshot.data ?? [];

                if (subjects.isEmpty) {
                  return const Center(child: Text('No subjects found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final name = subject['subjectName']?.toString() ?? 'Unnamed Subject';
                    final code = subject['subjectCode']?.toString() ?? 'N/A';
                    final cls = subject['assignClass']?.toString() ?? 'Not Assigned';
                    final teacher = subject['assignedTeacherName']?.toString() ?? 'Not Assigned';
                    final id = subject['subjectId']?.toString();

                    if (id == null) return const SizedBox.shrink();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF6A1B9A),
                          child: Icon(Icons.book, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Code: $code'),
                            Text('Class: $cls'),
                            Text('Teacher: $teacher'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _confirmDeleteSubject(context, viewModel, id);
                            } else if (value == 'edit') {
                              _showEditSubjectDialog(context, viewModel, subject);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSubject(
      BuildContext context, SubjectManagementViewModel vm, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete this subject?\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await vm.deleteSubject(id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Subject deleted successfully'
                      : 'Failed to delete subject'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditSubjectDialog(
      BuildContext context,
      SubjectManagementViewModel vm,
      Map<String, dynamic> initialSubject,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _EditSubjectDialogContent(viewModel: vm,initialSubject: initialSubject,),
    );
  }
}


// Stateful dialog for editing a subject
class _EditSubjectDialogContent extends StatefulWidget {
  final SubjectManagementViewModel viewModel;
  final Map<String, dynamic> initialSubject;

  const _EditSubjectDialogContent({
    required this.viewModel,
    required this.initialSubject,
  });

  @override
  State<_EditSubjectDialogContent> createState() =>
      _EditSubjectDialogContentState();
}

class _EditSubjectDialogContentState extends State<_EditSubjectDialogContent> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  String? _selectedClass;
  String? _selectedTeacherId;
  String? _selectedTeacherName;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.initialSubject['subjectName']?.toString() ?? '');
    _codeController = TextEditingController(
        text: widget.initialSubject['subjectCode']?.toString() ?? '');
    _selectedClass = widget.initialSubject['assignClass']?.toString();
    _selectedTeacherId =
        widget.initialSubject['assignedTeacherId']?.toString();
    _selectedTeacherName =
        widget.initialSubject['assignedTeacherName']?.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Subject'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter subject name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Subject Code
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Code',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter subject code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Assign Class Dropdown
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: widget.viewModel.classesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final classes = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedClass,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign Class',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: classes.map((cls) {
                        final className =
                            cls['className']?.toString() ?? 'Unnamed Class';
                        return DropdownMenuItem<String>(
                          value: className,
                          child: Text(className),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedClass = value),
                      validator: (value) =>
                      value == null ? 'Please select a class' : null,
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Assign Teacher Dropdown
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: widget.viewModel.teacherStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final teachers = snapshot.data ?? [];
                    if (teachers.isEmpty) {
                      return const Text('No teachers available',
                          style: TextStyle(color: Colors.red));
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedTeacherId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign Teacher',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: teachers.map((teacher) {
                        final uid = teacher['uid'] as String?;
                        final name = teacher['displayName']?.toString() ??
                            'Unnamed Teacher';
                        return DropdownMenuItem<String>(
                          value: uid,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedTeacherId = value;
                          final selected = teachers.firstWhere(
                                (t) => t['uid'] == value,
                            orElse: () => <String, dynamic>{},
                          );
                          _selectedTeacherName =
                              selected['displayName']?.toString();
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select a teacher' : null,
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final updatedData = {
              'subjectId': widget.initialSubject['subjectId'],
              'subjectName': _nameController.text.trim(),
              'subjectCode': _codeController.text.trim(),
              'assignClass': _selectedClass ?? 'Not Assigned',
              'assignedTeacherId': _selectedTeacherId,
              'assignedTeacherName': _selectedTeacherName ?? 'Not Assigned',
            };

            final success =
            await widget.viewModel.updateSubject(updatedData);

            if (!context.mounted) return;
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? 'Subject updated successfully'
                    : 'Failed to update subject'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A)),
          child: const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}*/
// By Claude
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';

import '../../../utils/routes/routes_name.dart';
import '../../../viewModel/AdminViewModel/subject_management_by_admin_view_model/subject_management_view_model.dart';
import '../../../Services/admin_panel_Services/subject_repository.dart';

class SubjectManagementViewByAdmin extends StatelessWidget {
  const SubjectManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SubjectManagementViewModel>();

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Subject Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RoutesName.createSubjectByAdminView,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightMaroon,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ── Subject list ─────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: viewModel.subjectsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final subjects = snapshot.data ?? [];

                if (subjects.isEmpty) {
                  return const Center(child: Text('No subjects found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final name =
                        subject['subjectName']?.toString() ?? 'Unnamed Subject';
                    final code = subject['subjectCode']?.toString() ?? 'N/A';
                    // Use assignClass display label (e.g. "ICS – A")
                    final cls =
                        subject['assignClass']?.toString() ?? 'Not Assigned';
                    final teacher =
                        subject['assignedTeacherName']?.toString() ??
                            'Not Assigned';
                    final id = subject['subjectId']?.toString();

                    if (id == null) return const SizedBox.shrink();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: const CircleAvatar(
                          // backgroundColor: Color(0xFF6A1B9A),
                          backgroundColor: AppColors.primaryDark,
                          child: Icon(Icons.book, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Code: $code'),
                            Text('Class: $cls'),
                            Text('Teacher: $teacher'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _confirmDeleteSubject(context, viewModel, id);
                            } else if (value == 'edit') {
                              _showEditSubjectDialog(
                                  context, viewModel, subject);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSubject(
      BuildContext context, SubjectManagementViewModel vm, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete this subject?\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await vm.deleteSubject(id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Subject deleted successfully'
                      : 'Failed to delete subject'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditSubjectDialog(
      BuildContext context,
      SubjectManagementViewModel vm,
      Map<String, dynamic> initialSubject,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _EditSubjectDialogContent(
        viewModel: vm,
        initialSubject: initialSubject,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDIT SUBJECT DIALOG
// KEY CHANGE: class dropdown now stores full class map so classId +
// className + classSection are all saved on the updated subject document.
// ─────────────────────────────────────────────────────────────────────────────

class _EditSubjectDialogContent extends StatefulWidget {
  final SubjectManagementViewModel viewModel;
  final Map<String, dynamic> initialSubject;

  const _EditSubjectDialogContent({
    required this.viewModel,
    required this.initialSubject,
  });

  @override
  State<_EditSubjectDialogContent> createState() =>
      _EditSubjectDialogContentState();
}

class _EditSubjectDialogContentState extends State<_EditSubjectDialogContent> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  // Full class map selected in dropdown — gives access to classId + className + classSection
  Map<String, dynamic>? _selectedClassMap;

  String? _selectedTeacherId;
  String? _selectedTeacherName;

  final _formKey = GlobalKey<FormState>();
  final _subjectRepo = SubjectRepository();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.initialSubject['subjectName']?.toString() ?? '');
    _codeController = TextEditingController(
        text: widget.initialSubject['subjectCode']?.toString() ?? '');
    _selectedTeacherId =
        widget.initialSubject['assignedTeacherId']?.toString();
    _selectedTeacherName =
        widget.initialSubject['assignedTeacherName']?.toString();

    // Pre-build a partial class map from the existing subject doc so the
    // dropdown can show the currently assigned class on open.
    // Full map will be replaced when user picks from dropdown.
    final existingClassId = widget.initialSubject['classId']?.toString() ?? '';
    final existingClassName =
        widget.initialSubject['className']?.toString() ?? '';
    final existingClassSection =
        widget.initialSubject['classSection']?.toString() ?? '';

    if (existingClassId.isNotEmpty) {
      _selectedClassMap = {
        'classId': existingClassId,
        'className': existingClassName,
        'classSection': existingClassSection,
      };
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String _classLabel(Map<String, dynamic> cls) {
    final name = cls['className']?.toString() ?? '';
    final section = cls['classSection']?.toString() ?? '';
    return '$name – $section';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Subject'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Subject Name ──────────────────────────────────────────
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Please enter subject name'
                      : null,
                ),
                const SizedBox(height: 16),

                // ── Subject Code ──────────────────────────────────────────
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Code',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Please enter subject code'
                      : null,
                ),
                const SizedBox(height: 16),

                // ── Class Dropdown ────────────────────────────────────────
                // KEY CHANGE: value is full class map, not className string.
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _subjectRepo.watchClassesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final classes = snapshot.data ?? [];

                    // Find matching class map from Firestore list to use as
                    // dropdown value (requires same object reference via classId match)
                    Map<String, dynamic>? dropdownValue;
                    if (_selectedClassMap != null) {
                      final selectedId =
                      _selectedClassMap!['classId']?.toString();
                      try {
                        dropdownValue = classes.firstWhere(
                              (c) => c['classId']?.toString() == selectedId,
                        );
                      } catch (_) {
                        dropdownValue = null;
                      }
                    }

                    return DropdownButtonFormField<Map<String, dynamic>>(
                      initialValue: dropdownValue,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign Class',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                      ),
                      hint: const Text('Select Class'),
                      items: classes.map((cls) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: cls,
                          child: Text(_classLabel(cls)),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedClassMap = value),
                      validator: (v) =>
                      v == null ? 'Please select a class' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Teacher Dropdown ──────────────────────────────────────
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _subjectRepo.watchTeachersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final teachers = snapshot.data ?? [];
                    if (teachers.isEmpty) {
                      return const Text('No teachers available',
                          style: TextStyle(color: Colors.red));
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedTeacherId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign Teacher',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                      ),
                      items: teachers.map((t) {
                        return DropdownMenuItem<String>(
                          value: t['uid']?.toString(),
                          child: Text(
                              t['displayName']?.toString() ?? 'Unnamed Teacher'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedTeacherId = value;
                          final selected = teachers.firstWhere(
                                (t) => t['uid'] == value,
                            orElse: () => <String, dynamic>{},
                          );
                          _selectedTeacherName =
                              selected['displayName']?.toString();
                        });
                      },
                      validator: (v) =>
                      v == null ? 'Please select a teacher' : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            // KEY CHANGE: save classId + className + classSection alongside assignClass label
            final updatedData = {
              'subjectId': widget.initialSubject['subjectId'],
              'subjectName': _nameController.text.trim(),
              'subjectCode': _codeController.text.trim(),
              // Class fields
              'classId': _selectedClassMap?['classId']?.toString() ?? '',
              'className': _selectedClassMap?['className']?.toString() ?? '',
              'classSection':
              _selectedClassMap?['classSection']?.toString() ?? '',
              'assignClass': _selectedClassMap != null
                  ? _classLabel(_selectedClassMap!)
                  : 'Not Assigned',
              // Teacher fields
              'assignedTeacherId': _selectedTeacherId ?? '',
              'assignedTeacherName': _selectedTeacherName ?? 'Not Assigned',
            };

            final success =
            await widget.viewModel.updateSubject(updatedData);

            if (!context.mounted) return;
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? 'Subject updated successfully'
                    : 'Failed to update subject'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A)),
          child: const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
