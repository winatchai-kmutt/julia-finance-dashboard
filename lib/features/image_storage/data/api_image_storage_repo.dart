import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:financial_dashboard/features/image_storage/domain/repos/image_storage_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiImageStorageRepo implements ImageStorageRepo {
  Dio dio = Dio();

  String url = "https://upload-image-fastapi-julia-finance.vercel.app/upload";

  @override
  Future<String?> uploadLogoClientImage({
    required String fileName,
    required String folderName,
    required Uint8List bytesImage,
  }) async {
    try {
      return uploadImage(
        fileBytes: bytesImage,
        fileName: fileName,
        folderName: folderName,
      );
    } catch (e) {
      throw Exception("Upload Logo Error: $e");
    }
  }

  Future<String?> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
    required String folderName,
  }) async {
    try {
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) {
        // throw Exception("User is not authenticated");
        return null;
      }

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
        "folder_name": folderName,
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $idToken"}),
      );

      if (response.statusCode == 200) {
        return response.data["image_url"];
      } else {
        return null;
      }
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }
}
