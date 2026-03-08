// views/result_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/teacher_panel_model/result_model.dart';
import '../../../viewModel/TeacherViewModel/result_by_teacher_view_model/result_view_model.dart';

class ResultManagementView extends StatelessWidget {
  final List<String> classes = ['BS-CS 1A', 'BS-CS 1B', 'BS-CS 2A', 'BS-CS 2B'];
  final List<String> subjects = [
    'Programming Fundamentals',
    'Database Systems',
    'OOP',
    'Data Structures',
    'Web Development'
  ];

  ResultManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.grade, size: 32, color: Color(0xFF1E88E5)),
                    SizedBox(width: 12),
                    Text(
                      'Result Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Enter student marks and generate report cards',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 24),

                // Selection Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Class & Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Class',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.class_),
                          ),
                          initialValue: viewModel.selectedClass.isEmpty
                              ? null
                              : viewModel.selectedClass,
                          items: classes.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.setSelectedClass(value);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Subject',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.book),
                          ),
                          initialValue: viewModel.selectedSubject.isEmpty
                              ? null
                              : viewModel.selectedSubject,
                          items: subjects.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.setSelectedSubject(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Loading Indicator
                if (viewModel.isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )

                // Student Results List
                else if (viewModel.results.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter Marks (${viewModel.results.length} Students)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('Total: 100'),
                        backgroundColor: Colors.blue[50],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Student Cards
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: viewModel.results.length,
                    itemBuilder: (context, index) {
                      final result = viewModel.results[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFF1E88E5),
                                    child: Text(
                                      result.rollNo,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result.studentName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Roll No: ${result.rollNo}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Marks',
                                        hintText: 'Enter marks (0-100)',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        prefixIcon: Icon(Icons.edit),
                                        suffixText: '/100',
                                      ),
                                      keyboardType: TextInputType.number,
                                      initialValue: result.marks > 0
                                          ? result.marks.toString()
                                          : '',
                                      onChanged: (value) {
                                        final marks = double.tryParse(value) ?? 0;
                                        if (marks >= 0 && marks <= 100) {
                                          viewModel.updateMarks(result.studentId, marks);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 58,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getGradeColor(result.grade),
                                            _getGradeColor(result.grade).withValues(alpha: 0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getGradeColor(result.grade).withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Grade',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            result.grade.isEmpty ? '-' : result.grade,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (result.marks > 0) ...[
                                SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: result.marks / 100,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getGradeColor(result.grade),
                                  ),
                                  minHeight: 6,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            viewModel.loadResults();
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final success = await viewModel.generateReportCards();
                            if(context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        success ? Icons.check_circle : Icons
                                            .error,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          success
                                              ? 'Report cards generated successfully!'
                                              : 'Failed to generate report cards',
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.file_download),
                          label: Text('Generate Report Cards'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Statistics Card
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Average',
                            _calculateAverage(viewModel.results).toStringAsFixed(1),
                            Icons.analytics,
                          ),
                          _buildStatItem(
                            'Highest',
                            _getHighest(viewModel.results).toStringAsFixed(0),
                            Icons.arrow_upward,
                          ),
                          _buildStatItem(
                            'Lowest',
                            _getLowest(viewModel.results).toStringAsFixed(0),
                            Icons.arrow_downward,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Empty State
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Results Yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Select a class and subject to start',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF1E88E5)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E88E5),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  double _calculateAverage(List<ResultModel> results) {
    if (results.isEmpty) return 0;
    double sum = 0;
    int count = 0;
    for (var result in results) {
      if (result.marks > 0) {
        sum += result.marks;
        count++;
      }
    }
    return count > 0 ? sum / count : 0;
  }

  double _getHighest(List<ResultModel> results) {
    if (results.isEmpty) return 0;
    double highest = 0;
    for (var result in results) {
      if (result.marks > highest) {
        highest = result.marks;
      }
    }
    return highest;
  }

  double _getLowest(List<ResultModel> results) {
    if (results.isEmpty) return 0;
    double lowest = 100;
    for (var result in results) {
      if (result.marks > 0 && result.marks < lowest) {
        lowest = result.marks;
      }
    }
    return lowest == 100 ? 0 : lowest;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Color(0xFF4CAF50);
      case 'B':
        return Color(0xFF2196F3);
      case 'C':
        return Color(0xFFFF9800);
      case 'D':
        return Color(0xFFFF5722);
      case 'F':
        return Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }
}