import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/round_button.dart';
import 'package:rise_college/view/Admin_Panel_View/system_setting_view/update_system_setting_view_by_admin.dart';
import '../../../viewModel/AdminViewModel/admin_system_setting_view_model/admin_system_setting_view_model.dart';
class SystemSettingViewByAdmin extends StatelessWidget {
  const SystemSettingViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminSystemSettingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Institution Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow('Name', viewModel.settings.institutionName.toString() ),
                      _buildInfoRow('Email', viewModel.settings.email),
                      _buildInfoRow('Phone', viewModel.settings.phone),
                      _buildInfoRow('Address', viewModel.settings.address),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Session',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow('Session Start', viewModel.settings.sessionStart),
                      _buildInfoRow('Session End', viewModel.settings.sessionEnd),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Policies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow('Attendance Threshold',
                          '${viewModel.settings.attendanceThreshold}%'),
                      _buildInfoRow('Passing Marks', '${viewModel.settings.passingMarks}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: RoundButton(title: "Update Setting", onPress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSettingsScreen(),));
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/view/Admin_Panel_View/system_setting_view/update_system_setting_view_by_admin.dart';
import '../../../viewModel/AdminViewModel/admin_system_setting_view_model/admin_system_setting_view_model.dart';
class SystemSettingViewByAdmin extends StatefulWidget {
  const SystemSettingViewByAdmin({super.key});

  @override
  State<SystemSettingViewByAdmin> createState() =>
      _SystemSettingViewByAdminState();
}

class _SystemSettingViewByAdminState
    extends State<SystemSettingViewByAdmin> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AdminSystemSettingViewModel>().listenToSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminSystemSettingViewModel>(
      builder: (context, vm, child) {

        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final s = vm.settings;

        return Scaffold(
          appBar: AppBar(title: const Text("System Settings")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Institution: ${s.institutionName}"),
                Text("Email: ${s.email}"),
                Text("Attendance Threshold: ${s.attendanceThreshold}%"),
                const SizedBox(height: 20),

                /// 🔥 UPDATE BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpdateSettingsScreen(),
                      ),
                    );
                  },
                  child: const Text("Update Settings"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/
