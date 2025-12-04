/*
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserViewModel with ChangeNotifier{

  String? _token ;
  String? get token => _token;

  bool get isLoggedIn => token != null;

  Future<bool> saveUser(UserModel user)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", user.token.toString());
    notifyListeners();
    return true;
  }
  Future<UserModel?> getUser()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? token = pref.getString("token");
    // if (token == null) {
    //   return null; // no user stored
    // }
    return UserModel(
      token: token,
    );
  }
  Future<bool> removeUser()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("token");
    notifyListeners();
    return true;
  }

}*/
