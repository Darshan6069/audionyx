import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String searchQuery;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final height =
        isDesktop
            ? 56.0
            : isTablet
            ? 52.0
            : 48.0;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 16.0;
    final verticalPadding = isDesktop || isTablet ? 12.0 : 8.0;
    final fontSize =
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

    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: fontSize - 2),
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color, size: iconSize),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: theme.iconTheme.color, size: iconSize),
                    onPressed: onClear,
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: height / 4),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
