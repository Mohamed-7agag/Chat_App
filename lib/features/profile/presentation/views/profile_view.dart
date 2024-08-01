import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:chateo/features/profile/presentation/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'My Profile',
            style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.infoReverse,
              animType: AnimType.topSlide,
              title: 'Are you sure?',
              desc: 'Do you want to log out?',
              btnCancelOnPress: () {},
              btnCancelColor: const Color(0xffd93e46),
              btnOkColor: const Color(0xff00ca71),
              btnOkOnPress: () {
                context.read<AuthCubit>().logout().then((value) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.loginViewRoute,
                  );
                });
              }).show();
        },
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 22),
        label: Text(
          'LogOut',
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.logout, size: 22),
      ),
      body: ProfileViewBody(user: user),
    );
  }
}
