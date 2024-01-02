import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videoplayer/screens/HomeScreen/VideoListScreen.dart';
import 'package:videoplayer/utils/ColorConstants.dart';

import '../../utils/ThemedWidgets.dart';
import '../../utils/methods.dart';
import 'model/FolderModel.dart';
import 'model/VideoDataModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> supportVideoExtension = [
    ".mov",
    ".mp4",
    ".wmv",
    ".webm",
    ".avi",
    ".mkv",
    ".mts",
    ".avchd",
  ];
  List<VideoDataModel> listVideos = [];
  List<FolderModel> folderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (status.isDenied) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      await getAllVideos();
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "We need permission to fetch video from storage! PLease grant us the permission without permission we can not fetch the videos.")));
    }
  }

  getAllVideos() async {
    Directory? directory = Directory("/storage/emulated/0/");
    List<FileSystemEntity> allVideoFiles = [];
    if (directory != null) {
      print("directory :${directory.path}");
      List<FileSystemEntity> directories = await directory
          .list()
          .where(
              (entity) => !entity.path.contains("/storage/emulated/0/Android"))
          .toList();
      print("directories : ${directories.length}");
      for (int i = 0; i < directories.length; i++) {
        if (directories[i] is Directory) {
          List<FileSystemEntity> files = await Directory(directories[i].path)
              .list(recursive: true, followLinks: false)
              .where((entity) =>
                  !entity.path.contains("/storage/emulated/0/Android")
                      ? supportVideoExtension
                          .any((element) => entity.path.endsWith(element))
                      : false)
              .toList();
          setState(() {
            allVideoFiles.addAll(files);
          });
        }
      }
      // print("_files.length : ${allVideoFiles}");
      setUpAllVideoFiles(allVideoFiles);
    }
  }

  setUpAllVideoFiles(List<FileSystemEntity> dataList) async {
    for (FileSystemEntity model in dataList) {
      folderList.firstWhere(
        (element) {
          if (element.path == model.parent.path) {
            element.videoList.add(
              VideoDataModel(
                file: File(model.path),
                parentPath: model.parent.path,
                path: model.path,
              ),
            );
            return true;
          } else {
            return false;
          }
        },
        orElse: () {
          folderList.add(FolderModel(
              path: model.parent.path,
              folderName: model.parent.path.split("/").last,
              videoList: []));
          return folderList.last;
        },
      );

      // listVideos.add(
      //   VideoDataModel(
      //     file: File(model.path),
      //     parentPath: model.parent.path,
      //     path: model.path,
      //   ),
      // );
      // listVideos.last.controller.initialize();
    }
    folderList.sort(
      (a, b) {
        return a.folderName.compareTo(b.folderName);
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: ThemedText(
          text: "Video PLayer",
          color: colorWhite,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              primary: true,
              itemCount: folderList.length,
              itemBuilder: (context, index) {
                FolderModel model = folderList[index];
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoListScreen(
                            folderModel: model,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 0, left: 10, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Icon(
                                Icons.folder,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ThemedText(
                                  text: model.folderName,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  // maxLine: 2,
                                ),
                                ThemedText(
                                  text:
                                      "${model.videoList.length} ${model.videoList.length > 1 ? "Videos" : "Video"}",
                                  color: Colors.blueGrey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  // maxLine: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/*
*
* ListTile(
                    contentPadding: EdgeInsets.all(5),
                    horizontalTitleGap: 8,
                    minVerticalPadding: 0,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 70,
                            width: 80,
                            // color: Colors.grey.shade300,
                            child: Center(
                              child: Icon(
                                Icons.folder,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: ThemedText(
                      text: model.folderName,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      // maxLine: 2,
                    ),
                    subtitle: ThemedText(
                      text:
                          "${model.videoList.length} ${model.videoList.length > 1 ? "Videos" : "Video"}",
                      color: Colors.blueGrey.shade800,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      // maxLine: 2,
                    ),
                  )
*
* */
