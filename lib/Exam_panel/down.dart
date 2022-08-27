import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class download {
  var newPath;
  bool downloading = false;
  String savedPath = "";

  bool isDownloaded = false;

//
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  var _timer;

  Future<bool> saveVideo(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        // if (await _requestPermission(Permission.storage)) {
        if (await _requestPermission(Permission.storage) &&
            // access media location needed for android 10/Q
            await _requestPermission(Permission.accessMediaLocation) &&
            // manage external storage needed for android 11/R
            await _requestPermission(Permission.manageExternalStorage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Aisect";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
          // setState(() {
          //   progress = ((value1 / value2) * 100);
          // });
        });
        // if (Platform.isIOS) {
        //   await ImageGallerySaver.saveFile(saveFile.path,
        //       isReturnPathOfIOS: true);
        // }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile(String url) async {
    try {
      _timer?.cancel();
      // Future.delayed(Duration(seconds: 10));
      await EasyLoading.show(status: 'loading...');

      bool downloaded = await saveVideo(url, "timetable.pdf");
      if (downloaded) {
        print("File Downloaded");
        await EasyLoading.showInfo(
            'Downloaded in /Internal Storage/Aisect folder',
            duration: const Duration(seconds: 3));
        await EasyLoading.dismiss();
      } else {
        await EasyLoading.show(status: 'Error Occured!');
       await EasyLoading.dismiss();
        print("Problem Downloading File");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "s.W. Wrong: $e");
    }
    // setState(() {
    //   loading = false;
    // });
  }
}
