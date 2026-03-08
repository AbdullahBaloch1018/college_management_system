import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../model/teacher_panel_model/class_model.dart';
import '../../../model/teacher_panel_model/subject_model.dart';
import '../../../viewModel/TeacherViewModel/attendance_by_teacher_view_model/attendance_by_teacher_view_model.dart';
import '../../../resources/app_colors.dart';

class AttendanceByTeacherView extends StatelessWidget {
  const AttendanceByTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceByTeacherViewModel>(
      builder: (context, vm, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSelectionCard(vm, context),
              const SizedBox(height: 24),

              // ── Loading states ────────────────────────────
              if (vm.isLoadingStudents)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )

              // ── Error state ───────────────────────────────
              else if (vm.errorMessage != null)
                _buildErrorState(vm.errorMessage!)

              // ── Students loaded ───────────────────────────
              else if (vm.students.isNotEmpty) ...[
                  _buildMarkAllRow(vm),
                  const SizedBox(height: 12),
                  _buildStatsBar(vm),
                  const SizedBox(height: 16),
                  _buildStudentsList(vm),
                  const SizedBox(height: 24),
                  _buildSaveButton(vm, context),
                ]

                // ── Class + subject selected but no students ──
                else if (vm.selectedClass != null && vm.selectedSubject != null)
                    _buildEmptyState(),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.check_circle, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mark Attendance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Class-wise and date-wise attendance',
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

  // ─────────────────────────────────────────────
  // SELECTION CARD  (class → subject → date)
  // ─────────────────────────────────────────────

  Widget _buildSelectionCard(AttendanceByTeacherViewModel vm, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Select Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ── Class dropdown ────────────────────────────
          vm.isLoadingClasses
              ? const _DropdownSkeleton(label: 'Loading classes…')
              : DropdownButtonFormField<ClassModel>(
            decoration: _dropdownDecoration('Select Class', Icons.class_),
            initialValue: vm.selectedClass,
            items: vm.classes.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) vm.setSelectedClass(value);
            },
          ),

          const SizedBox(height: 16),

          // ── Subject dropdown (disabled until class picked) ──
          vm.isLoadingSubjects
              ? const _DropdownSkeleton(label: 'Loading subjects…')
              : DropdownButtonFormField<SubjectModel>(
            decoration: _dropdownDecoration('Select Subject', Icons.book),
            initialValue: vm.selectedSubject,
            disabledHint: Text(
              vm.selectedClass == null
                  ? 'Pick a class first'
                  : 'No subjects found',
              style: TextStyle(color: Colors.grey[500]),
            ),
            items: vm.subjects.map((s) {
              return DropdownMenuItem(
                value: s,
                child: Text(s.subjectName),
              );
            }).toList(),
            onChanged: vm.selectedClass == null
                ? null
                : (value) {
              if (value != null) vm.setSelectedSubject(value);
            },
          ),

          const SizedBox(height: 16),

          // ── Date picker ───────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: vm.selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) vm.setSelectedDate(date);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('MMM dd, yyyy').format(vm.selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  // ─────────────────────────────────────────────
  // MARK ALL ROW
  // ─────────────────────────────────────────────

  Widget _buildMarkAllRow(AttendanceByTeacherViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: vm.markAllPresent,
            icon: const Icon(Icons.check_circle, color: Colors.green),
            label: const Text(
              'Mark All Present',
              style: TextStyle(color: Colors.green),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: vm.markAllAbsent,
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text(
              'Mark All Absent',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STATS BAR
  // ─────────────────────────────────────────────

  Widget _buildStatsBar(AttendanceByTeacherViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            vm.students.length.toString(),
            Icons.people,
            AppColors.primary,
          ),
          _buildStatItem(
            'Present',
            vm.presentCount.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatItem(
            'Absent',
            vm.absentCount.toString(),
            Icons.cancel,
            Colors.red,
          ),
          _buildStatItem(
            'Rate',
            '${vm.presentPercentage.toStringAsFixed(1)}%',
            Icons.percent,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STUDENTS LIST
  // ─────────────────────────────────────────────

  Widget _buildStudentsList(AttendanceByTeacherViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student List  (${vm.students.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...vm.students.map((student) {
          final isPresent = student.attendanceStatus == 'Present';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPresent
                    ? Colors.green.withValues(alpha: 0.4)
                    : Colors.red.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar with roll number
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isPresent
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  child: Text(
                    student.rollNo.length > 4
                        ? student.rollNo.substring(student.rollNo.length - 4)
                        : student.rollNo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Roll No: ${student.rollNo}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status chip
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isPresent,
                  onChanged: (_) => vm.toggleAttendance(student.uid),
                  activeThumbColor: Colors.green,
                  activeTrackColor: Colors.green.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SAVE BUTTON
  // ─────────────────────────────────────────────

  Widget _buildSaveButton(AttendanceByTeacherViewModel vm, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: vm.isSaving
            ? null
            : () async {
          final success = await vm.saveAttendance();
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
                            ? 'Attendance saved successfully!' : 'Failed to save attendance. Try again.',
                      ),
                    ),
                  ],
                ),
                backgroundColor: success ? Colors.green : Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        icon: vm.isSaving ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.save),
        label: Text(
          vm.isSaving ? 'Saving…' : 'Save Attendance',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // EMPTY / ERROR STATES
  // ─────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No Students Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No students are enrolled in this class yet.',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    if (kDebugMode) {
      print("The Error is $message");
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(

            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SKELETON WIDGET  (shown while loading dropdown data)
// ─────────────────────────────────────────────

class _DropdownSkeleton extends StatelessWidget {
  final String label;
  const _DropdownSkeleton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}