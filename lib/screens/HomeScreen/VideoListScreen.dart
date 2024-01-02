import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/screens/HomeScreen/model/FolderModel.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/ThemedWidgets.dart';
import '../../utils/methods.dart';
import 'model/VideoDataModel.dart';

class VideoListScreen extends StatefulWidget {
  final FolderModel folderModel;

  const VideoListScreen({Key? key, required this.folderModel})
      : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    initVideos();
    super.initState();
  }

  initVideos() async {
    for (VideoDataModel model in widget.folderModel.videoList) {
      model.controller = VideoPlayerController.file(model.file);
      model.controller!.initialize().then(
            (value) => setState(() {}),
          );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: ThemedText(
          text: widget.folderModel.folderName,
          color: colorWhite,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          maxLine: 1,
        ),
      ),
      body: ListView.builder(
        primary: true,
        itemCount: widget.folderModel.videoList.length,
        itemBuilder: (context, index) {
          VideoDataModel model = widget.folderModel.videoList[index];
          return Container(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 2, left: 10, right: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(5),
              horizontalTitleGap: 8,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 90,
                          color: Colors.grey.shade300,
                          child: model.controller != null &&
                                  model.controller!.value.isInitialized
                              ? VideoPlayer(model.controller!)
                              : Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                        ),
                        if (model.controller != null)
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: Text(
                              durationToString(
                                  model.controller!.value.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              title: Text(
                model.path
                    .split("/")
                    .last
                    .replaceAll(".${model.path.split(".").last}", ""),
              ),
              trailing: SizedBox(
                width: 30,
                child: IconButton(
                  iconSize: 18,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (VideoDataModel model in widget.folderModel.videoList) {
      if (model.controller != null) {
        model.controller!.dispose();
      }
    }
    super.dispose();
  }
}
