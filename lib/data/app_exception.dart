class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

/// Exceptions for Api's
class FetchDataException extends AppExceptions{

  FetchDataException([String? message]) : super(message, "Error During Communication");
}

class BadRequestException extends AppExceptions{

  BadRequestException([String? message]) : super(message, "Error Invalid Request");
}

class UnauthorisedException extends AppExceptions{

  UnauthorisedException([String? message]) : super(message, "unauthorized Request");
}
class InvalidInputException extends AppExceptions{

  InvalidInputException([String? message]) : super(message, "Invalid Input Request");
}

/// Firebase Exceptions

class FirebaseAuthExceptionHandler extends AppExceptions {
  FirebaseAuthExceptionHandler([String? message]) : super(message, "Authentication Error");
}

class FirestoreExceptionHandler extends AppExceptions {
  FirestoreExceptionHandler([String? message]) : super(message, "Firestore Error");
}

class FirebaseStorageExceptionHandler extends AppExceptions {
  FirebaseStorageExceptionHandler([String? message]) : super(message, "Storage Error");
}

