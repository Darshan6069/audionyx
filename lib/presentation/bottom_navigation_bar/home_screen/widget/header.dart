import 'package:audionyx/core/constants/app_image.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';

import '../playlist_management_screen/playlist_management_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppImage.logo, height: 40, color: Theme.of(context).iconTheme.color),
        IconButton(
          icon: Icon(Icons.queue_music, color: Theme.of(context).iconTheme.color),
          onPressed: () => context.push(
            context,
            target: const PlaylistManagementScreen(showAppBar: true),
          ),
        ),
      ],
    );
  }
}