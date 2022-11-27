import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_compressor/app/modules/home/controllers/compression_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var isVideoPicked = false.obs;
  late File SelectedVideo;
  late Subscription _subscription;

  @override
  void onInit() {
    super.onInit();
    print("onInit");

    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      print('progress: $progress');
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    print("onClose");
    _subscription.unsubscribe();
  }

  void videoSelected(File video) {
    final compressionController = Get.put(CompressionController());
    isVideoPicked.value = true;
    this.SelectedVideo = video;
    // compressionController.compressVideo(SelectedVideo);
    update();
  }

  void resetVariables() {
    isVideoPicked.value = false;
    update();
  }
}
