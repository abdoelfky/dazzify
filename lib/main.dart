import 'dart:async';

import 'package:dazzify/bloc_observer.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/fcm_notifications.dart';
import 'package:dazzify/core/services/hive_service.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

late GlobalKey<NavigatorState> navRootKey;

Future<void> main() async {
  // runZonedGuarded(
  //   () async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Future.wait([
    HiveService.init(),
    ScreenUtil.ensureScreenSize(),
    dotenv.load(fileName: "lib/.env"),
  ]);
  configureDependencies();
  navRootKey = getIt<GlobalKey<NavigatorState>>();
  final notify = getIt<FCMNotification>();
  await notify.init();
  // final mapsImplementation = GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const DazzifyApp());
  });
  // },
  //   (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  // );
}
