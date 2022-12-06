import 'dart:io';

import 'package:get/get.dart';
import 'package:video_compressor/app/modules/home/controllers/directory_controller.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController
  final directoryController = Get.put(DirectoryController());
  late List<String> dirPath;

  int get countHistory {
    final _videoDir = Directory(directoryController.getFullAppDirectory());
    dirPath = _videoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4") && !item.split("/").getRange(5, 6).first.contains(".trashed"))
        .toList(growable: false);

    return dirPath.length;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<String> getAllMp4Files() {
    final _videoDir = Directory(directoryController.getFullAppDirectory());
    print(_videoDir.path);
    dirPath = _videoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4") && !item.split("/").getRange(5, 6).first.contains(".trashed"))
        .toList(growable: false);
    return dirPath;
  }
}
