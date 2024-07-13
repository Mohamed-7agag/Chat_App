import 'package:chateo/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageOptionsItem extends StatelessWidget {
  const MessageOptionsItem(
      {super.key, required this.image, required this.text, required this.onTap});
  final String image;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Image.asset(image, width: 40),
            SizedBox(width: 12.w),
            Text(
              text,
              style: Styles.textStyle18,
            )
          ],
        ),
      ),
    );
  }
}
