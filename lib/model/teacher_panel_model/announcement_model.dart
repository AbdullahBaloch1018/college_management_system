class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final String senderId;
  final List<String> recipients;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.senderId,
    required this.recipients,
  });
}
