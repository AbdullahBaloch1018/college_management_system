import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/firebase_options.dart';
import 'package:rise_college/utils/routes/routes.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import 'package:rise_college/viewModel/admin_panel_view_model.dart';
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
import 'package:rise_college/viewModel/user_role_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 /// old firebase configuration
  /*await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDVZBV6gXfOFtvuh21hxi9yVgShl_ZL2Qg',
        appId: '1:854814242691:android:1003ed0a03987b99b5a8b6',
        messagingSenderId: 'messagingSenderId',
        projectId: 'collegemanagementappacem',
      ),
  );*/

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
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
        // ChangeNotifierProvider(create: (_) => UserRoleViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'College  Management System',
        // home: AdminDashboardWebView(),
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
