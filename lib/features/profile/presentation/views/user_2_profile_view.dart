import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/features/profile/presentation/widgets/user_2_profile_view_body.dart';
import 'package:flutter/material.dart';

class User2ProfileView extends StatelessWidget {
  const User2ProfileView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            '${user.name}',
            style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: User2ProfileViewBody(user: user),
    );
  }
}
