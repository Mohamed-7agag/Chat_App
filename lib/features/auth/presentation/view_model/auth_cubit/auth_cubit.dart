import 'package:chateo/core/helper/auth_services.dart';
import 'package:chateo/core/helper/firestore_services.dart';
import 'package:chateo/core/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? avatar;

//! login
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        emit(AuthLoginLoading());
        await AuthService.instance.auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        emit(AuthLoginSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthLoginFailure(errMessage: e.code));
      } catch (e) {
        emit(AuthLoginFailure(errMessage: e.toString()));
      }
    }
  }

//! register
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      try {
        emit(AuthRegisterLoading());
        //! create user
        await AuthService.instance.auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //! add user to firestore
        await FirestoreService.instance.addUser(
          name: nameController.text,
          email: emailController.text,
          passWord: passwordController.text,
          avatar: avatar != 'assets/images/add_image.png'
              ? avatar!
              : 'assets/images/Avatar.png',
        );
        emit(AuthRegisterSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthRegisterFailure(errMessage: e.code));
      } catch (e) {
        emit(AuthRegisterFailure(errMessage: e.toString()));
      }
    }
  }

//! logout
  Future<void> logout() async {
    await AuthService.instance.auth.signOut();
    AppConstants.currentUser = null;
  }
}
