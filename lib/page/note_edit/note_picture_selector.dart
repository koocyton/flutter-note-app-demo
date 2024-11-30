import 'package:flutter/material.dart';
import 'package:onote/service/image_service.dart';
import 'package:onote/util/encrypt_util.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:onote/page/note_edit/note_picture_item.dart';
import 'package:onote/main.dart';

class NotePictureSelector extends StatefulWidget {

  final Function(String)? onSelect;

  final Function(String, String)? onCompress;

  final String compressFileParentDir;

  const NotePictureSelector({
    required this.compressFileParentDir,
    this.onSelect,
    this.onCompress,
    super.key
  });

  @override
  State<NotePictureSelector> createState() => _NotePictureSelectorState();
}

class _NotePictureSelectorState extends State<NotePictureSelector> {

  final List<AssetEntity> imageEntitys = [];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        color:Colors.green.shade50,
        child: GridView.builder(
          physics: ui.physics,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
          ),
          padding: const EdgeInsets.all(8.0), // padding around the grid
          itemCount: imageEntitys.length, // total number of items
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap:() {
                imageEntitys[index].file.then((imageFile){
                  if (imageFile!=null) {
                    // on select
                    if (widget.onSelect!=null) {
                      widget.onSelect!(imageFile.path);
                    }
                    // on compress
                    if (widget.onCompress!=null) {
                      int fileSuffixLastIndexOf = imageFile.path.lastIndexOf(".");
                      String fileSuffix = imageFile.path.substring(fileSuffixLastIndexOf+1).toLowerCase();
                      String comperssImageName = EncryptUtil.md5("${imageFile.path} ${DateTime.now()}");
                      String compressImagePath = "${widget.compressFileParentDir}/$comperssImageName.$fileSuffix";
                      ImageService.compressAndGetFile(imageFile.path, compressImagePath)
                        .then((compressFilePath){
                          int of = compressFilePath.indexOf("/onote-doc/image");
                          widget.onCompress!(compressFilePath, compressFilePath.substring(of + 17));
                        });
                    }
                  }
                });
              },
              child: Container(
                color: Colors.green.shade100,
                child: NotePictureItem(
                  key: ValueKey<int>(index),
                  entity: imageEntitys[index],
                  option: const ThumbnailOption(size: ThumbnailSize.square(200)),
                )
              )
            );
          },
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() {
    return PhotoManager.requestPermissionExtend().then((permission) {
      // get permission
      if (!permission.isAuth) {
        // PhotoManager.openSetting();
        return;
      }
      PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image).then((paths){
        for(AssetPathEntity path in paths) {
          path.getAssetListPaged(
            page: 0,
            size: 100,
          ).then((entitys){
            if (mounted) {
              setState(() {
                imageEntitys.addAll(entitys);
              });
            }
          });
        }
      });
    });
  }
}
