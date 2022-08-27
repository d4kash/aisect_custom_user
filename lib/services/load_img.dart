import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class LoadImage extends ChangeNotifier {
  static ImagePicker image = ImagePicker();
  static File? file;

  static getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    file = File(img!.path);
    // notifyListeners();
  }
}
