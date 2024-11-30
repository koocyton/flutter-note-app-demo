import 'dart:io';
import 'package:onote/main.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:onote/object/run_execption.dart';
import 'package:onote/widget/easy_toast.dart';

class ImageService {

  static Future<FileSystemEntity> cleanLocalAllImage() {
    Directory imagesDir = Directory("${ui.applicationDir}/onote-doc/image");
    return imagesDir.delete(recursive:true);
  }

  static Future<String> compressAndGetFile(String imagePath, String targetPath) async {
    File targetFile = File("${ui.applicationDir}/onote-doc/image/$targetPath");
    if (!targetFile.parent.existsSync()) {
      targetFile.parent.createSync(recursive: true);
    }
    return FlutterImageCompress.compressAndGetFile(
      imagePath, targetFile.path, quality: 30, rotate: 0,
    )
    .then((xfire){
      if (xfire==null) {
        EasyToast.showBottomToast("comperss image error");
        throw RunException("50000", "comperss image error");
      }
      // logger.t("${File(imagePath).lengthSync()} ${File(result.path).lengthSync()}");
      return xfire.path;
    });
  }

}