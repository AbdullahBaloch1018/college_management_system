import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/resources/components/round_button.dart';
import 'package:rise_college/widgets/custom_text_form_field.dart';
import '../../../model/admin_panel_model/system_setting_model_by_admin.dart';
import '../../../viewModel/AdminViewModel/admin_system_setting_view_model/admin_system_setting_view_model.dart';

class UpdateSettingsScreen extends StatefulWidget {
  const UpdateSettingsScreen({super.key});

  @override
  State<UpdateSettingsScreen> createState() => _UpdateSettingsScreenState();
}

class _UpdateSettingsScreenState extends State<UpdateSettingsScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final sessionStartController = TextEditingController();
  final sessionEndController = TextEditingController();
  final thresholdController = TextEditingController();
  final passingMarksController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode sessionStartFocus = FocusNode();
  final FocusNode sessionEndFocus = FocusNode();
  final FocusNode thresholdFocus = FocusNode();
  final FocusNode passingMarksFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    final vm = context.read<AdminSystemSettingViewModel>();

    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text("Update Settings"),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: nameController,
                hintText: "Institution Name",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: nameFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: emailController,
                hintText: "Institution Email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: emailFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: phoneController,
                hintText: "Institution Phone",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: phoneFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: addressController,
                hintText: "Institute Address",
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                focusNode: addressFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: sessionStartController,
                hintText: "Session Start",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: sessionStartFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: sessionEndController,
                hintText: "Session End",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: sessionEndFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: thresholdController,
                hintText: "Attendance Threshold",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: thresholdFocus,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.02,),
              CustomTextFormField(
                controller: passingMarksController,
                hintText: "Passing Marks",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                focusNode: passingMarksFocus,
              ),

              const SizedBox(height: 20),

              RoundButton(
                onPress: () async {

                  if (!_formKey.currentState!.validate()) return;

                  final newSettings = SystemSettingModelByAdmin(
                    institutionName: nameController.text.toString(),
                    email: emailController.text.toString(),
                    phone: phoneController.text.toString(),
                    address: addressController.text.toString(),
                    sessionStart: sessionStartController.text.toString(),
                    sessionEnd: sessionEndController.text.toString(),
                    attendanceThreshold: int.parse(thresholdController.text),
                    passingMarks: int.parse(passingMarksController.text),

                  );

                  final success = await vm.updateSettings(newSettings);

                  if (success) {
                    Navigator.pop(context);
                  }
                },
                title: "Save Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}