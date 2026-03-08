import '../model/user_model.dart';
// It is using in Profile View of the Student
class UserService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Mock Data for now
  Future<UserModel> getUserMock() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      uid: "219021lksdflk",
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
/*
Future<UserModel> getUserDetail() async{
  try{
    User? currentUser = await _auth.currentUser;
    DocumentSnapshot doc = await _firestore.collection("students_database").doc(currentUser!.uid).get();
  }catch(e){

  }
}*/
}
