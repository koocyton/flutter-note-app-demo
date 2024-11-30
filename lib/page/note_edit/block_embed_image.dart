import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:logger/logger.dart';
import 'package:onote/main.dart';
import 'package:onote/service/api_request_service.dart';
import 'package:onote/service/note_service.dart';
import 'package:shimmer/shimmer.dart';

class BlockEmbedImage extends q.CustomBlockEmbed {

  const BlockEmbedImage(String value) : super(noteType, value);

  static const String noteType = 'image';

  static BlockEmbedImage fromJson(Map<String, dynamic> json) {
    return BlockEmbedImage(json['source'] as String);
  }
}

class EmbedImageWidget extends StatefulWidget{

  final String imageUri;

  const EmbedImageWidget({required this.imageUri, super.key});

  @override
  State<EmbedImageWidget> createState() => EmbedImageWidgetState();
}

class EmbedImageWidgetState extends State<EmbedImageWidget> {

  String? imagePath;

  static final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return (imagePath==null)
        ? Shimmer.fromColors(
            baseColor: Colors.black26,
            highlightColor: Colors.black45,
            child: Icon(
              Icons.image_outlined,
              size: ui.windowWidth/2
            ),
          )
        : Container (
          padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
          child: Image.file(File(imagePath!))
    ); 
  }

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {
    // 文件路径
    String imgPath = "${ui.applicationDir}/onote-doc/image/${widget.imageUri}";
    // 如果还没有上传过
    if (!NoteService.uploadedImagePathRegExp.hasMatch(widget.imageUri)) {
      setState((){
        imagePath = imgPath;
      });
      return;
    }
    // 判断文件是否存在
    File imgFile = File(imgPath);
    if (imgFile.existsSync()) {
      setState((){
        imagePath = imgPath;
      });
      return;
    }
    // 没有就先下载文件
    ApiRequestService.downloadImage(widget.imageUri).then((imageUrl){
      if (imageUrl!=null) {
        setState((){
          imagePath = imgPath;
        });
      }
    });
  }
}

class EmbedImageBuilder extends q.EmbedBuilder{

  EmbedImageBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, q.Document document) addEditNote;

  @override
  String get key => 'image';

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context, q.QuillController controller, q.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    return EmbedImageWidget(imageUri: node.value.data.toString());
  }
}