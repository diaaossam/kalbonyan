import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/login_screen/cubit/login_cubit.dart';
import 'package:kalbonyan/screens/splash_screen/splash_screen.dart';
import 'package:kalbonyan/shared/helper/bloc_observer.dart';
import 'package:kalbonyan/shared/services/network/dio_helper.dart';
import 'package:kalbonyan/shared/styles/styles.dart';

import 'shared/services/loca_notification_service/local_notification_service.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken();
/*  BackgroundLocation.setAndroidNotification(
    message: "background Tracking Service Running",
    title: "Tracking",
    icon: "@mipmap/ic_launcher",
  );
  BackgroundLocation.setAndroidConfiguration(2000);
  BackgroundLocation.startLocationService();
  BackgroundLocation.getLocationUpdates((loca) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"lat": loca.latitude, "lon": loca.longitude});
    }
  });
  Future.delayed(
    Duration(seconds: 60),
        () async {
      BackgroundLocation.stopLocationService();
    },
  );*/
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await LocalNotificationService().initalize();
  DioHelper.init();
  FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    LocalNotificationService().showNotification(
        id: 0,
        title: "${event.notification!.title}",
        body: "${event.notification!.body}");
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: MaterialApp(
        home:  SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeManger.setLightTheme(),
        builder: (_, Widget? child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
  }
}
