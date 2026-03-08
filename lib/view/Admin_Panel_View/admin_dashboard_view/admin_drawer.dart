import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';

import '../../../viewModel/AdminViewModel/admin_main_view_model/admin_dashboard_view_model.dart';

class AdminDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AdminDrawer({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Admin Profile
          Consumer<AdminDashboardViewModel>(
            builder: (context, viewModel, child) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                    colors: [AppColors.darkMaroon,AppColors.mediumMaroon],
                  ),
                ),
                accountName: Text(viewModel.adminName ?? 'Administrator'),
                accountEmail: Text(viewModel.adminEmail ?? 'Admin@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text((viewModel.adminName != null && viewModel.adminName!.isNotEmpty) ? viewModel.adminName![0].toUpperCase() : 'A',
                    style: const TextStyle(
                      fontSize: 24,
                      // color: Color(0xFF6A1B9A),
                      color: AppColors.lightMaroon,
                    ),
                  ),
                ),
              );
            },
          ),
          // Widgets
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.people, 'User Management', 1),
          _buildDrawerItem(Icons.class_, 'Class Management', 2),
          _buildDrawerItem(Icons.book, 'Subject Management', 3),
          _buildDrawerItem(Icons.schedule, 'Timetable', 4),
          _buildDrawerItem(Icons.settings, 'System Settings', 5),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index ? AppColors.lightMaroon : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight:
          selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          color: selectedIndex == index ? AppColors.mediumMaroon : null,
        ),
      ),
      selected: selectedIndex == index,
      onTap: () => onItemTapped(index),
    );
  }
}