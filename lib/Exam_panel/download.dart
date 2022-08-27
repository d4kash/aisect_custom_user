import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Download extends StatefulWidget {
  Download({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  _DownloadState createState() => _DownloadState(link);
}

class _DownloadState extends State<Download> {
  var urifromWidget = "";
  var pathtoSave;
  _DownloadState(String link);
  @override
  void initState() {
    super.initState();

    urifromWidget = widget.link; //here var is call and set to
  }

  var newPath;
  bool downloading = false;
  String savedPath = "";

  bool isDownloaded = false;

  //
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

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
          setState(() {
            progress = ((value1 / value2) * 100);
          });
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

  Future<bool> _requestPermission(Permission permission) async {
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

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveVideo(urifromWidget, "timetable.pdf");
    if (downloaded) {
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build running');

    return Scaffold(
      appBar: AppBar(
        title: Text("Download"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$progress%'),
              isDownloaded
                  ? Text(
                      'File Downloaded! You can see your file in the application\'s directory',
                    )
                  : Text(
                      'Click the FloatingActionButton to start Downloading!$urifromWidget'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () async {
            downloadFile();
            // String filepath12 = await getname();
            // saveFile(filepath12, context);
          }),
    );
  }
}
