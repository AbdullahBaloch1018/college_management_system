// views/announcement_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/TeacherViewModel/announcement_by_teacher_view_model/announcement_view_model.dart';
import '../../../resources/app_colors.dart';

class TeacherAnnouncementView extends StatelessWidget {
  final List<String> classes = [
    'BS-CS 1A',
    'BS-CS 1B',
    'BS-CS 2A',
    'BS-CS 2B',
    'BS-IT 1A',
    'BS-IT 2A',
  ];

  TeacherAnnouncementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCreateAnnouncementCard(viewModel, context),
              const SizedBox(height: 24),
              _buildRecentAnnouncementsSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFB8C00),
            const Color(0xFFFB8C00).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFB8C00).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.campaign, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Announcements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Send important notifications to students',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAnnouncementCard(
    AnnouncementViewModel viewModel,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFB8C00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_circle,
                  color: Color(0xFFFB8C00),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Create New Announcement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: viewModel.titleController,
            decoration: InputDecoration(
              labelText: 'Announcement Title',
              hintText: 'Enter a clear and concise title',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: viewModel.messageController,
            decoration: InputDecoration(
              labelText: 'Message',
              hintText: 'Write your announcement message here...',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(Icons.message),
              ),
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLines: 6,
            maxLength: 500,
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Target Classes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  for (var className in classes) {
                    if (!viewModel.selectedClasses.contains(className)) {
                      viewModel.toggleClass(className);
                    }
                  }
                },
                icon: const Icon(Icons.select_all, size: 18),
                label: const Text('Select All'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  for (var className in List.from(viewModel.selectedClasses)) {
                    viewModel.toggleClass(className);
                  }
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear All'),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${viewModel.selectedClasses.length} selected',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: classes.map((className) {
              final isSelected = viewModel.selectedClasses.contains(className);
              return FilterChip(
                label: Text(className),
                selected: isSelected,
                onSelected: (selected) {
                  viewModel.toggleClass(className);
                },
                selectedColor: const Color(0xFFFB8C00).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFFFB8C00),
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFFB8C00)
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: viewModel.isSending
                  ? null
                  : () async {
                      if (viewModel.titleController.text.trim().isEmpty) {
                        _showErrorSnackBar(context, 'Please enter a title');
                        return;
                      }
                      if (viewModel.messageController.text.trim().isEmpty) {
                        _showErrorSnackBar(context, 'Please enter a message');
                        return;
                      }
                      if (viewModel.selectedClasses.isEmpty) {
                        _showErrorSnackBar(
                          context,
                          'Please select at least one class',
                        );
                        return;
                      }

                      final success = await viewModel.sendAnnouncement(
                        'teacher123',
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  success ? Icons.check_circle : Icons.error,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    success
                                        ? 'Announcement sent successfully to ${viewModel.selectedClasses.length} class(es)!'
                                        : 'Failed to send announcement',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: success
                                ? Colors.green
                                : Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              icon: viewModel.isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(
                viewModel.isSending ? 'Sending...' : 'Send Announcement',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB8C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Announcements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 16),
        _buildAnnouncementCard(
          'Assignment Deadline Extended',
          'The deadline for Database Systems assignment has been extended to next Friday due to technical issues. Please submit your work by 23:59 on Jan 17th.',
          DateTime.now().subtract(const Duration(hours: 2)),
          ['BS-CS 2A', 'BS-CS 2B'],
          'important',
        ),
        _buildAnnouncementCard(
          'Mid-Term Examination Schedule',
          'Mid-term examinations will commence from 15th January. Please check the detailed timetable on your dashboard.',
          DateTime.now().subtract(const Duration(days: 1)),
          ['BS-CS 1A', 'BS-CS 1B', 'BS-CS 2A', 'BS-CS 2B'],
          'urgent',
        ),
        _buildAnnouncementCard(
          'Lab Session Rescheduled',
          'Tomorrow\'s OOP lab session has been rescheduled from 2:00 PM to 3:00 PM in Lab 3.',
          DateTime.now().subtract(const Duration(days: 2)),
          ['BS-CS 1A'],
          'normal',
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(
    String title,
    String message,
    DateTime dateTime,
    List<String> targetClasses,
    String priority,
  ) {
    Color priorityColor;
    IconData priorityIcon;

    switch (priority) {
      case 'urgent':
        priorityColor = Colors.red;
        priorityIcon = Icons.error;
        break;
      case 'important':
        priorityColor = Colors.orange;
        priorityIcon = Icons.warning;
        break;
      default:
        priorityColor = Colors.blue;
        priorityIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: priorityColor.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
                  color: const Color(0xFFFB8C00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.campaign,
                  color: Color(0xFFFB8C00),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: priorityColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                priorityIcon,
                                size: 14,
                                color: priorityColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                priority.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: priorityColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(dateTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: targetClasses.map((className) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  className,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }
}
