import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewModel/notification_view_model.dart';
import '../../widgets/shimmer.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationViewModel>(context, listen: false)
        .fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = Provider.of<NotificationViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: notificationViewModel.isLoading
          ? ShimmerHomeworkSection(
        cardCount: 3,
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      )
          : notificationViewModel.errorMessage != null
          ? Center(
        child: Text(
          'Error: ${notificationViewModel.errorMessage}',
          style: const TextStyle(color: Colors.red),
        ),
      )
          : notificationViewModel.notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notificationViewModel.notifications.length,
        itemBuilder: (context, index) {
          final notification =
          notificationViewModel.notifications[index];
          final formattedDate = DateFormat('MMM dd, yyyy – hh:mm a')
              .format(notification.date);

          final color = _getCategoryColor(notification.category);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(
                                notification.category),
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            notification.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color:
                              Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        notification.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Reminder":
        return Icons.notifications_active;
      case "Event":
        return Icons.event;
      case "Announcement":
        return Icons.announcement;
      default:
        return Icons.info;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Reminder":
        return Colors.teal;
      case "Event":
        return Colors.deepOrange;
      case "Announcement":
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
