import 'dart:io';

import 'package:dio/dio.dart';
import 'package:onote/util/cache_util.dart';
import 'package:logger/logger.dart';
import 'package:onote/util/encrypt_util.dart';
import 'package:path_provider/path_provider.dart';

class HttpUtil {

  static Logger logger = Logger();

  // static final Future<String?> currentLocaleFuture = Devicelocale.currentLocale;

  static final Map<String, String> defaultHeaderMap = {
    'Accept':'text/html,application/json,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'Accept-Encoding':'gzip, deflate, br',
    // 'Accept-Language': "Http:AcceptLanguage".tr,
    'Cache-Control':'max-age=0',
    // 'Connection':'keep-alive',
    // 'sec-ch-ua':'".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
    // 'sec-ch-ua-mobile':'?0',
    // 'sec-ch-ua-platform':'"Windows"',
    // 'Sec-Fetch-Dest':'document',
    // 'Sec-Fetch-Mode':'navigate',
    // 'Sec-Fetch-Site':'none',
    // 'Sec-Fetch-User':'?1',
    // 'Upgrade-Insecure-Requests':'1',
    // 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
  };

  static Dio? _dioInstance;

  static Dio getDioInstance() {
    _dioInstance ??= Dio()
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            // logger.d("request url : ${options.uri}"
            //    "\n request header : ${options.headers}"
            //    "\n request body : ${options.data}"
            // );
            return handler.next(options);
          }, 
          onResponse: (response, handler) {
            // logger.d("onResponse(${response.statusCode}) : ${response.data}");
            handler.next(response);
          }, 
          onError: (e, handler) {
            // logger.d("onError response(${e.response!.statusCode}) : ${e.response!.data}");
            return handler.next(e);
          })
        );
    // (_dioInstance!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
    //   HttpClient()
    //     ..badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    return _dioInstance!;
  }

  static Future<String?> stringFormPost(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headers, String? data}) async {
    String? str;
    if (cacheKey!=null) {
      String? str = CacheUtil.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null && str.isNotEmpty) {
        return str;
      }
    }
    return formPost(url, headers: headers, data: data).then((response){
      str = response.toString();
      if (cacheKey!=null && str!=null && str!.length>=10) {
        CacheUtil.set(cacheKey, str!);
      }
      return str;
    });
  }

  static Future<Response<T>> formPost<T>(String url, {Map<String, String>? headers, String? data}) {
    headers ??= {};
    headers["content-type"] = "application/x-www-form-urlencoded; charset=UTF-8";
    return getDioInstance().post<T>(url,
      data: data,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status!=null && status < 500; 
        },
        headers: buildHeaders(headers),
      ),
    );
  }

  static Future<ResponseBody?> dataGetDownload(String url, String savePath, {Map<String, String>? headers}) async {
    headers ??= {};
    try {
      return await (getDioInstance().download(
        url,
        savePath,
        options: Options(
          headers: buildHeaders(headers),
        ),
      ))
      .then((response){
        return response.data;
      });
    }
    catch(e) {
      // log.info(e);
      return Future.value(null);
    }
  }

  static Future<String?> stringGet(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headers}) async {
    String? str;
    if (cacheKey!=null) {
      str = CacheUtil.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null) {
        return str;
      }
    }
    headers ??= {};
    try {
      return await (getDioInstance().get(url,
        options: Options(
          headers: buildHeaders(headers),
        ),
      ))
      .then((response){
        str = response.toString();
        if (cacheKey!=null && str!=null) {
          CacheUtil.set(cacheKey, str!);
        }
        return str;
      });
    }
    catch(e) {
      // log.info(e);
      return Future.value(null);
    }
  }

  static Future<dynamic> dataPost(String url, {Map<String, String>? headers, dynamic data}) async {
    headers ??= {};
    try {
      return await (getDioInstance().post(url,
        data: data,
        options: Options(
          headers: buildHeaders(headers),
        ),
      ))
      .then((response){
        return response.data;
      });
    }
    catch(e) {
      logger.t(e);
      return Future.value(null);
    }
  }

  static Future<dynamic> filePut(String url, String filePath, {Map<String, String>? headers}) {
    return File(filePath).readAsBytes()
      .then((b) async {
        return await getDioInstance().put(url,
          data: b,
          options: Options(
            headers: buildHeaders(headers),
          ),
        );
      })
      .then((response){
        return response.data;
      });
  }

  static Future<String?> stringPost(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headers, dynamic data}) async {
    if (cacheKey!=null) {
      cacheKey = EncryptUtil.md5(cacheKey);
    }
    String? str;
    if (cacheKey!=null) {
      str = CacheUtil.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null) {
        return str;
      }
    }
    try {
      return await getDioInstance().post(url,
        data: data,
        options: Options(
          headers: buildHeaders(headers),
        ),
      ).then((response){
        str = response.toString();
        if (cacheKey!=null && str!=null) {
          CacheUtil.set(cacheKey, str!);
        }
        return str;
      });
    }
    catch(e) {
      // log.info(e);
      // debugPrint(e.toString());
      return Future.value(null);
    }
  }

  static Future<String> getAbsolutePath(String relativePath) {
    return getApplicationDocumentsDirectory().then((appDir){
      return "${appDir.path}/$relativePath";
    });
  }

  static Future<String?> downFile(String url, String savePath, {Map<String, String>? headers}) {
    try {
      return getAbsolutePath(savePath).then((filePath){
        // Dio dio = Dio();
        // dio.options.connectTimeout = 100000;
        // dio.options.receiveTimeout = 100000;
        return getDioInstance().download(
          url,
          filePath,
          options: Options(
            headers: buildHeaders(headers??{}),
          ),
        ).then((response){
          return filePath;
        });
      });
    }
    catch(e) {
      // log.info(e);
      return Future.value(null);
    }
  }

  static Map<String, String> buildHeaders(Map<String, String>? headers) {
    Map<String, String> map = {};
    map.addAll(defaultHeaderMap);
    if (headers!=null) {
      for(String key in headers.keys) {
        map[key] = headers[key]!;
      }
    }
    return map;
  }
}