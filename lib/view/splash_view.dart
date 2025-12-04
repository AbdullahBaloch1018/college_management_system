import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'auth_view/login_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSplashScreen(
          splash: SizedBox.expand(
            child: Lottie.asset(
              'animations/reading.json',
              repeat: true,
              reverse: true,
              animate: true,
              fit: BoxFit.cover,
            ),
          ),
          nextScreen: LoginView(),
          // nextScreen: NavigationMenu(),
          splashTransition: SplashTransition.fadeTransition,
          duration: 3000,
        ),
        // College Logo
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          right: MediaQuery.of(context).size.width * 0.3,
          child: const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('svgimage/rise_logo.png'),
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Bridging Ideas, Building Engineers ',
            style: TextStyle(
              color: Colors.green,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
