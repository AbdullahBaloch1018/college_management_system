import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/viewModel/navigation_provider.dart';

import '../../Services/user_service.dart';
import '../../model/user_model.dart';
import '../../resources/components/round_button.dart';
import '../../utils/routes/routes_name.dart';

// Student Profile View
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<UserModel> userData;

  @override
  void initState() {
    super.initState();
    // Mock Data for now
    userData = UserService().getUserMock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(titleWidget: Text("Profile")),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xFF8E2DE2),
          //       Color(0xFF4A00E0),
          //     ],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),

          child: FutureBuilder<UserModel>(
            future: userData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              UserModel user = snapshot.data!;

              return Column(
                children: [
                  const SizedBox(height: 80),

                  // Profile Picture
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "image/acem-logo-transformed .png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Fields
                  InfoTile(label: "Name", value: user.name, icon: Icons.person),
                  InfoTile(label: "Email", value: user.email, icon: Icons.email),
                  InfoTile(label: "Roll Number", value: user.rollNumber, icon: Icons.confirmation_num),
                  InfoTile(label: "Faculty", value: user.faculty, icon: Icons.school),
                  InfoTile(label: "Phone", value: user.phoneNumber, icon: Icons.phone),
                  SizedBox(height: 20,),
                  RoundButton(
                    title: "Logout",
                    onPress: (){
                      FirebaseAuth.instance.signOut();
                      Provider.of<NavigationProvider>(context,listen:  false).reset();
                      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false,);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Reusable Tile Component

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 26),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
