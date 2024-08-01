import 'package:chateo/core/models/message_model.dart';
import 'package:chateo/core/models/user_model.dart';

abstract class AppConstants {
  static const String users = 'users';
  static const String myUsers = 'myUsers';
  static const String messages = 'messages';
  static const String chats = 'chats';
  static const String intro = 'intro';
  static const String projectID = 'chateo-79d03';
  static String? userPushToken;

  static UserModel? currentUser;
  static MessageModel? lastMessage;

  static bool isSearching = false;
  static bool isUploading = false;
  static bool showEmoji = false;
  
  static List<UserModel> usersList = [];
  static List<MessageModel> messagesList = [];
}
