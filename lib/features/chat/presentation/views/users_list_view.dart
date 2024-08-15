import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/users_list_view_body.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  TextEditingController controller = TextEditingController();
  List<UserModel> searchedList = [];
  void handleSearch(String value) {
    setState(() {
      searchedList = AppConstants.usersList.where((element) {
        return element.name!.toLowerCase().contains(value.toLowerCase()) ||
            element.email!.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    FirestoreService.instance.getFCMToken();

    FirestoreService.instance.updateLastActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler(
      (message) {
        if (message.toString().contains('resume')) {
          FirestoreService.instance.updateLastActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          FirestoreService.instance.updateLastActiveStatus(false);
        }
        return Future.value(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: AppConstants.isSearching
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Image.asset('assets/images/splash_icon2.png'),
              ),
        leadingWidth: 37.w,
        titleSpacing: 3,
        title: Padding(
          padding:
              EdgeInsets.only(top: 15, left: AppConstants.isSearching ? 12 : 0),
          child: AppConstants.isSearching
              ? TextField(
                  onChanged: handleSearch,
                  cursorColor: Colors.white,
                  autofocus: true,
                  style: Styles.textStyle16.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name, Email...',
                    hintStyle: Styles.textStyle16.copyWith(color: Colors.white),
                  ),
                )
              : Text(
                  'Chateo',
                  style:
                      Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
                ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchedList.clear();
                AppConstants.isSearching = !AppConstants.isSearching;
              });
            },
            icon: Icon(AppConstants.isSearching
                ? CupertinoIcons.xmark
                : CupertinoIcons.search),
          ),
          PopupMenuButton(
            iconSize: 27,
            elevation: 1,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            offset: const Offset(-15, 30),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                value: "Profile",
                height: 30,
                onTap: () {
                  Navigator.pushNamed(context, Routes.profileViewRoute,
                      arguments: AppConstants.currentUser);
                },
                child: Text(
                  "Profile",
                  style: Styles.textStyle18,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeDialog(
              context: context,
              animType: AnimType.bottomSlide,
              dialogType: DialogType.noHeader,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_add_alt_1,
                          color: AppColors.primaryColor,
                          size: 28,
                        ),
                        SizedBox(width: 10.w),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('Add User', style: Styles.textStyle18),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: controller,
                      maxLines: null,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Enter Email of User to Add',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              btnCancelColor: const Color(0xffd93e46),
              btnOkColor: const Color(0xff00ca71),
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                if (controller.text.isEmpty) {
                  errorCherryToast(context, 'Error', 'Email is required');
                } else {
                  FirestoreService.instance
                      .addUserToMyUsers(controller.text)
                      .then(
                    (value) {
                      if (value) {
                        if (context.mounted) {
                          successCherryToast(
                              context, 'Success', 'User added successfully');
                        }
                      } else {
                        if (context.mounted) {
                          errorCherryToast(
                              context, 'Error', 'Email is not Found');
                        }
                      }
                      controller.clear();
                    },
                  );
                }
              }).show();
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add_comment_rounded,
          color: Colors.white,
          size: 27,
        ),
      ),
      body: UsersListViewBody(
        searchedList: searchedList,
      ),
    );
  }
}
