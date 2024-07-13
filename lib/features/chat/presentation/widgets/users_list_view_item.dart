import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chateo/core/helper/auth_services.dart';
import 'package:chateo/core/helper/date_format.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/message_model.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersListViewItem extends StatelessWidget {
  const UsersListViewItem({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    MessageModel? lastMessage;

    return StreamBuilder(
      stream: FirestoreService.instance.getLastMessage(user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final List<MessageModel> list =
            data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
        if (list.isNotEmpty) {
          lastMessage = list[0];
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.chatViewRoute, arguments: user);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            )),
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.leftSlide,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 14)
                            .copyWith(top: 0, right: 10),
                    width: 340,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                user.name!,
                                style: Styles.textStyle16,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, Routes.user2ProfileViewRoute,
                                      arguments: user);
                                },
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primaryColor,
                                ))
                          ],
                        ),
                        SizedBox(height: 10.h),
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(user.image!),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ).show();
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      AssetImage(user.image ?? 'assets/images/Avatar.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              title: Text(
                user.name ?? 'Unknown Name',
                style: Styles.textStyle16,
              ),
              subtitle: Row(
                children: [
                  lastMessage?.fromId == AuthService.instance.auth.currentUser!.uid
                      ? lastMessage != null
                          ? lastMessage!.readAt == ''
                              ? Icon(
                                  Icons.done_rounded,
                                  color: Colors.grey.shade500,
                                  size: 18,
                                )
                              : const Icon(
                                  Icons.done_all_rounded,
                                  color: Colors.blue,
                                  size: 18,
                                )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      lastMessage != null
                          ? lastMessage!.type == 'image'
                              ? '**image**'
                              : lastMessage!.message!
                          : user.about!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: lastMessage == null
                  ? null
                  : lastMessage!.fromId != AuthService.instance.auth.currentUser!.uid &&
                          lastMessage!.readAt == ''
                      ? const CircleAvatar(
                          radius: 5, backgroundColor: Colors.green)
                      : Text(
                          DateFormatConverter.getLastMessageTime(
                            context: context,
                            time: lastMessage!.sendAt!,
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }
}
