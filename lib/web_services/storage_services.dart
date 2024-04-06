import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  StorageService();

  Future<String> uploadImage({
    required File withFile,
    required String collectionPath,
  }) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': withFile.path},
    );
    final Reference ref = _storage.ref().child(collectionPath);
    final TaskSnapshot taskSnapshot = await ref.putFile(withFile, metadata);
    return await taskSnapshot.ref.getDownloadURL();
  }
}
