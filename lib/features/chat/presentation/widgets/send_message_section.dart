import 'dart:io';

import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/features/chat/presentation/view_model/emoji_cubit.dart';
import 'package:chateo/features/chat/presentation/view_model/image_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SendMessageSection extends StatelessWidget {
  const SendMessageSection({
    super.key,
    required this.controller,
    required this.user,
  });
  final TextEditingController controller;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: AppColors.offWhiteColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: controller,
              onTap: () {
                if (AppConstants.showEmoji) {
                  context
                      .read<EmojCubit>()
                      .changeEmojiState(AppConstants.showEmoji);
                }
              },
              cursorColor: AppColors.primaryColor,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context
                        .read<EmojCubit>()
                        .changeEmojiState(AppConstants.showEmoji);
                  },
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
                suffixIcon: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          final List<XFile> images =
                              await imagePicker.pickMultiImage();
                          if (images.isNotEmpty) {
                            for (var element in images) {
                              if (context.mounted) {
                                context.read<MediaCubit>().changeState(true);
                              }
                              if (AppConstants.messagesList.isNotEmpty) {
                                await FirestoreService.instance.sendChatImage(
                                    user, File(element.path), false);
                              } else {
                                await FirestoreService.instance.sendChatImage(
                                    user, File(element.path), true);
                              }

                              if (context.mounted) {
                                context.read<MediaCubit>().changeState(false);
                              }
                            }
                          }
                        },
                        child: const Icon(
                          Icons.photo,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? image = await imagePicker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            if (context.mounted) {
                              context.read<MediaCubit>().changeState(true);
                            }

                            if (AppConstants.messagesList.isNotEmpty) {
                              await FirestoreService.instance
                                  .sendChatImage(user, File(image.path), false);
                            } else {
                              await FirestoreService.instance
                                  .sendChatImage(user, File(image.path), true);
                            }

                            if (context.mounted) {
                              context.read<MediaCubit>().changeState(false);
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                hintText: 'Type a Message...',
              ),
            )),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty && controller.text != '') {
                  if (AppConstants.messagesList.isEmpty) {
                    FirestoreService.instance.sendFirstMessage(
                      user,
                      controller.text,
                      'text',
                    );
                  } else {
                    FirestoreService.instance.sendMessage(
                      message: controller.text,
                      type: 'text',
                      user: user,
                    );
                  }

                  controller.clear();
                }
              },
              style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12).copyWith(left: 15)),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
