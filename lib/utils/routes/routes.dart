import 'package:flutter/material.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
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
  static MaterialPageRoute generateRoute(RouteSettings settings){
    switch(settings.name)
    {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => SplashView(),);
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => LoginView(),);

      case RoutesName.navMenu:
        return MaterialPageRoute(builder: (context) => NavigationMenuView(),);

      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => HomeView(),);
      case RoutesName.signup:
        return MaterialPageRoute(builder: (context) => SignupView(),);
    case RoutesName.calendar:
    return MaterialPageRoute(builder: (_) => const Calendar());

    case RoutesName.notification:
    return MaterialPageRoute(builder: (_) => const NotificationView());

    case RoutesName.search:
    return MaterialPageRoute(builder: (_) => const PredictionScreen());

    case RoutesName.profile:
    return MaterialPageRoute(
    builder: (_) =>ProfileView(),
    );
    

    case RoutesName.uploadAPI:
    return MaterialPageRoute(builder: (_) => MyApp1());

      // No routes
      default:
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("No Route Found"),
              centerTitle: true,
            ),
            body: Center(
              child: Text("No Route Found"),
            ),
          );
        },
        );
    }

  }
}