import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import '../../../viewModel/AdminViewModel/class_management_view_model/class_management_view_model.dart';
import '../../../Services/admin_panel_Services/class_repository.dart';

class ClassManagementViewByAdmin extends StatefulWidget {
  const ClassManagementViewByAdmin({super.key});

  @override
  State<ClassManagementViewByAdmin> createState() => _ClassManagementViewByAdminState();
}

class _ClassManagementViewByAdminState extends State<ClassManagementViewByAdmin> {


  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassManagementByAdminViewModel>(context, listen: false);
    final classStream = ClassRepository().watchClassesStream();

    return Scaffold(
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: classStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No classes found'));
                }

                // Iterating all the data of the Firebase map into-> list form.
                final classes = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'classId': doc.id,
                    'className': data['className'] ?? 'Unnamed',
                    'classSection': data['classSection'] ?? '',
                    'assignedTeacherName': data['assignedTeacherName'] ?? '',
                    'assignedTeacherId': data['assignedTeacherId'] ?? '',
                    'createdAt': data['createdAt'],
                  };
                }).toList();

                return _classGrid(classes, viewModel, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Class Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.createClassByAdminView);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightMaroon,
              foregroundColor: Colors.white
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Class'),
          ),
        ],
      ),
    );
  }

  Widget _classGrid(List<Map<String, dynamic>> classes,ClassManagementByAdminViewModel viewModel,BuildContext context,) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classData = classes[index];
        return _classCard(context, viewModel, classData);
      },
    );
  }

  Widget _classCard(
      BuildContext context,
      ClassManagementByAdminViewModel viewModel,
      Map<String, dynamic> classData,
      ) {
    final height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Title with PopupmenuButtons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    classData['className'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, viewModel, classData);
                    } else if (value == 'delete') {
                      _confirmDeleteClass(context, viewModel, classData['classId']);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            Text(
              (classData['classSection'] as String).isEmpty
                  ? "No section"
                  : "Section: ${classData['classSection']}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              (classData['assignedTeacherName'] as String).isEmpty
                  ? "No Teacher is Assigned"
                  : "Assigned Teacher: ${classData['assignedTeacherName']}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteClass(
      BuildContext context,
      ClassManagementByAdminViewModel viewModel,
      String docId,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this class?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await viewModel.deleteClass(docId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context,ClassManagementByAdminViewModel viewModel, Map<String, dynamic> classData,) {
    showDialog(
      context: context,
      builder: (context) => _EditClassDialog(classData: classData,viewModel: viewModel,),
    );
  }
}

/// Separate StatefulWidget for the edit dialog so the teacher dropdown
/// can manage its own selected state independently.
class _EditClassDialog extends StatefulWidget {
  final Map<String, dynamic> classData;
  final ClassManagementByAdminViewModel viewModel;

  const _EditClassDialog({
    required this.classData,
    required this.viewModel,
  });

  @override
  State<_EditClassDialog> createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<_EditClassDialog> {
  late final TextEditingController _sectionController;
  String? _selectedTeacherId;
  String? _selectedTeacherName;
  final ClassRepository _repository = ClassRepository();

  @override
  void initState() {
    super.initState();
    _sectionController = TextEditingController(text: widget.classData['classSection']);
    // Pre-select the currently assigned teacher so it shows in the dropdown
    final currentTeacherId = widget.classData['assignedTeacherId'] as String;
    final currentTeacherName = widget.classData['assignedTeacherName'] as String;
    _selectedTeacherId = currentTeacherId.isEmpty ? null : currentTeacherId;
    _selectedTeacherName = currentTeacherName.isEmpty ? null : currentTeacherName;
  }

  @override
  void dispose() {
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Class - ${widget.classData['className']}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section text field
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Teacher dropdown — streams teachers from Firestore in real time
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _repository.watchTeachersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error loading teachers: ${snapshot.error}');
                }

                final teachers = snapshot.data ?? [];

                // If the pre-selected teacher no longer exists in the list, clear selection
                final validIds = teachers.map((t) => t['uid'] as String).toSet();
                if (_selectedTeacherId != null && !validIds.contains(_selectedTeacherId)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedTeacherId = null;
                      _selectedTeacherName = null;
                    });
                  });
                }

                return DropdownButtonFormField<String>(
                  initialValue: _selectedTeacherId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Assign Teacher',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  hint: const Text('Select Teacher'),
                  items: teachers.map((t) {
                    return DropdownMenuItem<String>(
                      value: t['uid'] as String,
                      child: Text(t['displayName']?.toString() ?? 'No Name'),
                    );
                  }).toList(),
                  onChanged: (uid) {
                    if (uid == null) return;
                    final teacher = teachers.firstWhere(
                          (t) => t['uid'] == uid,
                      orElse: () => <String, dynamic>{},
                    );
                    setState(() {
                      _selectedTeacherId = uid;
                      _selectedTeacherName = teacher['displayName']?.toString();
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newSection = _sectionController.text.trim();
            if (newSection.isEmpty) return;

            final updatedClassData = Map<String, dynamic>.from(widget.classData);
            updatedClassData['classSection'] = newSection;
            updatedClassData['assignedTeacherId'] = _selectedTeacherId ?? '';
            updatedClassData['assignedTeacherName'] = _selectedTeacherName ?? '';

            await widget.viewModel.updateClass(updatedClassData);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}