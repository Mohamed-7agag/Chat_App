import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomProfileTextField extends StatefulWidget {
  const CustomProfileTextField(
      {super.key,
      required this.value,
      required this.label,
      required this.hintText,
      required this.preIcon,
      required this.controller});
  final String value;
  final String label;
  final String hintText;
  final IconData preIcon;
  final TextEditingController controller;

  @override
  State<CustomProfileTextField> createState() => _CustomProfileTextFieldState();
}

class _CustomProfileTextFieldState extends State<CustomProfileTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.preIcon,
          color: AppColors.primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        hintText: widget.hintText,
        label: Text(widget.label),
      ),
      style: Styles.textStyle18,
    );
  }
}
