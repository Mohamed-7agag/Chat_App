import 'package:chateo/cache/cache_helper.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroViewBody extends StatelessWidget {
  const IntroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 55.h),
          Image.asset('assets/images/onboarding.png', width: 250.w),
          SizedBox(height: 50.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Connect easily with your family and friends over countries',
              textAlign: TextAlign.center,
              style: Styles.textStyle24,
            ),
          ),
          Expanded(child: SizedBox(height: 30.h)),
          CustomButton(
            text: 'Start Messaging',
            textStyle: Styles.textStyle18.copyWith(fontWeight: FontWeight.bold),
            onPressed: () {
              CacheHelper.saveData(key: AppConstants.intro, value: true);
              Navigator.pushReplacementNamed(context, Routes.loginViewRoute);
            },
          )
        ],
      ),
    );
  }
}
