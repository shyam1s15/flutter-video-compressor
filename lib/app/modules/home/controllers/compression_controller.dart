import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:get/get.dart';
import 'package:video_compressor/app/modules/home/controllers/directory_controller.dart';

class CompressionController extends GetxController {
  var isVideoCompressed = false.obs;
  var isVideoinCompression = false.obs;
  String outputFileName = "";
  var quality = 40.0.obs;
  final directoryController = Get.put(DirectoryController());

  void changeQuality(double value) {
    quality.value = value;
    print("somerthing");
    update();
  }

  // Future<List> startCompression(String outputFileName, File file) async {
  //   VideoQuality videoQuality = _getVideoQuality();
  //   int frameRate = _getFrameRate(videoQuality);
  //   final LightCompressor _lightCompressor = LightCompressor();
  //   outputFileName = uniqueOutputFileName(outputFileName);
  //   final Stopwatch stopwatch = Stopwatch()..start();
  //   final dynamic response = await _lightCompressor.compressVideo(
  //     path: file.path,
  //     destinationPath: outputFileName,
  //     videoQuality: videoQuality,
  //     // frameRate: frameRate,
  //     isMinBitrateCheckEnabled: true,
  //   );

  //   stopwatch.stop();
  //   final Duration duration =
  //       Duration(milliseconds: stopwatch.elapsedMilliseconds);
  //   _duration = duration.inSeconds;

  //   if (response is OnSuccess) {
  //     return [duration, response.destinationPath];
  //   } else if (response is OnFailure) {
  //     return [-1];
  //   } else if (response is OnCancelled) {}
  //   return [-1];
  // }

  void startCompression(String outputFileName, File file) async {
    isVideoinCompression.value = true;

    final Stopwatch stopwatch = Stopwatch()..start();
    outputFileName = uniqueOutputFileName(outputFileName);
    this.outputFileName = outputFileName;
    final bitrate = (100 - quality.value) ~/ 2;
    // FFmpegKit.execute('-i ${file.path} -c:v mpeg4 $outputFileName')
    FFmpegKit.execute(
            '-i ${file.path} -vcodec libx264 -crf $bitrate -preset faster -tune film $outputFileName')
            // '-i ${file.path} -vcodec libx264 -crf $bitrate -preset faster -tune film $outputFileName')
        // FFmpegKit.execute('-i ${file.path} -s 480x320 -acodec mp2 -strict -2 -ac 1 -ar 16000 -r 13 -ab 32000 -aspect 3:2 $outputFileName')
        // FFmpegKit.execute('-i ${file.path} -s 1280x720 -acodec copy -y $outputFileName')
        .then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        isVideoCompressed.value = true;
        isVideoinCompression.value = false;
        // SUCCESS
        print("Success");
        // return [0, "something"];
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
        print("cancelled");
        return [-1];
      } else {
        // ERROR
        isVideoCompressed.value = false;
        isVideoinCompression.value = false;

        print("error");
        // return [-1];
      }
    });
    update();

    // return [-1];
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

  void cancelCompression() {
    FFmpegKit.cancel();
    isVideoinCompression.value = false;
    isVideoCompressed.value = false;
    update();
  }
}
