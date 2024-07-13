import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void successCherryToast(
    BuildContext context, String title, String description) {
  CherryToast.success(
    title: Text(title),
    description: Text(description),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
    textDirection: TextDirection.ltr,
    width: MediaQuery.of(context).size.width - 80.w,
  ).show(context);
}

void errorCherryToast(BuildContext context, String title, String description) {
  CherryToast.error(
    title: Text(title),
    description: Text(description),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
    width: MediaQuery.of(context).size.width - 80.w,
  ).show(context);
}

void warningCherryToast(
    BuildContext context, String title, String description) {
  CherryToast.warning(
    title: Text(title),
    description: Text(description),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
    width: MediaQuery.of(context).size.width - 80.w,
  ).show(context);
}

void infoCherryToast(BuildContext context, String title, String description) {
  CherryToast.info(
    title: Text(title),
    description: Text(description),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
    width: MediaQuery.of(context).size.width - 80.w,
  ).show(context);
}
