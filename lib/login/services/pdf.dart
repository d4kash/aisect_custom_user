import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> loadAndLaunchPdf(List<int> bytes, String filename) async {
    // Directory root = await getTemporaryDirectory(); // this is using path_provider
    // String directoryPath = root.path + '/Aiset';
    // await Directory(directoryPath).create(recursive: true);
  
  
  final path = (await getExternalStorageDirectory())!.path;
  final file = File("$path/$filename");
  await file.writeAsBytes(bytes, flush: false);
  OpenFile.open('$path/$filename');
}


