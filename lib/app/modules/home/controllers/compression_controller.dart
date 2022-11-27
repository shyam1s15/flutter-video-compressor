import 'dart:io';

import 'package:get/get.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:video_compressor/app/modules/home/controllers/directory_controller.dart';

class CompressionController extends GetxController {
  var isVideoCompressed = false.obs;
  late int _duration;

  var quality = 40.0.obs;

  final directoryController = Get.put(DirectoryController());

  void changeQuality(double value) {
    quality.value = value;
    print("somerthing");
    update();
  }

  Future<List> startCompression(String outputFileName, File file) async {
    VideoQuality videoQuality = _getVideoQuality();
    int frameRate = _getFrameRate(videoQuality);
    final LightCompressor _lightCompressor = LightCompressor();
    outputFileName = uniqueOutputFileName(outputFileName);
    final Stopwatch stopwatch = Stopwatch()..start();
    final dynamic response = await _lightCompressor.compressVideo(
      path: file.path,
      destinationPath: outputFileName,
      videoQuality: videoQuality,
      frameRate: frameRate,
      isMinBitrateCheckEnabled: false,
    );

    stopwatch.stop();
    final Duration duration =
        Duration(milliseconds: stopwatch.elapsedMilliseconds);
    _duration = duration.inSeconds;

    if (response is OnSuccess) {
      return [duration, response.destinationPath];
    } else if (response is OnFailure) {
      return [-1];
    } else if (response is OnCancelled) {}
    return [-1];
  }

  String uniqueOutputFileName(String outputFileName) {
    String dir = directoryController.getFullAppDirectory();

    int trial = 1;
    String path = "$dir/$outputFileName.mp4";
    while (true) {
      if (File(path).existsSync()) {
        path = "$dir/$outputFileName($trial).mp4";
        trial++;
      } else {
        return path;
      }
    }
  }

  VideoQuality _getVideoQuality() {
    if (quality <= 20) {
      return VideoQuality.very_low;
    } else if (quality <= 40) {
      return VideoQuality.low;
    } else if (quality <= 60) {
      return VideoQuality.medium;
    } else if (quality <= 80) {
      return VideoQuality.high;
    } else {
      return VideoQuality.very_high;
    }
  }

  int _getFrameRate(VideoQuality videoQuality) {
    if (videoQuality == VideoQuality.very_low) {
      return 10;
    } else if (videoQuality == VideoQuality.low) {
      return 15;
    } else if (videoQuality == VideoQuality.medium) {
      return 20;
    } else if (videoQuality == VideoQuality.high) {
      return 30;
    } else {
      return 40;
    }
  }
}
