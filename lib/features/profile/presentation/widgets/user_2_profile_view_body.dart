import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/core/helper/date_format.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/message_model.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class User2ProfileViewBody extends StatelessWidget {
  const User2ProfileViewBody({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    List<MessageModel> messagesList = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity, height: 40.h),
        CircleAvatar(
          radius: 75.r,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(user.image!),
        ),
        SizedBox(height: 20.h),
        Text(
          user.email!,
          style: Styles.textStyle18.copyWith(color: Colors.black54),
        ),
        SizedBox(height: 5.h),
        Text(user.about!, style: Styles.textStyle20),
        SizedBox(height: 30.h),
        StreamBuilder(
            stream:
                FirestoreService.instance.getAllImagesFromSpecificChat(user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const CustomLoadingWidget();
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  messagesList = data
                          ?.map((e) => MessageModel.fromJson(e.data()))
                          .toList() ??
                      [];
              }

              return messagesList.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      height: 135,
                      child: ListView.builder(
                        itemCount: messagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.imagePreViewViewRoute,
                                  arguments: messagesList[index].message);
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: messagesList[index].message!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink();
            }),
        Expanded(child: SizedBox(height: 30.h)),
        Text(
          "Joined at ${DateFormatConverter.getLastMessageTime(context: context, time: user.createdAt!, showYear: true)}",
          style: Styles.textStyle16.copyWith(color: Colors.black54),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
