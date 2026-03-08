import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider with ChangeNotifier {
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  File? get imageFile => _imageFile;
  Uint8List? get webImage => _webImage;

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
    if (kIsWeb) {
      _webImage = await pickedFile?.readAsBytes();
      imageFile == null;
    } else {
      _imageFile = File(pickedFile!.path);
      _webImage = null;
    }
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }
}
