import 'package:chateo/cache/cache_helper.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/helper/auth_services.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1700), () {
      AuthService.instance.auth.currentUser == null
          ? CacheHelper.getData(key: AppConstants.intro) == true
              ? Navigator.pushReplacementNamed(context, Routes.loginViewRoute)
              : Navigator.pushReplacementNamed(context, Routes.introViewRoute)
          : Navigator.pushReplacementNamed(context, Routes.usersListViewRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/splash_icon2.png',
            width: 42.w,
          ),
          SizedBox(width: 3.w),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('Chateo', style: Styles.textStyle34.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
