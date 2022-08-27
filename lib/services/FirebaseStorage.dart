import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyFirebaseStorage {
  static Future<String> upload(String destination, File file) async {
    try {
      // final ref = FirebaseStorage.instance.ref(destination);
      // return ref.putFile(file);
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(destination);

      uploadTask = ref.putFile(file);
      // firebase_storage.TaskSnapshot taskSnapshot =
      //     await uploadTask.whenComplete(() => {});
      String imgUrl1 = await (await uploadTask).ref.getDownloadURL();
      print(imgUrl1);
      return imgUrl1;
    } on Exception catch (e) {
      print("error occured $e");
      return "Error $e";
    }
  }

  static Future<firebase_storage.UploadTask?> uploadPdf(
      String destination, File file) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on Exception catch (e) {
      print("error occured $e");
      return null;
    }
  }

  // static Future<firebase_storage.UploadTask?> cancleUpload() {
  //   try {
  //     firebase_storage.Reference ref =
  //         firebase_storage.FirebaseStorage.instance.ref(destination);

  //     return ref.putFile(file);
  //   } on Exception catch (e) {
  //     print("error occured $e");
  //     return null;
  //   }
  // }
}
