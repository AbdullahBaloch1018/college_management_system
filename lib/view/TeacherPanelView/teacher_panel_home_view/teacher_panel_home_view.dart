import 'package:flutter/material.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/view/TeacherPanelView/announcement_view/teacher_announcement_view.dart';
import 'package:rise_college/view/TeacherPanelView/dashboard/teacher_dashboard_view.dart';
import 'package:rise_college/view/TeacherPanelView/plagiarism/plagiarism_checker_view.dart';
import 'package:rise_college/view/TeacherPanelView/result_management/result_management_view.dart';
import 'package:rise_college/view/TeacherPanelView/ai_analysis/ai_performance_analysis_view.dart';
import 'package:rise_college/view/TeacherPanelView/assignments/assignment_management_view.dart';
import 'package:rise_college/view/TeacherPanelView/timetable/teacher_timetable_view.dart';
import 'package:rise_college/view/TeacherPanelView/profile/teacher_profile_view.dart';
import '../attendance/attendance_by_teacher_view.dart';
import '../teacher_drawer_view.dart';
class TeacherPanelHomeView extends StatefulWidget {
  const TeacherPanelHomeView({super.key});

  @override
  State<TeacherPanelHomeView> createState() => _TeacherPanelHomeViewState();
}

class _TeacherPanelHomeViewState extends State<TeacherPanelHomeView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TeacherDashboardView(),
     // By Claude
    AttendanceByTeacherView(),
     // TeacherAttendanceView(),
    ResultManagementView(),
    const AIPerformanceAnalysisView(),
    const PlagiarismCheckerView(),
    TeacherAnnouncementView(),
    const AssignmentManagementView(),
    const TeacherTimetableView(),
    const TeacherProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text("Teacher Panel")),
      body: _screens[_selectedIndex],
      drawer: TeacherDrawer(
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


