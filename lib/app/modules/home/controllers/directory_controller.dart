import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DirectoryController extends GetxController {
  final userPref = GetStorage();

  String get directoryPath =>
      userPref.read('directory') ?? "Movies/video_compressor";

  bool isDirectoryGiven() {
    return userPref.read('directory') != null;
  }

  String getUserDirectory() {
    final folderName =
        isDirectoryGiven() ? userPref.read('directory') : directoryPath;
    print("folderName: " + folderName);
    return folderName;
  }

  String getFullAppDirectory() {
    final folderName = getUserDirectory();
    final path = Directory("storage/emulated/0/$folderName");
    return path.path;
  }

  void changeUserDirectory(String text) {
    text = "Movies/video_compressor/$text";
    userPref.write("directory", text);
    createFolder();
  }

  void createFolder() async {
    final folderName = getUserDirectory();
    final path = Directory("storage/emulated/0/$folderName");
    print("path: " + path.path);
    if ((await path.exists())) {
    } else {
      path.create(recursive: true);
    }
  }
}
