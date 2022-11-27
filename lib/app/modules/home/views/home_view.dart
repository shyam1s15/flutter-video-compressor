import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_compressor/app/modules/home/controllers/compression_controller.dart';
import 'package:video_compressor/app/modules/home/controllers/video_controller.dart';

import '../controllers/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeView extends GetView<HomeController> {
  final ImagePicker _picker = ImagePicker();
  final compressionController = Get.put(CompressionController());
  final videoController = Get.put(VideoController());
  
  final outputFileNameController = TextEditingController();

  // Timer _timer;

  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Compressor'),
        centerTitle: true,
      ),
      body: Center(
          child: ListView(
        children: [
          // if video is selected
          Obx(
            () => controller.isVideoPicked.value
                ? videoSectionWidget()
                // : const SizedBox(height: 200),
                : const SizedBox(height: 200),
          ),

          // when video is selected, show quality picker
          Obx(
            () => controller.isVideoPicked.value
                ? Column(
                  children: [
                    Row(
                        children: [
                          qualitySelectorWidget(),
                          startCompressionWidget(),
                        ],
                      ),
                    const Text("Choose video quality"),
                  ],
                )
                : const SizedBox(height: 100),
          ),

          // while video is compressing show progressbar or hide progress
          Obx(
            () => compressionController.isVideoCompressed.value
                ? const SizedBox()
                : Row(
                    children: [
                      compressionProgressWidget(),
                      cancelCompressionWidget(),
                    ],
                  ),
          )
        ],
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          compressionController.isVideoCompressed.value
              ? previewCompressedFileWidget()
              : const SizedBox(),
          videoPickerWidget(),
        ],
      ),
    );
  }

  void videoPickerGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null && !video.isBlank!) {
      controller.videoSelected(File(video.path));
      videoController.initiallizeVideo(File(video.path));
    } else {
      controller.resetVariables();
      videoController.pauseVideo();
    }
  }

  // floating action button
  Widget videoPickerWidget() {
    return FloatingActionButton.extended(
      onPressed: () => videoPickerGallery(),
      label: const Text('Pick Video'),
      icon: const Icon(Icons.video_library),
      backgroundColor: const Color(0xFFA52A2A),
    );
  }

  // video & it's information
  Widget videoSectionWidget() {
    return Column(
      children: [
        Container(
          child: AspectRatio(
            aspectRatio:
                videoController.videoControllerInstance.value.aspectRatio,
            child: VideoPlayer(videoController.videoControllerInstance),
          ),
        ),
        videoOverlayWidget(),
        VideoProgressIndicator(videoController.videoControllerInstance,
            allowScrubbing: true,
            padding: const EdgeInsets.all(3),
            colors: const VideoProgressColors(
              playedColor: Colors.blue,
            )
            // playedColor: Theme.of(context).primaryColor),
            ),
        videoInfoWidget(),
      ],
    );
  }

  Widget videoInfoWidget() {
    return Text(
        "Orginal video Size: ${(controller.SelectedVideo.lengthSync() / (1024 * 1024)).toStringAsFixed(2)}MB");
  }

  // after info
  Widget qualitySelectorWidget() {
    return Obx(()=>Flexible(
      child: SfSlider(
        min: 0.0,
        max: 100.0,
        stepSize: 5,
        value: compressionController.quality.value,
        interval: 20,
        showTicks: true,
        showLabels: true,
        enableTooltip: true,
        minorTicksPerInterval: 1,
        onChanged: (dynamic value) {
          compressionController.changeQuality(value);
        },
      ),
    ));
  }

  // with quality selector row
  Widget startCompressionWidget() {
    return FloatingActionButton.extended(
      onPressed: () => _getxDialogMenuFileName(),
      label: const Text('start'),
      icon: const Icon(Icons.start),
      backgroundColor: const Color(0xFFA52A2A),
    );
  }


  // show in row of floating action button when compressed
  // it should lit automatically till user clicks it.
  Widget previewCompressedFileWidget() {
    return Container();
  }

  // shown in preview screen
  Widget shareCompressedFileWidget() {
    return Container();
  }

  // after quality selector.
  Widget compressionProgressWidget() {
    return Container();
  }

  // with progress selector
  Widget cancelCompressionWidget() {
    return Container();
  }

  // overlay on video player
  Widget videoOverlayWidget() {
    // Add a play or pause button overlay
    return Container(
      color: Colors.grey.withOpacity(0.5),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(side: BorderSide(color: Colors.white)),
        ),
        child: Obx(() => Icon(
              videoController.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            )),
        onPressed: () {
          videoController.videoControllerInstance.value.isPlaying
              ? videoController.pauseVideo()
              : videoController.startVideo();
        },
      ),
    );
  }

  void _getxDialogMenuFileName() {
    Get.defaultDialog(
        title: 'File Name for compressed object',
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        content: Container(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: outputFileNameController,
                  onSubmitted: (value) {
                    compressionController.startCompression(outputFileNameController.text, controller.SelectedVideo);
                    Get.back();
                  },
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: const InputDecoration(
                    hintText: 'image name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    compressionController.startCompression(outputFileNameController.text, controller.SelectedVideo);
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  )),
            ],
          ),
        ));
  }
}
