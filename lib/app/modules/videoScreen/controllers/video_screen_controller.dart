import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
  //TODO: Implement VideoScreenController

  dynamic argumentData = Get.arguments;
  var _videoPlayerController;
  

  @override
  void onInit() {
    super.onInit();
    _videoPlayerController = VideoPlayerController.file(argumentData[0]);
    _videoPlayerController.addListener(() {});
    _videoPlayerController.setLooping(false);
    _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  VideoPlayerController get videoControllerInstance => _videoPlayerController;


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
