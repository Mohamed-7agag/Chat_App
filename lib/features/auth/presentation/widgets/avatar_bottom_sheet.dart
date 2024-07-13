import 'package:chateo/features/auth/data/avatar_list.dart';
import 'package:chateo/features/auth/presentation/view_model/change_avatar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void avatarBottomSheet(BuildContext cnt) {
  showModalBottomSheet<void>(
    context: cnt,
    builder: (BuildContext context) {
      return Container(
        alignment: Alignment.center,
        height: 410,
        padding: const EdgeInsets.only(top: 15),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: avatarList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                cnt.read<ChangeAvatarCubit>().changeAvatar(avatarList[index]);
                Navigator.pop(context);
              },
              child: Image.asset(avatarList[index]),
            );
          },
        ),
      );
    },
  );
}
