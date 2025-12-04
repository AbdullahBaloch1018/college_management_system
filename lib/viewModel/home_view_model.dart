import 'dart:async';
import 'package:flutter/foundation.dart';

import '../Services/home_service.dart';

class HomeViewModel with ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _username;
  String? get username => _username;

  String? _profileImage;
  String? get profileImage => _profileImage;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _username = await _homeService.fetchUsername();
      _profileImage = await _homeService.fetchProfileImage();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching home data: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
