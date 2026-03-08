// By Cursor
/*
// views/timetable_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/AdminViewModel/admin_timetable_view_model/admin_timetable_view_model.dart';

class TimetableManagementViewByAdmin extends StatelessWidget {
  const TimetableManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminTimetableViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Timetable Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text('Add Entry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: viewModel.isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: viewModel.timetable.length,
                  itemBuilder: (context, index) {
                    final entry = viewModel.timetable[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          '${entry.classId} - ${entry.subjectId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Teacher: ${entry.teacherId}'),
                            Text('${entry.day} | ${entry.timeSlot}'),
                            Text('Room: ${entry.room}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            viewModel.deleteTimetableEntry(entry.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';

import '../../../model/admin_panel_model/time_table_by_admin_model.dart';
import '../../../viewModel/AdminViewModel/admin_timetable_view_model/admin_timetable_view_model.dart';

class TimetableManagementViewByAdmin extends StatelessWidget {
  const TimetableManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminTimetableViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              _header(context, viewModel),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.timetable.length,
                  itemBuilder: (context, index) {
                    final entry = viewModel.timetable[index];
                    return _timetableCard(context, viewModel, entry);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// HEADER
  Widget _header(
      BuildContext context, AdminTimetableViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Timetable Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _showAddEditDialog(context, viewModel);
            }, // 🔴 ADD ENTRY
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightMaroon,
              foregroundColor: Colors.white,

            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }

  /// CARD
  Widget _timetableCard(
      BuildContext context,
      AdminTimetableViewModel viewModel,
      TimetableByAdminModel entry,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          '${entry.classId} - ${entry.subjectId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Teacher: ${entry.teacherId}'),
            Text('${entry.day} | ${entry.timeSlot}'),
            Text('Room: ${entry.room}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showAddEditDialog(context, viewModel, entry);
            } else if (value == 'delete') {
              viewModel.deleteTimetableEntry(entry.id);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  // 🔴 ADD / EDIT DIALOG (SAME FORM)
  void _showAddEditDialog(
      BuildContext context,
      AdminTimetableViewModel viewModel, [
        TimetableByAdminModel? entry,
      ]) {
    final classCtrl =
    TextEditingController(text: entry?.classId ?? '');
    final subjectCtrl =
    TextEditingController(text: entry?.subjectId ?? '');
    final teacherCtrl =
    TextEditingController(text: entry?.teacherId ?? '');
    final dayCtrl = TextEditingController(text: entry?.day ?? '');
    final timeCtrl =
    TextEditingController(text: entry?.timeSlot ?? '');
    final roomCtrl =
    TextEditingController(text: entry?.room ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(entry == null ? 'Add Timetable Entry' : 'Edit Timetable'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _field(classCtrl, 'Class ID'),
              _field(subjectCtrl, 'Subject ID'),
              _field(teacherCtrl, 'Teacher ID'),
              _field(dayCtrl, 'Day'),
              _field(timeCtrl, 'Time Slot'),
              _field(roomCtrl, 'Room'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: Text(entry == null ? 'Add' : 'Update'),
            onPressed: () async {
              final model = TimetableByAdminModel(
                id: entry?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                classId: classCtrl.text.trim(),
                subjectId: subjectCtrl.text.trim(),
                teacherId: teacherCtrl.text.trim(),
                day: dayCtrl.text.trim(),
                timeSlot: timeCtrl.text.trim(),
                room: roomCtrl.text.trim(),
              );

              if (entry == null) {
                await viewModel.addTimetableEntry(model);
              } else {
                await viewModel.updateTimetableEntry(model);
              }

              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

