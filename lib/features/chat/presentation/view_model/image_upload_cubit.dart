import 'package:chateo/core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaCubit extends Cubit<bool> {
  MediaCubit() : super(false);

  void changeState(bool isUploading) {
    AppConstants.isUploading = isUploading;
    emit(isUploading);
  }
}