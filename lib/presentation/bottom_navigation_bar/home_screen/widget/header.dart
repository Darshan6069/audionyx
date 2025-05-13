import 'package:audionyx/core/constants/app_image.dart';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../playlist_management_screen/playlist_management_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppImage.logo, height: 40, color: Theme.of(context).iconTheme.color),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.queue_music, color: Theme.of(context).iconTheme.color),
              onPressed: () => context.push(
                context,
                target: const PlaylistManagementScreen(showAppBar: true),
              ),
            ),
            BlocProvider(
              create: (context) => LoginBlocCubit(),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  onPressed: () {
                    final userId = AppStrings.secureStorage.read(
                      key: 'userId',
                    );
                    context.push(
                      context,
                      target: UserProfileScreen(userId: userId.toString()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}