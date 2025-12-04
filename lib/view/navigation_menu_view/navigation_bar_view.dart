import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rise_college/resources/app_colors.dart';

import '../../viewModel/navigation_provider.dart';
import '../home_view/home_view.dart';
import '../notification_view/notification_view.dart';
import '../prediction_screen.dart';
import '../user_profile_view/profile_view.dart';

class NavigationMenuView extends StatelessWidget {
  const NavigationMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final screens = [
      const HomeView(),
      const NotificationView(),
      const PredictionScreen(),
      const ProfileView(),
    ];

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          // MODERN NAVIGATION BAR
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: NavigationBar(
                height: 70,
                elevation: 7,
                backgroundColor: Colors.white,
                shadowColor: Colors.black12,
                indicatorColor: Colors.blue.shade100,
                selectedIndex: navProvider.selectedIndex,

                onDestinationSelected: (index) {
                  navProvider.updateIndex(index);
                },

                destinations: const [
                  NavigationDestination(
                    icon: Icon(Iconsax.home),
                    selectedIcon: Icon(Iconsax.home_1),
                    label: "Home",
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.notification),
                    selectedIcon: Icon(Iconsax.notification5),
                    label: "Updates",
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.medal),
                    selectedIcon: Icon(Iconsax.medal_star),
                    label: "Predict",
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.user),
                    selectedIcon: Icon(Iconsax.user_edit),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),

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
        );
      },
    );
  }
}
