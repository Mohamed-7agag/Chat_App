import 'dart:io';

import 'package:chateo/core/helper/auth_services.dart';
import 'package:chateo/core/models/message_model.dart';
import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  // Private constructor
  FirestoreService._privateConstructor();

  // Singleton instance
  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firestore;

  //! firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //! firebase Messaging
  static FirebaseMessaging fcm = FirebaseMessaging.instance;

//! Get Collection
  CollectionReference getCollection(String collectionPath) {
    return _firestore.collection(collectionPath);
  }

//! Add User
  Future<void> addUser({
    required String name,
    required String email,
    required String passWord,
    required String avatar,
  }) async {
    await _firestore
        .collection(AppConstants.users)
        .doc(AuthService.instance.auth.currentUser!.uid)
        .set(
          UserModel(
            name: name,
            email: email,
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            id: AuthService.instance.auth.currentUser!.uid,
            about: 'Hi, I am a New User 👋',
            isOnline: false,
            lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
            password: passWord,
            pushToken: '',
            image: avatar,
          ).toJson(),
        );
    await addUserToMyUsers(email);
  }

//! Get All Users
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIDs) {
    return _firestore
        .collection(AppConstants.users)
        .where('id', whereIn: userIDs.isEmpty ? [''] : userIDs)
        .snapshots();
  }

//! get my user ID
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersID() {
    return firestore
        .collection(AppConstants.users)
        .doc(AuthService.instance.auth.currentUser!.uid)
        .collection(AppConstants.myUsers)
        .snapshots();
  }

//! add user to chat with him
  Future<bool> addUserToMyUsers(String email) async {
    final data = await firestore
        .collection(AppConstants.users)
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty &&
        data.docs.first.id != AuthService.instance.auth.currentUser!.uid) {
      firestore
          .collection(AppConstants.users)
          .doc(AuthService.instance.auth.currentUser!.uid)
          .collection(AppConstants.myUsers)
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      if (data.docs.isNotEmpty &&
          data.docs.first.id == AuthService.instance.auth.currentUser!.uid &&
          AppConstants.currentUser == null) {
        firestore
            .collection(AppConstants.users)
            .doc(AuthService.instance.auth.currentUser!.uid)
            .collection(AppConstants.myUsers)
            .doc(data.docs.first.id)
            .set({});
      }
      return false;
    }
  }

//! send First Message
  Future<void> sendFirstMessage(
      UserModel user, String message, String type) async {
    await firestore
        .collection(AppConstants.users)
        .doc(user.id)
        .collection(AppConstants.myUsers)
        .doc(AuthService.instance.auth.currentUser!.uid)
        .set({}).then(
            (value) => sendMessage(message: message, type: type, user: user));
  }

// //! Get User Information
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInformation(
      UserModel user) {
    return firestore
        .collection(AppConstants.users)
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

//! update last active status
  Future<void> updateLastActiveStatus(bool isOnline) {
    return firestore
        .collection(AppConstants.users)
        .doc(AppConstants.currentUser!.id)
        .update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': AppConstants.currentUser!.pushToken,
    });
  }

//! Get All Messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
    return firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(user.id!)}/${AppConstants.messages}/')
        .orderBy('sendAt', descending: true)
        .snapshots();
  }

//! Get All Image from a specific chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllImagesFromSpecificChat(
      UserModel user) {
    return firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(user.id!)}/${AppConstants.messages}/')
        .where('type', isEqualTo: 'image')
        .snapshots();
  }

//! Update User
  Future<void> updateUser(
      BuildContext context, String name, String about, String image) async {
    return await firestore
        .collection(AppConstants.users)
        .doc(AuthService.instance.auth.currentUser!.uid)
        .update({
      'name': name,
      'about': about,
      'image': image,
    }).then((value) {
      successCherryToast(
        context,
        'Success',
        'Profile Info Updated',
      );
    });
  }

//! Get Conversation ID
  static String getConversationID(String id) {
    return AuthService.instance.auth.currentUser!.uid.hashCode <= id.hashCode
        ? '${AuthService.instance.auth.currentUser!.uid}_$id'
        : '${id}_${AuthService.instance.auth.currentUser!.uid}';
  }

  //! Add Message
  Future<void> sendMessage({
    required String message,
    required String type,
    required UserModel user,
  }) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(user.id!)}/${AppConstants.messages}/')
        .doc(time)
        .set(
          MessageModel(
            message: message,
            fromId: AuthService.instance.auth.currentUser!.uid,
            toId: user.id,
            sendAt: time,
            readAt: '',
            type: type,
          ).toJson(),
        );
  }

//! Update Message Read
  Future<void> updateMessageReadStatus(MessageModel message) async {
    await firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(message.fromId!)}/${AppConstants.messages}/')
        .doc(message.sendAt)
        .update({'readAt': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //! get Last Message
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user) {
    return firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(user.id!)}/${AppConstants.messages}/')
        .orderBy('sendAt', descending: true)
        .limit(1)
        .snapshots();
  }

  //! update message
  Future<void> updateMessage(MessageModel message, String newMessage) async {
    await firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(message.toId!)}/${AppConstants.messages}/')
        .doc(message.sendAt)
        .update({'message': newMessage});
  }

  //! delete message
  Future<void> deleteMessage(MessageModel message) async {
    await firestore
        .collection(
            '${AppConstants.chats}/${getConversationID(message.toId!)}/${AppConstants.messages}/')
        .doc(message.sendAt)
        .delete();

    if (message.type == 'image') {
      await storage.refFromURL(message.message!).delete();
    }
  }

  //! send image in chat
  Future<void> sendChatImage(
      UserModel user, File file, bool isFirstMessage) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(user.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    if (isFirstMessage) {
      await sendFirstMessage(user, imageUrl, 'image');
    } else {
      await sendMessage(message: imageUrl, type: 'image', user: user);
    }
  }

//! get FCM token
  Future<void> getFCMToken() async {
    await fcm.requestPermission();
    fcm.getToken().then((token) {
      if (token != null) {
        AppConstants.currentUser =
            AppConstants.currentUser!.copyWith(pushToken: token);
      }
    });
  }
}
