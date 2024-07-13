import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/core/helper/date_format.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:chateo/features/chat/presentation/widgets/custom_message_options_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChatBubble extends StatelessWidget {
  const CustomChatBubble({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          if (AppConstants.messagesList[index].type == 'image') {
            customMessageOptionsBottomSheet(context, index, true);
          } else {
            customMessageOptionsBottomSheet(context, index, false);
          }
        },
        onTap: () {
          if (AppConstants.messagesList[index].type == 'image') {
            Navigator.pushNamed(context, Routes.imagePreViewViewRoute,
                arguments: AppConstants.messagesList[index].message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ChatBubble(
            elevation: 0.8,
            padding: EdgeInsets.only(
              left: AppConstants.messagesList[index].fromId! ==
                      AppConstants.currentUser!.id
                  ? 10
                  : 24,
              right: AppConstants.messagesList[index].fromId! ==
                      AppConstants.currentUser!.id
                  ? 24
                  : 10,
              top: 6,
              bottom: 3,
            ),
            clipper: ChatBubbleClipper1(
              type: AppConstants.messagesList[index].fromId! ==
                      AppConstants.currentUser!.id
                  ? BubbleType.sendBubble
                  : BubbleType.receiverBubble,
            ),
            alignment: AppConstants.messagesList[index].fromId! ==
                    AppConstants.currentUser!.id
                ? Alignment.topRight
                : Alignment.topLeft,
            margin: const EdgeInsets.only(top: 6),
            backGroundColor: AppConstants.messagesList[index].fromId! ==
                    AppConstants.currentUser!.id
                ? AppColors.primaryColor
                : Colors.white,
            child: IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppConstants.messagesList[index].type == 'text'
                        ? Text(
                            AppConstants.messagesList[index].message!,
                            style: Styles.textStyle16.copyWith(
                                color:
                                    AppConstants.messagesList[index].fromId! ==
                                            AppConstants.currentUser!.id
                                        ? Colors.white
                                        : Colors.black),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    AppConstants.messagesList[index].message!,
                                errorWidget: (context, url, error) {
                                  return const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                    size: 60,
                                  );
                                },
                                placeholder: (context, url) {
                                  return const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CustomLoadingWidget(
                                        color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: AppConstants.messagesList[index].fromId! !=
                              AppConstants.currentUser!.id
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Text(
                          DateFormatConverter.convertDate(context,
                              AppConstants.messagesList[index].sendAt!),
                          style: Styles.textStyle10.copyWith(
                              fontSize: 11.sp,
                              color: AppConstants.messagesList[index].fromId! ==
                                      AppConstants.currentUser!.id
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        AppConstants.messagesList[index].fromId! ==
                                AppConstants.currentUser!.id
                            ? SizedBox(width: 5.w)
                            : const SizedBox.shrink(),
                        AppConstants.messagesList[index].fromId! ==
                                AppConstants.currentUser!.id
                            ? AppConstants.messagesList[index].readAt! == ''
                                ? Icon(
                                    Icons.done_rounded,
                                    color: Colors.grey[400],
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.done_all_rounded,
                                    color: Colors.blue[200],
                                    size: 20,
                                  )
                            : const SizedBox.shrink()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
