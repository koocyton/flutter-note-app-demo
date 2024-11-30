import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class EasyLaunch {

  static void launchURI(String? url) {
    if (url==null) {
      return;
    }
    if (url.startsWith("/")) {
      Get.toNamed(url);
      return;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
  }

  static void launchApp(String? url) {
    if (url==null) {
      return;
    }
    if (url.startsWith("/")) {
      Get.toNamed(url);
      return;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static void trackLaunchApp(String? url) {
    launchApp(url);
  } 
}