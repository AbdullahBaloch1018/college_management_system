import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider with ChangeNotifier{
  File? _imageFile ;
  final ImagePicker _picker = ImagePicker();

  File? get imageFile => _imageFile;

  Future<void> pickImage(ImageSource source)async{
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if(pickedFile != null){
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
  void clearImage(){
    _imageFile = null;
    notifyListeners();
  }
}