import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';

class CloudinaryServices {

  String cloudName = "da82hhnsz";
  String uploadPreset = "studentProfilePics";

  // Upload Image to cloudinary
   Future<String?> uploadImageToCloudinary(File image)async{
    try{
      String uploadUrl = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'upload_preset': uploadPreset,
      });

      final response = await Dio().post(uploadUrl,data: formData);
      if(response.statusCode == 200){
        // It returns secure_url
        return response.data["secure_url"];
      }
      else{
        if (kDebugMode) {
          print("Upload failed: ${response.statusMessage}");
        }
        return null;
      }
    }
    catch(e){
      if (kDebugMode) {
        print("Cloudinary Upload Error: $e");
      }
      return null;
    }
  }

}