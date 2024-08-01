import 'package:chateo/cache/cache_helper.dart';
import 'package:chateo/core/utils/app_router.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirestoreService.instance.getFCMToken();
  CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData.light().copyWith(
              textTheme: GoogleFonts.tajawalTextTheme(
                ThemeData.light().textTheme,
              ),
              scaffoldBackgroundColor: Colors.white),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.splashViewRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
