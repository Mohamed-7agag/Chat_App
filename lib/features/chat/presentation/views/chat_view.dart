import 'package:chateo/core/helper/date_format.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';

import '../widgets/chat_view_body.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirestoreService.instance.getUserInformation(userModel),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final List<UserModel> userinfo =
                data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.user2ProfileViewRoute,
                    arguments: userinfo.isNotEmpty ? userinfo[0] : userModel);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(userinfo.isNotEmpty
                        ? userinfo[0].image!
                        : userModel.image!),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          userinfo.isNotEmpty
                              ? userinfo[0].name!
                              : userModel.name!,
                          style: Styles.textStyle18,
                        ),
                      ),
                      Text(
                        userinfo.isNotEmpty
                            ? userinfo[0].isOnline!
                                ? 'Online Now'
                                : DateFormatConverter.getLastActiveTime(
                                    context: context,
                                    lastActive: userinfo[0].lastActive!)
                            : DateFormatConverter.getLastActiveTime(
                                context: context,
                                lastActive: userModel.lastActive!),
                        style: Styles.textStyle10.copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        titleSpacing: 0,
        leadingWidth: 30,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        toolbarHeight: 60,
      ),
      body: ChatViewBody(userModel: userModel),
    );
  }
}
