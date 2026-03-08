import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/resources/components/round_button.dart';
import 'package:rise_college/viewModel/AdminViewModel/class_management_view_model/create_class_by_admin_view_model.dart';
import 'package:rise_college/widgets/custom_text_form_field.dart';

import '../../../resources/app_colors.dart';
import '../../../utils/utils.dart';

class CreateClassByAdminView extends StatefulWidget {
  const CreateClassByAdminView({super.key});

  @override
  State<CreateClassByAdminView> createState() => _CreateClassByAdminViewState();
}

class _CreateClassByAdminViewState extends State<CreateClassByAdminView> {
  final TextEditingController classNameCtrl = TextEditingController();
  final TextEditingController classSectionCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode classNameFocus = FocusNode();
  final FocusNode classSectionFocus = FocusNode();

  // FIX: Dispose controllers and focus nodes to prevent memory leaks
  @override
  void dispose() {
    classNameCtrl.dispose();
    classSectionCtrl.dispose();
    classNameFocus.dispose();
    classSectionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<CreateClassByAdminViewModel>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text("Create New Class")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: height * .02),
                // Class Name
                CustomTextFormField(
                  controller: classNameCtrl,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: classNameFocus, // FIX: was created but never assigned
                  labelText: "Class Name",
                  hintText: "Enter Class Name (e.g., BSCS)",
                ),
                SizedBox(height: height * .02),
                // Class Section Field
                CustomTextFormField(
                  controller: classSectionCtrl,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: classSectionFocus,
                  labelText: "Section",
                  hintText: "Section (e.g., 1A)",
                ),
                SizedBox(height: height * .02),
                StreamBuilder(
                  stream: provider.teacherStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text("No Teacher Available"));
                    }
                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print("The Error in the Teacher Assigning to the class is: ${snapshot.error}");
                      }
                      return Center(child: Text("Error is coming up  ${snapshot.error}"));
                    }
                    final teachers = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      initialValue: provider.selectedTeacherId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Assign Teacher",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      hint: const Text("Teacher"),
                      items: teachers.map((t) {
                        return DropdownMenuItem(
                          value: t['uid'] as String?,
                          child: Text(t['displayName']?.toString() ?? 'No Name'),
                        );
                      }).toList(),
                      onChanged: (uid) {
                        if (uid == null) return;
                        final teacher = teachers.firstWhere(
                              (t) => t['uid'] == uid,
                          orElse: () => <String, dynamic>{},
                        );
                        provider.setSelectedTeacher(uid, teacher['displayName']?.toString());
                      },
                      validator: (v) => v == null ? "Please select a teacher" : null,
                    );
                  },
                ),
                SizedBox(height: height * .02),
                RoundButton(
                  title: "Create Class",
                  loading: context.watch<CreateClassByAdminViewModel>().loading,
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      final provider = context.read<CreateClassByAdminViewModel>();

                      final classData = {
                        'classId': DateTime.now().millisecondsSinceEpoch.toString(),
                        'className': classNameCtrl.text.trim(),
                        'classSection': classSectionCtrl.text.trim(),
                        'totalStudents': '10',
                        'assignedTeacherId': provider.selectedTeacherId,
                        'assignedTeacherName': provider.selectedTeacherName,
                        'createdAt': FieldValue.serverTimestamp(),
                      };

                      await provider.createClass(classData);

                      Utils.toastMessage(
                        "Class Created Successfully",
                        AppColors.success,
                        AppColors.black,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // FIX: Clear both controllers after successful creation
                      classNameCtrl.clear();
                      classSectionCtrl.clear();
                      provider.setSelectedClass(null);
                      provider.setSelectedTeacher(null, null);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}