import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewModel/homework_view_model.dart';
import '../../widgets/shimmer.dart';

class HomeWorkView extends StatelessWidget {
  const HomeWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("HomeWork rebuilding");
    }
    final subjects = [
      'Telecommunication',
      'Information System',
      'Big Data',
      'Multimedia',
      'EPP',
      'Computer Science',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Homework',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: subjects.map((subject) {
            return SubjectHomeworkList(subject: subject);
          }).toList(),
        ),
      ),
    );
  }
}

// SubjectHomeworkList is a widget that displays the homework for a specific subject
class SubjectHomeworkList extends StatefulWidget {
  final String subject;

  const SubjectHomeworkList({super.key, required this.subject});

  @override
  State<SubjectHomeworkList> createState() => _SubjectHomeworkListState();
}

class _SubjectHomeworkListState extends State<SubjectHomeworkList> {
  final List<Color> _gradientColors = [
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
  ];

  // Method for changing subject colors
  Color _getSubjectColor(String subject) {
    int index = widget.subject.hashCode % _gradientColors.length;
    return _gradientColors[index.abs()];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeworkViewModel>(
        context,
        listen: false,
      ).fetchHomework(widget.subject);
    });
  }

  // _getDaysRemaining is a function that calculates the number of days remaining until the due date
  String _getDaysRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.inDays < 0) {
      return 'Overdue';
    } else if (difference.inDays == 0) {
      return 'Due today';
    } else if (difference.inDays == 1) {
      return 'Due tomorrow';
    } else {
      return '${difference.inDays} days remaining';
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.inDays < 0) {
      return Colors.red;
    } else if (difference.inDays <= 2) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeworkViewModel = Provider.of<HomeworkViewModel>(context);

    if (homeworkViewModel.isLoading) {
      return ShimmerHomeworkSection(
        cardCount: 2,
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      );
    }

    if (homeworkViewModel.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Error: ${homeworkViewModel.errorMessage}',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final subjectHomework = homeworkViewModel.homeworkData[widget.subject] ?? [];

    if (subjectHomework.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'No homework available for ${widget.subject}',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ),
        ),
      );
    }

    final subjectColor = _getSubjectColor(widget.subject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: subjectColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.subject,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${subjectHomework.length}',
                  style: TextStyle(
                    color: subjectColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: subjectHomework.length,
            itemBuilder: (context, index) {
              final homework = subjectHomework[index];
              final dueDate = homework.dueDate;
              final formattedDueDate = DateFormat('MMM dd, yyyy',).format(dueDate);
              final daysRemaining = _getDaysRemaining(dueDate);
              final dueDateColor = _getDueDateColor(dueDate);

              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [subjectColor, subjectColor.withOpacity(0.7)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      homework.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                homework.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDueDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        daysRemaining,
                                        style: TextStyle(
                                          color: dueDateColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
