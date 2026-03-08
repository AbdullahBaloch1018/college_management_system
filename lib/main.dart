import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/firebase_options.dart';
import 'package:rise_college/utils/routes/routes.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import 'package:rise_college/viewModel/AdminViewModel/admin_main_view_model/admin_dashboard_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/admin_system_setting_view_model/admin_system_setting_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/class_management_view_model/class_management_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/class_management_view_model/create_class_by_admin_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/subject_management_by_admin_view_model/subject_management_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/admin_timetable_view_model/admin_timetable_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/user_management_view_model/create_user_by_admin_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/user_management_view_model/edit_user_by_admin_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/user_management_view_model/user_management_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/announcement_by_teacher_view_model/announcement_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/attendance_by_teacher_view_model/attendance_by_teacher_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/plagiarism_by_teacher_view_model/plagiarism_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/result_by_teacher_view_model/result_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/teacher_class_view_model/teacher_class_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/teacher_dashboard_view_model/teacher_dashboard_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/ai_performance_view_model/ai_performance_view_model.dart';
import 'package:rise_college/viewModel/TeacherViewModel/assignment_by_teacher_view_model/assignment_view_model.dart';
import 'package:rise_college/viewModel/AdminViewModel/admin_main_view_model/admin_panel_view_model.dart';
import 'package:rise_college/viewModel/attendance_view_model.dart';
import 'package:rise_college/viewModel/auth_view_model.dart';
import 'package:rise_college/viewModel/home_view_model.dart';
import 'package:rise_college/viewModel/homework_view_model.dart';
import 'package:rise_college/viewModel/image_upload_provider.dart';
import 'package:rise_college/viewModel/marks_view_model.dart';
import 'package:rise_college/viewModel/navigation_provider.dart';
import 'package:rise_college/viewModel/news_view_model.dart';
import 'package:rise_college/viewModel/notification_view_model.dart';
import 'package:rise_college/viewModel/predictor_data_view_model.dart';
import 'package:rise_college/viewModel/predictor_view_model.dart';
import 'package:rise_college/viewModel/seminar_view_model.dart';
import 'package:rise_college/viewModel/chart_view_model.dart';
import 'package:rise_college/viewModel/timetable_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModelOriginal()),
        ChangeNotifierProvider(create: (_) => HomeworkViewModel()),
        ChangeNotifierProvider(create: (_) => PredictorViewModel()),
        ChangeNotifierProvider(create: (_) => MarksViewModel()),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ChangeNotifierProvider(create: (_) => View3DataViewModel()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => SeminarViewModel()),
        ChangeNotifierProvider(create: (_) => ChartViewModel()),
        ChangeNotifierProvider(create: (_) => TimetableViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),

        /// Teacher Panel
        ChangeNotifierProvider(create: (_) => TeacherDashboardViewModel()),
        // ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        // By Claude
        ChangeNotifierProvider(create: (_) => AttendanceByTeacherViewModel()),
        ChangeNotifierProvider(create: (_) => ResultViewModel()),
        ChangeNotifierProvider(create: (_) => PlagiarismViewModel()),
        ChangeNotifierProvider(create: (_) => AnnouncementViewModel()),
        ChangeNotifierProvider(create: (_) => AIPerformanceViewModel()),
        ChangeNotifierProvider(create: (_) => AssignmentViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherClassViewModel()),


        /// Admin Panel
        ChangeNotifierProvider(create: (_) => AdminDashboardViewModel()),
        ChangeNotifierProvider(create: (_) => UserManagementViewModel()),
        ChangeNotifierProvider(create: (_) => ClassManagementByAdminViewModel(),),
        ChangeNotifierProvider(create: (_) => SubjectManagementViewModel(),),
        ChangeNotifierProvider(create: (_) => AdminTimetableViewModel()..loadTimetable(),),
        ChangeNotifierProvider(create: (_) => AdminSystemSettingViewModel()..listenToSettings(),),

        ChangeNotifierProvider(create: (_) => CreateUserByAdminViewModel()),
        ChangeNotifierProvider(create: (_) => EditUserByAdminViewModel()),

        ChangeNotifierProvider(create: (_) => CreateClassByAdminViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'College  Management System',
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          // backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          // fontFamily: 'Inter',
          textTheme: GoogleFonts.salsaTextTheme(),
        ),
      ),
    );
  }
}
