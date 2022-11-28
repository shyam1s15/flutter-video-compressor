import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_compressor/app/modules/home/controllers/compression_controller.dart';
import 'package:video_compressor/app/modules/home/controllers/directory_controller.dart';
import 'package:video_compressor/app/modules/home/controllers/video_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var isVideoPicked = false.obs;
  late File SelectedVideo;
  late Subscription _subscription;

  bool isDarkMode = false;

  @override
  void onInit() {
    super.onInit();
    final dirController = Get.put(DirectoryController());
    dirController.createFolder();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void videoSelected(File video) {
    resetVariables();
    final compressionController = Get.put(CompressionController());
    isVideoPicked.value = false;
    isVideoPicked.value = true;
    this.SelectedVideo = video;
    // compressionController.compressVideo(SelectedVideo);
    update();
  }

  void resetVariables() {
    isVideoPicked.value = false;
    final compressionController = Get.put(CompressionController());
    final videoController = Get.put(VideoController());

    compressionController.isVideoCompressed.value = false;
    compressionController.isVideoinCompression.value = false;
    videoController.isPlaying.value = false;
    videoController.onTouch.value = false;
  }

  toggleDarkMode() {}
}
