import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/user_profile_screen/profile_picture.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/user_profile_screen/upload_song_screen/add_songs_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../repository/bloc/auth_bloc_cubit/google_auth_bloc_cubit/google_auth_bloc_cubit.dart';
import '../../../repository/bloc/theme_cubit/theme_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Map<String, dynamic> _userData;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _userData = {'name': 'John Doe', 'profilePicture': 'https://via.placeholder.com/150'};
  }

  Future<String?> _getAuthType() async {
    return await _storage.read(key: 'authType');
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final verticalSpacing =
        isDesktop
            ? 40.0
            : isTablet
            ? 30.0
            : 20.0;
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final nameFontSize =
        isDesktop
            ? 32.0
            : isTablet
            ? 30.0
            : 28.0;
    final buttonFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final iconSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;
    final profilePictureSize =
        isDesktop
            ? 180.0
            : isTablet
            ? 160.0
            : 140.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBlocCubit>(create: (context) => LoginBlocCubit()),
        BlocProvider<GoogleLoginBlocCubit>(create: (context) => GoogleLoginBlocCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Profile',
                style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: verticalSpacing),
                    ProfilePicture(imageUrl: _userData['profilePicture'], size: profilePictureSize),
                    SizedBox(height: verticalSpacing * 0.5),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: Text(
                            _userData['name'],
                            style: TextStyle(
                              fontSize: nameFontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: verticalSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          _buildActionButton(
                            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            label: 'Toggle ${isDarkMode ? "Light" : "Dark"} Mode',
                            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                            fontSize: buttonFontSize,
                            iconSize: iconSize,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.download,
                            label: 'Downloads',
                            onPressed:
                                () => context.push(context, target: const DownloadedSongsScreen()),
                            fontSize: buttonFontSize,
                            iconSize: iconSize,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.add,
                            label: 'Add Song',
                            onPressed: () => context.push(context, target: const AddSongsScreen()),
                            fontSize: buttonFontSize,
                            iconSize: iconSize,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.logout,
                            label: 'Logout',
                            onPressed: () async {
                              final authType = await _getAuthType();
                              if (authType == 'google') {
                                await context.read<GoogleLoginBlocCubit>().signOut();
                              } else {
                                await context.read<LoginBlocCubit>().logout();
                              }
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Logged out')));
                              context.pushAndRemoveUntil(context, target: const LoginScreen());
                            },
                            fontSize: buttonFontSize,
                            iconSize: iconSize,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double fontSize,
    required double iconSize,
  }) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0)
            : isTablet
            ? const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: buttonPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
