import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../view/auth_view/login_view.dart';
import '../../view/home_view/home_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  /// To check that user session is available in the mobile or not
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body:  Center(child: CircularProgressIndicator()),
            );
          }

          final currentSession = snapshot.hasData? snapshot.data?.session : null ;
          if(currentSession != null){
            return  HomeView();
          }
          else{
            return LoginView();
          }
        },
    );
  }
}
