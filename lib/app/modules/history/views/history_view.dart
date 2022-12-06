import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:share_extend/share_extend.dart';

import 'package:video_compressor/app/modules/videoScreen/views/video_screen_view.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({Key? key}) : super(key: key);
  final controller = Get.put(HistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('HistoryView'),
          centerTitle: true,
        ),
        body: controller.countHistory > 0
            ? getAllMp4FilesInTile()
            : emptyHistoryWidget());
  }

  ListView getAllMp4FilesInTile() {
    List<String> allFiles = controller.getAllMp4Files();

    return ListView.builder(
      shrinkWrap: true,
      //if file/folder list is grabbed, then show here
      itemCount: allFiles.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(allFiles[index].split('/').getRange(3, 6).join("/")),
          leading: const Icon(Icons.video_file),
          trailing: IconButton(
            onPressed: () {
              // ShareExtend.shareMultiple([XFile(allFiles[index])],
              //     subject: "Compressed Image File");
                    ShareExtend.share(allFiles[index], "file");

            },
            icon: const Icon(
              Icons.share,
              color: Colors.redAccent,
            ),
          ),
          onTap: () {
            // you can add Play/push code over here
            // Get.to(() => VideoScreenView(), arguments: allFiles[index]);
          },
        ));
      },
    );
  }

  Widget emptyHistoryWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'No history',
            ),
            Icon(Icons.cancel_presentation_sharp)
          ],
        ),
      ),
    );
  }
}
