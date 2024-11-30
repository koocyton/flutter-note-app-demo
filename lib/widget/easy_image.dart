import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EasyImage {

  static void imageEvictFromCache(String url) {
      CachedNetworkImage.evictFromCache(url);
  }

  static Widget image (String uri, {int? expireMinutes, Color? backgroundColor, String? cacheKey, double? radius, Color? color, BlendMode? colorBlendMode, BoxFit fit=BoxFit.cover, double? width, double? height, Widget? errorWidget, Function? onloaded}) {
    if (uri.startsWith("assets/")) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius??0)),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color:backgroundColor??Colors.transparent,
          child:Image.asset(uri, fit: fit, width:width, height:height)
        )
      );
    }
    else if (uri.startsWith("/")) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius??0)),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color:Colors.black,
          child: Image.file(File(uri), fit: fit, width:width, height:height)
        )
      );
    }
    else if (uri.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius??0)),
        child: Container(
          width: width,
          height: height,
          color:Colors.black,
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: uri,
            cacheKey: cacheKey,
            // placeholder: (context, url) => const CircularProgressIndicator(),
            // errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: fit,
            progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress downloadProgress) {
              double? value = downloadProgress.progress;
              if (value!=1) {
                return // Shimmer.fromColors(
                  // baseColor: Colors.white24,
                  // highlightColor: Colors.white70,
                  // child: 
                  Icon(
                    Icons.panorama_outlined,
                    size: width,
                    color: Colors.white24
                  );
                //);
              }
              return Container();
            },
            errorWidget: (buildContext, str, dyn){
              if (errorWidget!=null) {
                return errorWidget;
              }
              return Container();
            }
          )
        )
      );
    }
    return Container(
      color:Colors.black12,
      width: width,
      height: height,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.black54,)
      // child: Text(uri.substring(0, 1), style: TextStyle(fontSize: height!/2, color: color, fontWeight: FontWeight.bold)),
    );
  }

}