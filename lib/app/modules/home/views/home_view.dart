import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_compressor/app/modules/home/controllers/compression_controller.dart';
import 'package:video_compressor/app/modules/home/controllers/video_controller.dart';

import 'package:share_plus/share_plus.dart';

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
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 0:
                  _historyScreen();
                  break;
                case 1:
                  _chooseFolderName();
                  break;
                case 3:
                  _aboutUs();
                  break;
                default:
                  throw UnimplementedError();
              }
            },
            icon: const Icon(
                Icons.menu), //don't specify icon if you want 3 dot menu
            color: Colors.blue,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                onTap: () {},
                value: 0,
                child: const Text(
                  "History",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem<int>(          
                value: 1,
                child: const Text(
                  "Folder Name",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem<int>(
                onTap: () => controller.toggleDarkMode(),
                value: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Toggle Theme",
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        controller.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text(
                  "About us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
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
                  && !compressionController.isVideoinCompression.value 
                    && !compressionController.isVideoCompressed.value
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
                : const SizedBox(),
          ),

          // while video is compressing show progressbar or hide progress
          Obx(
            () => compressionController.isVideoinCompression.value 
            && compressionController.isVideoinCompression.value
                ? Column(
                    children: [
                      Row(
                        children: [
                          compressionProgressWidget(),
                        ],
                      ),
                      cancelCompressionWidget(),
                    ],
                  )
                : const SizedBox(),
          )
        ],
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => 
          compressionController.isVideoCompressed.value
              ? shareCompressedFileWidget()
              : const SizedBox()),
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
    return Obx(() => Flexible(
          child: SfSlider(
            min: 0.0,
            max: 100.0,
            stepSize: 20,
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
  Widget shareCompressedFileWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: FloatingActionButton.extended(
        onPressed: () => _sharePickedFile(),
        label: const Text('share'),
        icon: const Icon(Icons.done_all),
        backgroundColor: Color.fromARGB(255, 42, 165, 67),
      ),
    );
  }


  // after quality selector.
  Widget compressionProgressWidget() {
    return Flexible(
      child: ListTile(
        leading: const CircularProgressIndicator(
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation(Colors.red),
          strokeWidth: 10,
        ),
        title: Column(
          children: const [
            Text(
              "Hold on, while we compress your file.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "app will work in background.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      
      ),
    );
  }

  // with progress selector
  Widget cancelCompressionWidget() {
    return Column(
      children: [
        FloatingActionButton.extended(
          onPressed: () => _getxDialogMenuFileName(),
          label: const Text('Cancel'),
          icon: const Icon(Icons.cancel),
          backgroundColor: const Color(0xFFA52A2A),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("stop compression??"),
        ),
      ],
    );
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
                    _startCompressionAndDisplayResultToast(
                        outputFileNameController.text,
                        controller.SelectedVideo);
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
                    compressionController.startCompression(
                        outputFileNameController.text,
                        controller.SelectedVideo);
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

  void _startCompressionAndDisplayResultToast(
      String text, File selectedVideo) async {
    compressionController.startCompression(
        outputFileNameController.text, controller.SelectedVideo);

    // if (result.first == -1) {
    //   print("Errors");
    //   Get.snackbar("Compression result", "Compression failed");
    // } else {
      // print("success");
      // Get.snackbar("Compression Successful file location", result.last);
    // }
  }
  
  void _sharePickedFile() {
      Share.shareXFiles([XFile(compressionController.outputFileName)],
          subject: "Compressed Image File");
  }
  
  void _historyScreen() {}
  
  void _chooseFolderName() {}
  
  void _aboutUs() {}
}
