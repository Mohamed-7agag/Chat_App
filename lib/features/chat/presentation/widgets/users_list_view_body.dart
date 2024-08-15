
import 'dart:developer';

import 'package:chateo/core/helper/auth_services.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/widgets/custom_failure_widget.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:chateo/features/chat/presentation/widgets/users_list_view_item.dart';
import 'package:flutter/material.dart';

class UsersListViewBody extends StatelessWidget {
  const UsersListViewBody({super.key, required this.searchedList});
  final List<UserModel> searchedList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreService.instance.getMyUsersID(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting ||
            userIdSnapshot.connectionState == ConnectionState.none) {
          return const CustomLoadingWidget();
        }

        if (userIdSnapshot.hasError) {
          log('Error fetching user IDs: ${userIdSnapshot.error}');
          return const CustomFailureWidget(
              errMessage: 'Error fetching user IDs');
        }

        if (!userIdSnapshot.hasData || userIdSnapshot.data == null) {
          return const CustomFailureWidget(errMessage: 'No user IDs found');
        }

        final userIds =
            userIdSnapshot.data?.docs.map((e) => e.id).toList() ?? [];
            

        if (userIds.isEmpty) {
          return const CustomFailureWidget(errMessage: 'No user IDs found');
        }

        return StreamBuilder(
          stream: FirestoreService.instance.getAllUsers(userIds),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting ||
                userSnapshot.connectionState == ConnectionState.none) {
              return const CustomLoadingWidget();
            }

            if (userSnapshot.hasError) {
              return const CustomFailureWidget(
                  errMessage: 'Error fetching users');
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const CustomFailureWidget(errMessage: 'No users found');
            }

            final data = userSnapshot.data?.docs ?? [];
            AppConstants.usersList.clear();
            for (var element in data) {
              if (element.id != AuthService.instance.auth.currentUser?.uid) {
                AppConstants.usersList.add(UserModel.fromJson(element.data()));
              } else {
                AppConstants.currentUser = UserModel.fromJson(element.data());
              }
            }

            return AppConstants.usersList.isEmpty
                ? const CustomFailureWidget(errMessage: 'No Chats Found')
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: AppConstants.isSearching
                        ? searchedList.length
                        : AppConstants.usersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UsersListViewItem(
                        user: AppConstants.isSearching
                            ? searchedList[index]
                            : AppConstants.usersList[index],
                      );
                    },
                  );
          },
        );
      },
    );
  }
}
