import 'dart:io';

import 'package:get/get.dart';
import 'package:video_compressor/app/modules/home/controllers/directory_controller.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController
  final directoryController = Get.put(DirectoryController());
  late final dirPath;

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
    dirPath = _videoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('.mp4'))
        .toList(growable: false);
    print(dirPath);

    return dirPath;
  }
}
