import 'package:get/get.dart';

import '../controllers/video_screen_controller.dart';

class VideoScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoScreenController>(
      () => VideoScreenController(),
    );
  }
}
