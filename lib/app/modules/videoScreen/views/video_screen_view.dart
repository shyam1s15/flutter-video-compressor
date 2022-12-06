import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/video_screen_controller.dart';

class VideoScreenView extends GetView<VideoScreenController> {

  VideoScreenView({Key? key}) : super(key: key);
  final controller = Get.put(VideoScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoScreenView'),
        centerTitle: true,
      ),
      body: AspectRatio(
            aspectRatio:
                controller.videoControllerInstance.value.aspectRatio,
            child: VideoPlayer(controller.videoControllerInstance),
      ),
    );
  }
}
