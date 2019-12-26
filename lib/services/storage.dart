import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: "gs://soundshare-3dee3.appspot.com");

  /// Starts an upload task and saves it to specified path
  StorageUploadTask upload(
      File file,
      String path,
      {bool includeTimestamp = false, String concatString = "_", String ext = "mp3", StorageMetadata metadata}) {
    /// Set image name on cloudfirestore
    String filePath = '$path${includeTimestamp ? "$concatString${DateTime.now()}" : ""}.$ext';
    print(filePath);
    return _storage.ref().child(filePath).putFile(file, metadata);
  }

}

final StorageService storageService = StorageService();
