import 'dart:typed_data';

abstract class ImageStorageRepo {
  // Uploaded image then get URL
  Future<String?> uploadLogoClientImage({
    required String fileName,
    required String folderName,
    required Uint8List bytesImage,
  });
}
