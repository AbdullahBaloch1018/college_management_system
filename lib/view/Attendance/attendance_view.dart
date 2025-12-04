import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../viewModel/attendance_view_model.dart';

//get the attendance count of the student from firebase using firebase auth
class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AttendanceViewModel>(
        context,
        listen: false,
      );
      viewModel.loadLocalAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AttendanceViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Data')),
      body:
          viewModel.isLoading // will add a animation later
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    headerStyle: HeaderStyle(formatButtonVisible: false),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        bool attended =
                            viewModel.markedDates[DateTime(
                              date.year,
                              date.month,
                              date.day,
                            )] ==
                            true;
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: attended ? Colors.green : Colors.red,
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 13.0,
                      percent:
                          (viewModel.attendancePercentage.clamp(0, 100)) / 100,
                      center: Text(
                        "${viewModel.attendancePercentage.toStringAsFixed(2)}%",
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      progressColor: Colors.blue,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Attendance Count: ${viewModel.attendanceCount}",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
