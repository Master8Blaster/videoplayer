import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoDataModel {
  File file;
  String path;
  String parentPath;
  int sizeInMb = 0;
  String sizeInString = "";
  VideoPlayerController? controller;

  VideoDataModel({
    required this.file,
    required this.path,
    required this.parentPath,
    this.controller,
  }) {
    sizeInMb = 00;
    sizeInString = "";
  }
}
