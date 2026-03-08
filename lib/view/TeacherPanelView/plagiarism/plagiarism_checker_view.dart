import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/TeacherViewModel/plagiarism_by_teacher_view_model/plagiarism_view_model.dart';

class PlagiarismCheckerView extends StatelessWidget {

  const PlagiarismCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlagiarismViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.plagiarism, size: 32, color: Color(0xFF8E24AA)),
                  SizedBox(width: 12),
                  Text(
                    'Plagiarism Detection',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Check student assignments for originality',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // Upload Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Assignment',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      if (viewModel.selectedFile == null)
                        GestureDetector(
                          onTap: () {
                            viewModel.setFile(File('dummy_path'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text('File selected: assignment.pdf'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF8E24AA), width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFF8E24AA).withValues(alpha: 0.05),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.cloud_upload_outlined, size: 64, color: Color(0xFF8E24AA)),
                                SizedBox(height: 16),
                                Text('Click to upload', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                SizedBox(height: 8),
                                Text('Supported: PDF, DOCX, TXT', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                Text('Maximum: 10MB', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF8E24AA).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.picture_as_pdf, size: 32, color: Color(0xFF8E24AA)),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('assignment.pdf', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text('2.3 MB • PDF Document', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () => viewModel.reset(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: viewModel.isChecking ? null : () async {
                                  await viewModel.checkPlagiarism();
                                },
                                icon: viewModel.isChecking
                                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : Icon(Icons.search),
                                label: Text(viewModel.isChecking ? 'Checking...' : 'Check Plagiarism', style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF8E24AA),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Results
              if (viewModel.similarityScore > 0) ...[
                SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_getColor(viewModel.similarityScore), _getColor(viewModel.similarityScore).withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.analytics, size: 48, color: Colors.white),
                        SizedBox(height: 12),
                        Text('Similarity Score', style: TextStyle(fontSize: 16, color: Colors.white70)),
                        SizedBox(height: 8),
                        Text('${viewModel.similarityScore.toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(_getRisk(viewModel.similarityScore),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Matched Sources (${viewModel.matchedSources.length})',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        ...viewModel.matchedSources.map((source) =>
                            ListTile(
                              leading: Icon(Icons.link, color: Color(0xFF8E24AA)),
                              title: Text(source),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getColor(double score) {
    if (score < 20) return Colors.green;
    if (score < 40) return Colors.orange;
    return Colors.red;
  }

  String _getRisk(double score) {
    if (score < 20) return 'Low Risk';
    if (score < 40) return 'Medium Risk';
    return 'High Risk';
  }
}
