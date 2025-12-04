
import '../model/user_model.dart';

class UserService {
  // 🔹 Mock Data for now
  Future<UserModel> getUserMock() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      name: "Abdullah Baloch",
      email: "abdullah@example.com",
      rollNumber: "153-CS",
      faculty: "Computer Science",
      phoneNumber: "0300-1234567",
    );
  }

// 🔹 Firebase version (future use)
// Future<UserModel> getUserFromFirebase(String uid) async {
//   DocumentSnapshot snap = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .get();
//
//   Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
//
//   return UserModel(
//     name: data['name'],
//     email: data['email'],
//     rollNumber: data['rollNumber'],
//     faculty: data['faculty'],
//     phoneNumber: data['phoneNumber'],
//   );
// }
}
