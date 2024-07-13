import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';

import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            'Login Page',
            style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: const LoginViewBody(),
    );
  }
}
