abstract class BaseApiServices {
  Future<dynamic> getApiResponse(String url);
  Future<dynamic> postApiResponse(String url, dynamic data);
  // We will Add Them later
  // Future<dynamic> getPutApiResponse(String url,dynamic data);
  // Future<dynamic> getDeleteApiResponse(String url,dynamic data);
  // Future<dynamic> registerWithFirebase(String email, String password);
  // Future<dynamic> loginWithFirebase(String email, String password);
  // Future<dynamic> getDocument(String collection, String docId);
  // Future<dynamic> addDocument(String collection,Map<String,dynamic> data);
  // Currently don't understanding this
  // Future<dynamic> getFirebaseResponse(String collection);
  // Future<dynamic> postFirebaseResponse(String collection);
}
