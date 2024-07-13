import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      this.width,
      this.color,
      required this.onPressed,
      this.textStyle});
  final String text;
  final double? width;
  final Color? color;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryColor,
          foregroundColor: Colors.white,
          fixedSize: Size(width ?? MediaQuery.sizeOf(context).width, 53)),
      child: Text(
        text,
        style: textStyle ?? Styles.textStyle18,
      ),
    );
  }
}
