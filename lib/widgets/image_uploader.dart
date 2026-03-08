import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewModel/image_upload_provider.dart';

class ImageUploader extends StatelessWidget {
  const ImageUploader({super.key});

  void _showImageSourceDialog(
      BuildContext context,
      ImageUploadProvider provider,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                provider.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                provider.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageUploadProvider>(
      builder: (context, provider, child) {
        return Center(
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(context, provider),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],

              // ✅ FIX: Web + Mobile image handling
              backgroundImage: kIsWeb
                  ? (provider.webImage != null
                  ? MemoryImage(provider.webImage!)
                  : null)
                  : (provider.imageFile != null
                  ? FileImage(provider.imageFile!)
                  : null) as ImageProvider?,

              child: (kIsWeb
                  ? provider.webImage == null
                  : provider.imageFile == null)
                  ? const Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.white70,
              )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
