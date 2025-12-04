import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  Future<String> fetchProfileImage() async {
    // Mocked API (replace with Firebase later)
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos/1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to load profile image');
    }
  }

  Future<String> fetchUsername() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Demo User";
  }
}
