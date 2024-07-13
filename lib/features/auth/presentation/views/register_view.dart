import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/features/auth/presentation/widgets/register_view_body.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            'Register Page',
            style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: const RegisterViewBody(),
    );
  }
}
