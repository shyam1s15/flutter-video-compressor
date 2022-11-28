import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
        body: getAllMp4FilesInTile());
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
          leading: const Icon(Icons.audiotrack),
          trailing: const Icon(
            Icons.play_arrow,
            color: Colors.redAccent,
          ),
          onTap: () {
            // you can add Play/push code over here
          },
        ));
      },
    );
  }
}
