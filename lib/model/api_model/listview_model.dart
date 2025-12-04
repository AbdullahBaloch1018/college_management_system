import 'dart:convert';
// is an api model provided by the jsonPlaceholder
/// It is a model which is used by the notification_screen
List<SamplePosts> samplePostsFromJson(String str) => List<SamplePosts>.from(json.decode(str).map((x) => SamplePosts.fromJson(x)));

String samplePostsToJson(List<SamplePosts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SamplePosts {
  int id;
  String name;
  String username;
  String email;


  SamplePosts({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory SamplePosts.fromJson(Map<String, dynamic> json) => SamplePosts(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,

  };
}