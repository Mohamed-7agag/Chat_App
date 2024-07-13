import 'package:chateo/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.keyboardType});
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'required';
        }
        return null;
      },
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        hintText: hintText,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
