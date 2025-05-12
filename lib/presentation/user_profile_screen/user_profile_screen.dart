import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/presentation/user_profile_screen/upload_song_screen/add_songs_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/theme_color.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'profilePicture': 'https://via.placeholder.com/150',
    'followers': 123,
    'following': 456,
  };

  // Mock theme state (replace with actual theme provider if available)
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth < 360 ? 0.9 : 1.0;
    final profilePicSize = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ThemeColor.greenColor, ThemeColor.darkBackground],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Profile Picture
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _userData['profilePicture'],
                  width: profilePicSize,
                  height: profilePicSize,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: ThemeColor.grey,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ThemeColor.white,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: ThemeColor.grey,
                        child: const Icon(
                          Icons.person,
                          color: ThemeColor.white,
                          size: 50,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                _userData['name'],
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 24 * fontScale,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              const SizedBox(height: 8),
              // Followers/Following
              Text(
                '${_userData['followers']} Followers • ${_userData['following']} Following',
                style: TextStyle(
                  color: ThemeColor.grey,
                  fontSize: 14 * fontScale,
                ),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        label: 'Toggle ${_isDarkMode ? "Light" : "Dark"} Mode',
                        color: ThemeColor.greenColor,
                        onPressed:
                            () => setState(() => _isDarkMode = !_isDarkMode),
                        fontScale: fontScale,
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.download,
                        label: 'Downloads',
                        color: ThemeColor.greenColor,
                        onPressed:
                            () => context.push(context, target: DownloadedSongsScreen()),
                        fontScale: fontScale,
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.add,
                        label: 'Add Song',
                        color: ThemeColor.greenColor,
                        onPressed:
                            () => context.push(context, target: AddSongsScreen()),
                        fontScale: fontScale,
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.logout,
                        label: 'Logout',
                        color: ThemeColor.grey,
                        onPressed: () {
                          context.read<LoginBlocCubit>().logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out')),
                          );
                          context.pushAndRemoveUntil(
                            context,
                            target: LoginScreen(),
                          );
                        },
                        fontScale: fontScale,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an action button with glassmorphism and scale animation.
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required double fontScale,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 24 * fontScale),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: ThemeColor.white,
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w600,
                      shadows: const [
                        Shadow(blurRadius: 2, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
