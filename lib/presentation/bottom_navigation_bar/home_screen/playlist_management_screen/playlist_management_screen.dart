import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/playlist_management_screen/playlist_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/playlist_management_screen/widget/create_playlist_dialog_widget.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/playlist_management_screen/widget/playlist_tile_widget.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PlaylistManagementScreen extends StatefulWidget {
  final bool showAppBar; // Parameter to control AppBar visibility

  const PlaylistManagementScreen({super.key, this.showAppBar = true});

  @override
  State<PlaylistManagementScreen> createState() => _PlaylistManagementScreenState();
}

class _PlaylistManagementScreenState extends State<PlaylistManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistBlocCubit>().fetchPlaylists();
  }

  final TextEditingController _playlistNameController = TextEditingController();

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreatePlaylistDialogWidget(
            controller: _playlistNameController,
            onCreate: (playlistName) {
              // When creating a playlist, we'll handle the UI update in the BlocConsumer
              context.read<PlaylistBlocCubit>().createPlaylist(playlistName);
              _playlistNameController.clear();
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Responsive breakpoints based on main.dart
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    // Responsive measurements
    final horizontalPadding =
        isDesktop
            ? isTablet
                ? 24.0
                : 32.0
            : 16.0;
    final cardElevation = isDesktop ? 4.0 : 2.0;

    return BlocConsumer<PlaylistBlocCubit, PlaylistState>(
      listener: (context, state) {
        if (state is PlaylistFailure) {
          if (state.error.contains('Authentication token is missing')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: colorScheme.error),
            );
          }
        } else if (state is PlaylistSuccess && state.isNewPlaylistCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Playlist created successfully',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              backgroundColor: colorScheme.primary,
            ),
          );
          // The playlist is already included in the state.playlists array
          // We don't need to fetch again as the state is already updated
        }
      },
      builder: (context, state) {
        // Determine if we should show the FAB based on the state
        bool showFAB = true;
        if (state is PlaylistSuccess && state.playlists.isEmpty) {
          showFAB = false;
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar:
              widget.showAppBar
                  ? AppBar(
                    title: Text(
                      'My Playlists',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.surface.withOpacity(0.8),
                            theme.scaffoldBackgroundColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )
                  : null,
          floatingActionButton:
              showFAB
                  ? widget.showAppBar
                      ? FloatingActionButton(
                        onPressed: _showCreatePlaylistDialog,
                        tooltip: 'Create Playlist',
                        backgroundColor: colorScheme.primary,
                        child: Icon(Icons.add, color: colorScheme.onPrimary),
                      )
                      : null
                  : null,
          body: _buildBody(
            context,
            state,
            colorScheme,
            textTheme,
            horizontalPadding,
            cardElevation,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PlaylistState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double horizontalPadding,
    double cardElevation,
  ) {
    // Responsive layout
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    // Grid layout for larger screens
    final crossAxisCount = isDesktop ? 2 : 1;
    final childAspectRatio = isDesktop ? 4.0 : 3.5;

    if (state is PlaylistInitial || state is PlaylistLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    } else if (state is PlaylistSuccess) {
      if (state.playlists.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.queue_music, color: colorScheme.secondary, size: isMobile ? 64 : 80),
              const SizedBox(height: 16),
              Text(
                'No playlists yet',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first playlist!',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showCreatePlaylistDialog,
                icon: Icon(Icons.add, color: colorScheme.onPrimary),
                label: Text('Create Playlist', style: TextStyle(color: colorScheme.onPrimary)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 24,
                    vertical: isMobile ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ],
          ),
        );
      }

      // Use grid view for desktop and tablet layouts
      if (isDesktop) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.playlists.length,
            itemBuilder: (context, index) {
              final playlist = state.playlists[index];
              final title = playlist['name']?.toString() ?? 'Unknown Playlist';
              final playlistId = playlist['_id']?.toString() ?? '';

              return PlaylistTileWidget(
                title: title,
                playlistId: playlistId,
                onTap:
                    () => context.push(
                      context,
                      target: PlaylistSongsScreen(playlistId: playlistId, playlistName: title),
                    ),
                onDelete: () {
                  if (playlistId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Playlist ID is missing',
                          style: TextStyle(color: colorScheme.onError),
                        ),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                    return;
                  }
                  context.read<PlaylistBlocCubit>().deletePlaylist(playlistId);
                },
              );
            },
          ),
        );
      }

      // Use list view for mobile layout
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
        itemCount: state.playlists.length,
        itemBuilder: (context, index) {
          final playlist = state.playlists[index];
          final title = playlist['name']?.toString() ?? 'Unknown Playlist';
          final playlistId = playlist['_id']?.toString() ?? '';

          return PlaylistTileWidget(
            title: title,
            playlistId: playlistId,
            onTap:
                () => context.push(
                  context,
                  target: PlaylistSongsScreen(playlistId: playlistId, playlistName: title),
                ),
            onDelete: () {
              if (playlistId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Playlist ID is missing',
                      style: TextStyle(color: colorScheme.onError),
                    ),
                    backgroundColor: colorScheme.error,
                  ),
                );
                return;
              }
              context.read<PlaylistBlocCubit>().deletePlaylist(playlistId);
            },
          );
        },
      );
    } else if (state is PlaylistFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: isMobile ? 64 : 80),
            const SizedBox(height: 16),
            Text(
              state.error,
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PlaylistBlocCubit>().fetchPlaylists(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 24,
                  vertical: isMobile ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text('Retry', style: TextStyle(color: colorScheme.onPrimary)),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
