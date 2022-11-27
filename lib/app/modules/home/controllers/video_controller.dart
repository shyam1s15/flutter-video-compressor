import 'dart:io';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  var _videoPlayerController;

  var onTouch = false.obs;
  var isPlaying = false.obs;

  void initiallizeVideo(File videoSource) {
    _videoPlayerController = VideoPlayerController.file(videoSource);
    _videoPlayerController.addListener(() {});
    _videoPlayerController.setLooping(false);
    _videoPlayerController.initialize();
    // _videoPlayerController.play();

    update();
  }

  void pauseVideo() {
    _videoPlayerController.pause();
    isPlaying.value = false;
    update();
  }

  void startVideo(){
    _videoPlayerController.play();
    isPlaying.value = false;
    isPlaying.value = true;

    update();
  }

  VideoPlayerController get videoControllerInstance => _videoPlayerController;
}
