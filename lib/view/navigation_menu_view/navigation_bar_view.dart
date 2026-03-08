import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../../viewModel/navigation_provider.dart';
import '../home_view/home_view.dart';
import '../notification_view/notification_view.dart';
import '../prediction_screen.dart';
import '../user_profile_view/profile_view.dart';

class NavigationMenuView extends StatefulWidget {
  const NavigationMenuView({super.key});

  @override
  State<NavigationMenuView> createState() => _NavigationMenuViewState();
}

class _NavigationMenuViewState extends State<NavigationMenuView> {
  final List<Widget> screens = const [
     HomeView(),
     NotificationView(),
     PredictionScreen(),
     ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          //SCREEN CHANGING
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: screens[navProvider.selectedIndex],
          ),

          bottomNavigationBar: WaterDropNavBar(
            backgroundColor: Colors.white,
            waterDropColor: Colors.blue.shade800,
            selectedIndex: navProvider.selectedIndex,
            bottomPadding: 20,
            onItemSelected: (index) {
              navProvider.updateIndex(index);
            },
            barItems: [
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),
              BarItem(
                filledIcon: Icons.notifications,
                outlinedIcon: Icons.notifications_outlined,
              ),
              BarItem(
                filledIcon: Icons.psychology,
                outlinedIcon: Icons.psychology_outlined,
              ),
              BarItem(
                filledIcon: Icons.person,
                outlinedIcon: Icons.person_outline,
              ),
            ],
          ),

        );
      },
    );
  }
}
