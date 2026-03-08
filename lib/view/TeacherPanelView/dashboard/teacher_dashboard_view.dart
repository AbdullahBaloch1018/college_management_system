import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../viewModel/TeacherViewModel/teacher_dashboard_view_model/teacher_dashboard_view_model.dart';
import '../../../resources/app_colors.dart';

class TeacherDashboardView extends StatefulWidget {
  const TeacherDashboardView({super.key});

  @override
  State<TeacherDashboardView> createState() => _TeacherDashboardViewState();
}

class _TeacherDashboardViewState extends State<TeacherDashboardView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TeacherDashboardViewModel>().loadTeacherData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Teacher Dashboard / 1ST Screen View");
    }
    return Consumer<TeacherDashboardViewModel>(
      builder: (context, vm, child) {

        if (vm.error.isNotEmpty && !vm.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Error: ${vm.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => vm.loadTeacherData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (vm.isLoading) {
          return _buildLoadingState();
        }

        final teacherName = vm.profile?['displayName']?.toString() ?? 'Teacher';
        final faculty = vm.profile?['faculty']?.toString() ?? '';

        return RefreshIndicator(
          onRefresh: () => vm.refresh(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(teacherName, faculty),
                const SizedBox(height: 24),
                _buildStatsGrid(vm),
                const SizedBox(height: 24),
                _buildAtRiskStudentsCard(context, vm),
                const SizedBox(height: 24),
                _buildAttendanceChart(vm),
                const SizedBox(height: 24),
                _buildTodaySchedule(vm),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Loading dashboard...', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(String name, String dept) {
    final hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mediumMaroon,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting,
              style: const TextStyle(
                  fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(dept,
              style: TextStyle(
                  fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(TeacherDashboardViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          title: 'Total Students',
          value: viewModel.totalStudents.toString(),
          icon: Icons.people,
          color: Colors.blue,
          onTap: () { if (kDebugMode) print("Student Container clicked"); },
        ),
        _buildStatCard(
          title: 'Total Classes',
          value: viewModel.totalClasses.toString(),
          icon: Icons.class_,
          color: Colors.green,
          onTap: () { if (kDebugMode) print("Total Classes Container clicked"); },
        ),
        _buildStatCard(
          title: 'Avg Attendance',
          value: '${viewModel.averageAttendance.toStringAsFixed(1)}%',
          icon: Icons.check_circle,
          color: Colors.orange,
          onTap: () { if (kDebugMode) print("Attendance View Container clicked"); },
        ),
        _buildStatCard(
          title: 'At-Risk Students',
          value: viewModel.atRiskStudents.toString(),
          icon: Icons.warning,
          color: Colors.red,
          onTap: () { if (kDebugMode) print("At Risk Student Container clicked"); },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: AppColors.white,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(value,
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAtRiskStudentsCard(
      BuildContext context, TeacherDashboardViewModel viewModel) {
    if (viewModel.atRiskStudents == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.red.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('At-Risk Students (AI Analysis)',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${viewModel.atRiskStudents} students need attention',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...viewModel.atRiskStudentsList.take(3).map((student) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  child: Text(student['rollNo']?.toString() ?? '?',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          student['displayName']?.toString() ??
                              'Unknown Student',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(student['classId']?.toString() ?? 'N/A',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('Low Attendance',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )),
          if (viewModel.atRiskStudents > 3)
            TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, RoutesName.aiPerformanceAnalysisView);
              },
              child: const Text('View All At-Risk Students'),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart(TeacherDashboardViewModel viewModel) {
    return Card(
      elevation: 7,
      color: AppColors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Attendance Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: viewModel.attendanceSummary['Present'] ?? 0,
                      title:
                      '${(viewModel.attendanceSummary['Present'] ?? 0).toStringAsFixed(0)}%',
                      color: Colors.green,
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: viewModel.attendanceSummary['Absent'] ?? 0,
                      title:
                      '${(viewModel.attendanceSummary['Absent'] ?? 0).toStringAsFixed(0)}%',
                      color: Colors.red,
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: viewModel.attendanceSummary['Late'] ?? 0,
                      title:
                      '${(viewModel.attendanceSummary['Late'] ?? 0).toStringAsFixed(0)}%',
                      color: Colors.orange,
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Present', Colors.green),
                _buildLegendItem('Absent', Colors.red),
                _buildLegendItem('Late', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildTodaySchedule(TeacherDashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Schedule",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        if (viewModel.todaySchedule.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('No classes scheduled today',
                  style: TextStyle(color: Colors.grey[500])),
            ),
          )
        else
          ...viewModel.todaySchedule.map((schedule) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.schedule,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schedule['subject'] ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.class_,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(schedule['class'] ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(width: 12),
                          Icon(Icons.room,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(schedule['room'] ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(schedule['time'] ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
          )),
      ],
    );
  }
}