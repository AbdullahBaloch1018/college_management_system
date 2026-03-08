import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/view/Admin_Panel_View/subject_management_view/subject_management_view.dart';
import 'package:rise_college/view/Admin_Panel_View/system_setting_view/system_setting_view.dart';
import 'package:rise_college/view/Admin_Panel_View/timetable_management_view/timetable_management_view.dart';
import 'package:rise_college/view/Admin_Panel_View/user_management_view/user_management_view.dart';
import 'package:rise_college/viewModel/auth_view_model.dart';
import '../../../resources/components/custom_app_bar.dart';
import 'admin_dashboard_view.dart';
import 'admin_drawer.dart';
import '../class_management_view/class_management_view.dart';

class AdminMainView extends StatefulWidget {
  const AdminMainView({super.key});

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AdminDashboardView(),
    UserManagementViewByAdmin(),
    ClassManagementViewByAdmin(),
    SubjectManagementViewByAdmin(),
    TimetableManagementViewByAdmin(),
    SystemSettingViewByAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text("Admin Panel"),
        action: [
          IconButton(
            onPressed: () {
              Provider.of<AuthViewModel>(context, listen: false).logout(context);
            },
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),

      body: _screens[_selectedIndex],
      drawer: AdminDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },

      ),
    );
  }
}
