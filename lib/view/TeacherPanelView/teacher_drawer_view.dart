import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';
import '../../viewModel/TeacherViewModel/teacher_dashboard_view_model/teacher_dashboard_view_model.dart';

class TeacherDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const TeacherDrawer({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<TeacherDashboardViewModel>(
            builder: (context, viewModel, child) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // colors: [AppColors.primary,AppColors.primary.withValues(alpha: 0.8),],
                    colors: [AppColors.darkMaroon,AppColors.mediumMaroon],

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Text(
                        viewModel.profile?['displayName'].substring(0, 1).toUpperCase() ?? 'T',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.profile?['displayName'] ?? 'Teacher',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.profile?['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.check_circle, 'Attendance', 1),
          _buildDrawerItem(Icons.grade, 'Results', 2),
          _buildDrawerItem(Icons.analytics, 'AI Analysis', 3),
          _buildDrawerItem(Icons.plagiarism, 'Plagiarism Check', 4),
          _buildDrawerItem(Icons.announcement, 'Announcements', 5),
          _buildDrawerItem(Icons.assignment, 'Assignments', 6),
          _buildDrawerItem(Icons.calendar_today, 'Timetable', 7),
          const Divider(),
          _buildDrawerItem(Icons.person, 'Profile', 8),
          // _buildDrawerItem(Icons.settings, 'Settings', 9),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.grey[700],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primary : Colors.grey[800],
          ),
        ),
        selected: isSelected,
        onTap: () => onItemTapped(index),
      ),
    );
  }
}

