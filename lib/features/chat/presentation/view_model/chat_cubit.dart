import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<List<String>> {
  ChatCubit() : super([]);

  void addMessage(String message) {
    //? Creating a new list that includes all the previous messages (state) and the new message (message)
    emit([...state, message]);
  }
}
