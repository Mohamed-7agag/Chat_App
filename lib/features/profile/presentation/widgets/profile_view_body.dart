import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_button.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:chateo/features/auth/presentation/view_model/change_avatar_cubit.dart';
import 'package:chateo/features/auth/presentation/widgets/avatar_bottom_sheet.dart';
import 'package:chateo/features/profile/presentation/widgets/custom_profile_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileViewBody extends StatelessWidget {
  ProfileViewBody({super.key, required this.user});
  final UserModel user;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? avatar;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h, width: double.infinity),
            Stack(
              clipBehavior: Clip.none,
              children: [
                BlocBuilder<ChangeAvatarCubit, String>(
                  builder: (context, state) {
                    avatar = state;
                    return CircleAvatar(
                      radius: 65.r,
                      backgroundImage: AssetImage(state),
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.offWhiteColor,
                    child: IconButton(
                        onPressed: () {
                          avatarBottomSheet(context);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black54,
                        )),
                  ),
                )
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              user.email ?? 'Unknown Email',
              style: Styles.textStyle18.copyWith(color: Colors.black54),
            ),
            SizedBox(height: 40.h),
            CustomProfileTextField(
              controller: nameController,
              value: user.name ?? 'Unknown Name',
              label: 'Name',
              hintText: 'eg. John Doe',
              preIcon: Icons.person,
            ),
            SizedBox(height: 30.h),
            CustomProfileTextField(
              controller: aboutController,
              value: user.about ?? 'Unknown',
              label: 'About me',
              hintText: 'eg. I am a student',
              preIcon: Icons.info_outline_rounded,
            ),
            SizedBox(height: 60.h),
            CustomButton(
              text: 'Update',
              width: 210.w,
              textStyle:
                  Styles.textStyle18.copyWith(fontWeight: FontWeight.bold),
              onPressed: () {
                if (nameController.text.isEmpty ||
                    aboutController.text.isEmpty) {
                  errorCherryToast(context, 'Error', 'Please fill all fields');
                } else {
                  FirestoreService.instance.updateUser(
                    context,
                    nameController.text,
                    aboutController.text,
                    avatar ?? 'assets/images/Avatar.png',
                  );
                }
              },
            ),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }
}
