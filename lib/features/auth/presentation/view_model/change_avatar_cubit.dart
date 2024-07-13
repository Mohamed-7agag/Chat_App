import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeAvatarCubit extends Cubit<String> {
  ChangeAvatarCubit(super.avatar);

  void changeAvatar(String image) => emit(image);
}
