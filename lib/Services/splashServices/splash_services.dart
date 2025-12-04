/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../utils/routes/routes_name.dart';
import '../../viewModel/user_view_model.dart';

class SplashServices {

  Future<UserModel?> getUserData() => UserViewModel().getUser();

  Future<void> checkAuthentication(BuildContext context)async{

    UserViewModel().getUser().then((value) async{
      if (kDebugMode) {
        print("the value of the token is${value!.token}");
      }
      if(value!.token.toString() == '' || value.token == "null")
      {
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (Route<dynamic> route) => false);
      }
      else{
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.home,(Route<dynamic> route) => false);

      }
    },).onError((error, stackTrace) {
      if (kDebugMode) {
        print("The Error in the Splash Service is ${error.toString()}");
      }
    },);
  }
}*/
