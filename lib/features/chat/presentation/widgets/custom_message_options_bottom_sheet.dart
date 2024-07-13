import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chateo/core/helper/date_format.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:chateo/features/chat/presentation/widgets/message_options_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';

Future<void> saveNetworkImage(String path) async {
  var response =
      await Dio().get(path, options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    name: "Chateo/${DateTime.now().millisecondsSinceEpoch}.jpg",
  );
  debugPrint("result: $result");
}

void customMessageOptionsBottomSheet(
    BuildContext cnt, int index, bool isImage) {
  showModalBottomSheet<void>(
    context: cnt,
    builder: (BuildContext context) {
      TextEditingController messageController = TextEditingController(
        text: AppConstants.messagesList[index].message,
      );

      return Container(
          alignment: Alignment.center,
          height: isImage ? 180 : 310,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.done_rounded,
                        color: Colors.grey[500],
                        size: 22,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Sent at : ${DateFormatConverter.getLastMessageTime(context: context, time: AppConstants.messagesList[index].sendAt!)}',
                        style: Styles.textStyle14,
                      ),
                    ],
                  ),
                  SizedBox(width: 40.w),
                  Row(
                    children: [
                      const Icon(
                        Icons.done_all_rounded,
                        color: Colors.blue,
                        size: 22,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Read at : ${AppConstants.messagesList[index].readAt == '' ? "Not Read Yet" : DateFormatConverter.getLastMessageTime(context: context, time: AppConstants.messagesList[index].readAt!)}',
                        style: Styles.textStyle14,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              isImage
                  ? MessageOptionsItem(
                      image: 'assets/images/download.png',
                      text: 'Save Image',
                      onTap: () async {
                        try {
                          await saveNetworkImage(
                              AppConstants.messagesList[index].message!);
                          if (context.mounted) {
                            successCherryToast(
                                context, 'Success', 'Image Saved to Gallery');
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            errorCherryToast(context, 'Error',
                                'Something went wrong,try again');
                          }
                        }
                      },
                    )
                  : MessageOptionsItem(
                      image: 'assets/images/update.png',
                      text: 'Edit Message',
                      onTap: () {
                        AwesomeDialog(
                            context: context,
                            animType: AnimType.topSlide,
                            dialogType: DialogType.noHeader,
                            body: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: TextFormField(
                                controller: messageController,
                                maxLines: null,
                                cursorColor: AppColors.primaryColor,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                            ),
                            btnCancelColor: const Color(0xffd93e46),
                            btnOkColor: const Color(0xff00ca71),
                            btnCancelOnPress: () {
                              Navigator.pop(context);
                            },
                            btnOkOnPress: () {
                              FirestoreService.instance.updateMessage(
                                  AppConstants.messagesList[index],
                                  messageController.text.isEmpty
                                      ? AppConstants
                                          .messagesList[index].message!
                                      : messageController.text);
                              Navigator.pop(context);
                            }).show();
                      },
                    ),
              MessageOptionsItem(
                image: 'assets/images/delete.png',
                text: 'Delete Message',
                onTap: () {
                  FirestoreService.instance
                      .deleteMessage(AppConstants.messagesList[index]);
                  Navigator.pop(context);
                },
              ),
              isImage
                  ? const SizedBox.shrink()
                  : MessageOptionsItem(
                      image: 'assets/images/copy.png',
                      text: 'Copy Message',
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: AppConstants.messagesList[index].message!));
                        successCherryToast(
                            context, 'Success', 'Message copied');
                        Navigator.pop(context);
                      },
                    ),
              isImage
                  ? const SizedBox.shrink()
                  : MessageOptionsItem(
                      image: 'assets/images/share.png',
                      text: 'Share Message',
                      onTap: () {
                        Share.share(AppConstants.messagesList[index].message!);
                        Navigator.pop(context);
                      },
                    ),
            ],
          ));
    },
  );
}
