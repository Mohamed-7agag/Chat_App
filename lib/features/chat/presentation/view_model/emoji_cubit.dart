import 'package:chateo/core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmojCubit extends Cubit<bool> {
  EmojCubit() : super(false);

  void changeEmojiState(bool showEmoji) {
    AppConstants.showEmoji = !showEmoji;
    emit(!showEmoji);
  }
}


