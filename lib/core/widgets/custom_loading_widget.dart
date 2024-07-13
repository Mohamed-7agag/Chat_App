import 'package:chateo/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key, this.color, this.strokeWidth});
  final Color? color;
  final double? strokeWidth;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor,
        strokeCap: StrokeCap.round,
        strokeWidth: strokeWidth ?? 4,
      ),
    );
  }
}
