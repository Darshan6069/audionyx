import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/theme_color.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfilePicture({super.key, required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ThemeColor.white.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: ThemeColor.grey,
            child: const Center(
              child: CircularProgressIndicator(color: ThemeColor.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: ThemeColor.grey,
            child: const Icon(Icons.person, color: ThemeColor.white, size: 50),
          ),
        ),
      ),
    );
  }
}