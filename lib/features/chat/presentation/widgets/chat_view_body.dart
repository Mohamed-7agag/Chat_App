import 'package:chateo/features/chat/presentation/view_model/emoji_cubit.dart';
import 'package:chateo/features/chat/presentation/view_model/image_upload_cubit.dart';
import 'package:chateo/features/chat/presentation/widgets/custom_chat_bubble.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/message_model.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/widgets/custom_failure_widget.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'send_message_section.dart';

class ChatViewBody extends StatelessWidget {
  ChatViewBody({super.key, required this.userModel});
  final UserModel userModel;

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppColors.offWhiteColor,
            child: StreamBuilder(
              stream: FirestoreService.instance.getAllMessages(userModel),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const CustomLoadingWidget();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    AppConstants.messagesList = data
                            ?.map((e) => MessageModel.fromJson(e.data()))
                            .toList() ??
                        [];
                }
                return AppConstants.messagesList.isEmpty
                    ? const CustomFailureWidget(
                        errMessage: 'Say Hii! 👋',
                      )
                    : ListView.builder(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: AppConstants.messagesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (AppConstants.messagesList[index].readAt == '') {
                            FirestoreService.instance.updateMessageReadStatus(
                                AppConstants.messagesList[index]);
                          }
                          return CustomChatBubble(index: index);
                        },
                      );
              },
            ),
          ),
        ),
        BlocBuilder<MediaCubit, bool>(
          builder: (context, state) {
            return state == true
                ? Container(
                    color: AppColors.offWhiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0).copyWith(right: 15),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: CustomLoadingWidget(strokeWidth: 2),
                          ),
                        ],
                      ),
                    ))
                : const SizedBox.shrink();
          },
        ),
        SendMessageSection(
          controller: controller,
          user: userModel,
        ),
        BlocBuilder<EmojCubit, bool>(
          builder: (context, state) {
            return state == true
                ? EmojiPicker(
                    textEditingController: controller,
                    config: Config(
                      checkPlatformCompatibility: true,
                      categoryViewConfig: const CategoryViewConfig(
                          iconColorSelected: AppColors.primaryColor,
                          indicatorColor: AppColors.primaryColor,
                          backspaceColor: AppColors.primaryColor,
                          showBackspaceButton: true),
                      height: MediaQuery.of(context).size.height * 0.38,
                      bottomActionBarConfig: const BottomActionBarConfig(
                        showBackspaceButton: false,
                        showSearchViewButton: false,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
