import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload product image to Firebase Storage
  Future<String> uploadProductImage(File imageFile, String shopId) async {
    try {
      final String fileName = '${const Uuid().v4()}.jpg';
      final Reference storageRef =
          _storage.ref().child('products').child(shopId).child(fileName);

      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
