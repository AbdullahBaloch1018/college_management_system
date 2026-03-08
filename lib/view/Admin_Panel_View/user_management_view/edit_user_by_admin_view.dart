/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/widgets/custom_text_form_field.dart';
import '../../../viewModel/AdminViewModel/user_management_view_model/edit_user_by_admin_view_model.dart';

class EditUserByAdminView extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserByAdminView({super.key, required this.user});

  @override
  State<EditUserByAdminView> createState() => _EditUserByAdminViewState();
}

class _EditUserByAdminViewState extends State<EditUserByAdminView> {

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers safely
    nameController = TextEditingController(text: widget.user['displayName'] ?? '');
    phoneController = TextEditingController(text: widget.user['phone'] ?? '');

    // ✅ Initialize ViewModel once with user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditUserByAdminViewModel>().initUser(widget.user);
    });
  }

  @override
  void dispose() {
    // ✅ Dispose controllers only once
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditUserByAdminViewModel>(context,listen: false);

    if (kDebugMode) {
      debugPrint("Editing User: ${widget.user}");
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        titleWidget: Text("Update User"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// Name
            CustomTextFormField(
              controller: nameController,
              prefixIcon: Icons.person,
              hintText: "Enter Name",
              keyboardType: TextInputType.text,
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter your name' : null,
            ),

            const SizedBox(height: 12),

            /// Phone
            CustomTextFormField(
              controller: phoneController,
              prefixIcon: Icons.phone,
              hintText: "Enter Phone Number",
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            /// ✅ Faculty Dropdown (FIXED)
            DropdownButtonFormField<String>(
              initialValue: viewModel.selectedFaculty,
              items: viewModel.facultyOptions.map((faculty) {
                return DropdownMenuItem<String>(
                  value: faculty,
                  child: Text(faculty),
                );
              }).toList(),
              onChanged: viewModel.setFaculty, // ✅ updates ViewModel state
              decoration: const InputDecoration(
                labelText: 'Select Faculty',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

                  // ✅ PASS FACULTY FROM VIEWMODEL
                  await viewModel.updateUser(
                    uid: widget.user['uid'],
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    faculty: viewModel.selectedFaculty,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User updated successfully')),
                    );
                  }
                },
                child: const Text("Update User"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/widgets/custom_text_form_field.dart';
import '../../../viewModel/AdminViewModel/user_management_view_model/edit_user_by_admin_view_model.dart';

class EditUserByAdminView extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserByAdminView({super.key, required this.user});

  @override
  State<EditUserByAdminView> createState() => _EditUserByAdminViewState();
}

class _EditUserByAdminViewState extends State<EditUserByAdminView> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.user['displayName'] ?? '');
    phoneController =
        TextEditingController(text: widget.user['phone'] ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditUserByAdminViewModel>().initUser(widget.user);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
    Provider.of<EditUserByAdminViewModel>(context, listen: false);

    if (kDebugMode) debugPrint("Editing User: ${widget.user}");

    final String userRole = widget.user['role']?.toString() ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(titleWidget: Text("Update User")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Role badge (read-only, not editable) ──────────────────────
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: userRole == 'Teacher'
                    ? Colors.green[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: userRole == 'Teacher'
                      ? Colors.green
                      : Colors.blue,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    userRole == 'Teacher' ? Icons.school : Icons.person,
                    size: 16,
                    color:
                    userRole == 'Teacher' ? Colors.green : Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    userRole,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: userRole == 'Teacher'
                          ? Colors.green[700]
                          : Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Name ──────────────────────────────────────────────────────
            CustomTextFormField(
              controller: nameController,
              prefixIcon: Icons.person,
              hintText: "Enter Name",
              keyboardType: TextInputType.text,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter name'
                  : null,
            ),
            const SizedBox(height: 12),

            // ── Phone ─────────────────────────────────────────────────────
            CustomTextFormField(
              controller: phoneController,
              prefixIcon: Icons.phone,
              hintText: "Enter Phone Number",
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ── Faculty Dropdown (Students only, live from Firestore) ──────
            // Teachers don't belong to a class section so we hide this for them
            if (userRole != 'Teacher')
              StreamBuilder<List<String>>(
                stream: viewModel.facultyOptionsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingSkeleton();
                  }

                  final faculties = snapshot.data ?? [];

                  if (faculties.isEmpty) {
                    return _buildNoClassesWarning();
                  }

                  return Consumer<EditUserByAdminViewModel>(
                    builder: (context, vm, _) {
                      // Ensure the stored faculty value exists in the live list.
                      // If Admin deleted that class, reset to null so dropdown doesn't crash.
                      final validValue = faculties.contains(vm.selectedFaculty)
                          ? vm.selectedFaculty
                          : null;

                      return DropdownButtonFormField<String>(
                        initialValue: validValue,
                        hint: const Text('Select Class & Section'),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Class & Section',
                          prefixIcon: Icon(Icons.class_),
                          border: OutlineInputBorder(),
                        ),
                        items: faculties.map((f) {
                          return DropdownMenuItem<String>(
                            value: f,
                            child: Text(f),
                          );
                        }).toList(),
                        onChanged: vm.setFaculty,
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 24),

            // ── Update Button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.updateUser(
                    uid: widget.user['uid'],
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    // Teachers pass their existing faculty (unchanged), students pass selected
                    faculty: userRole == 'Teacher'
                        ? widget.user['faculty']?.toString()
                        : viewModel.selectedFaculty,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User updated successfully')),
                    );
                  }
                },
                child: const Text("Update User"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.class_, color: Colors.grey),
          const SizedBox(width: 12),
          Text('Loading classes…',
              style: TextStyle(color: Colors.grey[500])),
          const Spacer(),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassesWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'No classes available. Create a class first.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
