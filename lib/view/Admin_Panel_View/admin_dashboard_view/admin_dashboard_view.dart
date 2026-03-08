// It is our 1st screen of admin panel which is showing up first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';
import '../../../utils/routes/routes_name.dart';
import '../../../viewModel/AdminViewModel/admin_main_view_model/admin_dashboard_view_model.dart';
import '../../../Services/admin_panel_Services/admin_analytics_repository.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});
  

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminDashboardViewModel>(context, listen: false);
    final repo = AdminAnalyticsRepository();

    return Scaffold(
      body: StreamBuilder<Map<String, int>>(
        stream: repo.watchDashboardStats(),
        builder: (context, snapshot) {
          // Stream states handling
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No Stats available'));
          }

          final stats = snapshot.data!;
          final students = stats['students'] ?? 0;
          final teachers = stats['teachers'] ?? 0;
          final classes = stats['classes'] ?? 0;
          final subjects = stats['subjects'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${viewModel.adminName}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s an overview of your institution',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Stats Grid ── now using real-time values
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildStatCard(
                      'Total Students',
                      '$students',
                      Icons.school,
                      const Color(0xFF1E88E5),
                    ),
                    _buildStatCard(
                      'Total Teachers',
                      '$teachers',
                      Icons.person,
                      const Color(0xFF43A047),
                    ),
                    _buildStatCard(
                      'Total Classes',
                      '$classes',
                      Icons.class_,
                      const Color(0xFFFB8C00),
                    ),
                    _buildStatCard(
                      'Total Subjects',
                      '$subjects',
                      Icons.book,
                      const Color(0xFF8E24AA),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // You can keep or remove these — currently placeholders
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Avg Attendance',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '— %', // TODO: implement real stream later
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF43A047),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Pending Approvals',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '—',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFB8C00),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildQuickActionButton(
                      context,
                      'Add User',
                      Icons.person_add,
                          () => Navigator.pushNamed(context, RoutesName.createUserByAdminView),
                    ),
                    _buildQuickActionButton(
                      context,
                      'Create Class',
                      Icons.add_box,
                          () => Navigator.pushNamed(context, RoutesName.createClassByAdminView),
                    ),
                    _buildQuickActionButton(
                      context,
                      'Add Subject',
                      Icons.library_add,
                          () => Navigator.pushNamed(context, RoutesName.createSubjectByAdminView),
                    ),
                    _buildQuickActionButton(
                      context,
                      'View Reports',
                      Icons.assessment,
                          () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onTap,
      ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightMaroon,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}