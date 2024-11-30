import 'package:onote/object/ui.dart';
import 'package:onote/service/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onote/config/routes.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';

// late final FirebaseApp app;
// late final FirebaseAuth auth;

UI ui = UI();

// Future<void> _firebaseInit() {
//   return Firebase.initializeApp(
//     name: "AI Note",
//     options: DefaultFirebaseOptions.currentPlatform,
//   )
//   .then((app){
//     app = app;
//     auth = FirebaseAuth.instanceFor(app: app);
//   });
// }

@pragma('vm:entry-point')
void callbackDispatcher() {
  final Logger logger = Logger();
  Workmanager().executeTask((task, inputData) {
    logger.t("Workmanager().executeTask <$task> : $inputData");
    return Future.value(true);
  });
}

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  // _firebaseInit();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "task-identifier",
    "myTask",
    initialDelay: const Duration(minutes: 1),
    // constraints: Constraints (
    //   requiresCharging: true,
    //   networkType: NetworkType.connected,
    // ),
  );
  // Wakelock.enable();
  await Future.delayed(const Duration(milliseconds: 50), () {
    initializeDateFormatting().then((_){
      runApp(
        const App()
        // Phoenix(child:const App())
      );
    });
  });
  SystemChrome.restoreSystemUIOverlays();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.green.shade100,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    ui.init(context);
    FocusScope.of(context).requestFocus(FocusNode());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return;
      },
      getPages: Routes.getPages,
      color: ui.bgColor,
      home: Container(
        height: ui.topHeight, 
        color: ui.bgColor,
        alignment: Alignment.center,
        child: const SizedBox()
        // child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children:[
        //       SpinKit.cubeGrid(size: 80, color:ui.fgColor),
        //       const SizedBox(height:5),
        //       EasyUI.twoColorText(text1: "O", text2: "NOTE", color1: ui.fgColor)
        //     ]
        //   )
      ),
      // locale: Locale("zh", "CN"),
      locale: Get.deviceLocale,
      translations: TranslationService(),
      theme: ThemeData(brightness: Brightness.light, scaffoldBackgroundColor: Colors.transparent),
      // theme: FlexThemeData.light(scheme: FlexScheme.greenM3),
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.greenM3),
      // themeMode: ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 2000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorSize = 44.0
            ..radius = 5.0
            ..toastPosition = EasyLoadingToastPosition.bottom
            ..contentPadding = const EdgeInsets.fromLTRB(10, 10, 10, 10)
            ..backgroundColor = Colors.black
            ..indicatorColor = Colors.white
            ..textColor = Colors.white
            ..maskColor = Colors.white;
          return EasyLoading.init().call(context, child);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ui.initApplicationDir().then((v){
      DBService.initDababase().then((v){
        Future.delayed(const Duration(milliseconds: 100), (){
          // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          //   systemNavigationBarColor: Colors.black
          // ));
          Get.offNamed("/page/note");
          // Get.offNamed("/page/main");
        });
      });
    });
  }
}
