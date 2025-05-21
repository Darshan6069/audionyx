import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/constants/theme_color.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfilePicture({super.key, required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final borderWidth =
        isDesktop
            ? 3.0
            : isTablet
            ? 2.5
            : 2.0;
    final blurRadius =
        isDesktop
            ? 10.0
            : isTablet
            ? 9.0
            : 8.0;
    final iconSize = size * 0.5; // Scales with size prop

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ThemeColor.white.withOpacity(0.2), width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: blurRadius,
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
          placeholder:
              (context, url) => Container(
                color: ThemeColor.grey,
                child: Center(child: CircularProgressIndicator(color: ThemeColor.white)),
              ),
          errorWidget:
              (context, url, error) => Container(
                color: ThemeColor.grey,
                child: Icon(Icons.person, color: ThemeColor.white, size: iconSize),
              ),
        ),
      ),
    );
  }
}
