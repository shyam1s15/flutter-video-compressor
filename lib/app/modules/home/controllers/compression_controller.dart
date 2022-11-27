import 'dart:io';

import 'package:get/get.dart';
import 'package:light_compressor/light_compressor.dart';

class CompressionController extends GetxController {
  var isVideoCompressed = false.obs;
  late int _duration;

  var quality = 50.0.obs;

  void changeQuality(double value) {
    quality.value = value;
    print("somerthing");
    update();
  }

  // void startCompression(String outputFileName, File file) async {
  //   final info = await VideoCompress.compressVideo(
  //     file.path,
  //     quality: VideoQuality.MediumQuality,
  //     deleteOrigin: false,
  //     includeAudio: true,
  //   );
  //   print(info!.path);
  // }
  void startCompression(String outputFileName, File file) async {
    Directory dir = Directory("storage/emulated/0/Download");
    final LightCompressor _lightCompressor = LightCompressor();

    final Stopwatch stopwatch = Stopwatch()..start();
    final dynamic response = await _lightCompressor.compressVideo(
        path: file.path,
        destinationPath: dir.path + "/" + outputFileName + ".mp4",
        videoQuality: VideoQuality.very_low,
        isMinBitrateCheckEnabled: false
        );

    stopwatch.stop();
    final Duration duration =
        Duration(milliseconds: stopwatch.elapsedMilliseconds);
    _duration = duration.inSeconds;
    print("duration: " + _duration.toString());
    if (response is OnSuccess) {
      
      print(response.destinationPath);
    } else if (response is OnFailure) {
      
    } else if (response is OnCancelled) {
      
    }
  }
}
