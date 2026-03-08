import 'package:flutter/material.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import 'package:rise_college/view/Admin_Panel_View/class_management_view/create_class_by_admin_view.dart';
import 'package:rise_college/view/Admin_Panel_View/subject_management_view/create_subject_by_admin_view.dart';
import 'package:rise_college/view/Admin_Panel_View/user_management_view/create_user_by_admin_view.dart';
import 'package:rise_college/view/Admin_Panel_View/user_management_view/edit_user_by_admin_view.dart';
import 'package:rise_college/view/pending_approval_view/pending_approval_view.dart';
import '../../view/Admin_Panel_View/admin_dashboard_view/admin_main_view.dart';
import '../../view/TeacherPanelView/ai_analysis/ai_performance_analysis_view.dart';
import '../../view/TeacherPanelView/assignments/create_assignment_view.dart';
import '../../view/TeacherPanelView/teacher_panel_home_view/teacher_panel_home_view.dart';
import '../../view/TeacherPanelView/timetable/create_timetable_view.dart';
import '../../view/prediction_screen.dart';
import '../../view/user_profile_view/profile_view.dart';
import '../../uploadtoapi/uploadapi.dart';
import '../../view/auth_view/login_view.dart';
import '../../view/auth_view/signup_view.dart';
import '../../view/home_view/home_view.dart';
import '../../view/navigation_menu_view/navigation_bar_view.dart';
import '../../view/notification_view/notification_view.dart';
import '../../view/splash_view.dart';
import '../../widgets/calendar.dart';

class Routes {
  // GLOBAL FADE TRANSITION
  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) =>
          FadeTransition(opacity: animation, child: page),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // ROUTE GENERATOR WITH GLOBAL FADE EFFECT

  static Route<dynamic> generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case RoutesName.splash:
        page = const SplashView();
        break;

      case RoutesName.login:
        page = const LoginView();
        break;

      case RoutesName.signup:
        page = const SignupView();
        break;

      //   Pending Approval View from Admin
      case RoutesName.pendingApprovalView:
        page = const PendingApprovalView();
        break;


      case RoutesName.navMenu:
        page = const NavigationMenuView();
        break;

      case RoutesName.home:
        page = const HomeView();
        break;

      case RoutesName.calendar:
        page = const Calendar();
        break;

      case RoutesName.notification:
        page = const NotificationView();
        break;

      case RoutesName.search:
        page = const PredictionScreen();
        break;

      case RoutesName.profile:
        page = ProfileView();
        break;

      case RoutesName.uploadAPI:
        page = MyApp1();
        break;

      ///   Teacher Panel Routes Below
      case RoutesName.teacherDashboardView:
        page = TeacherPanelHomeView();
        break;
      case RoutesName.aiPerformanceAnalysisView:
        page = AIPerformanceAnalysisView();
        break;
      case RoutesName.createAssignmentView:
        page = CreateAssignmentView();
        break;
      case RoutesName.createTimetableView:
        page = CreateTimetableView();
        break;

      ///   Admin Panel Routes Below
      case RoutesName.adminMainView:
        page = AdminMainView();
        break;
      case RoutesName.createUserByAdminView:
        page = CreateUserByAdminView();
        break;

      case RoutesName.editUserByAdminView:
        final args = settings.arguments as Map<String, dynamic>;
        page = EditUserByAdminView(user: args);
        break;

      case RoutesName.createClassByAdminView:
        page = CreateClassByAdminView();
        break;

      case RoutesName.createSubjectByAdminView:
        page = CreateSubjectByAdminView();
        break;

      default:
        page = Scaffold(
          appBar: AppBar(
            title: const Text("No Route Found"),
            centerTitle: true,
          ),
          body: const Center(child: Text("No Route Found")),
        );
    }

    return _fadeRoute(page);
  }
}
