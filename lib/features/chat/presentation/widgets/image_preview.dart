import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreView extends StatelessWidget {
  const ImagePreView({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.black87),
          loadingBuilder: (context, event) {
            return const CustomLoadingWidget();
          },
          enableRotation: true,
        ),
      ),
    );
  }
}
