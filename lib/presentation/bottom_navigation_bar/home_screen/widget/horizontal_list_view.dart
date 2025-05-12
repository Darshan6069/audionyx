import 'package:audionyx/core/constants/theme_color.dart';
import 'package:flutter/material.dart';

class HorizontalListView<T> extends StatelessWidget {
  final bool isLoading;
  final bool isFailed;
  final String? errorMessage;
  final List<T> items;
  final String emptyMessage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final VoidCallback? onRetry;

  const HorizontalListView({
    super.key,
    required this.isLoading,
    required this.isFailed,
    this.errorMessage,
    required this.items,
    required this.emptyMessage,
    required this.itemBuilder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: ThemeColor.white),
      );
    } else if (isFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage ?? 'Unable to load items',
              style: const TextStyle(color: ThemeColor.white),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(color: ThemeColor.white),
                ),
              ),
          ],
        ),
      );
    } else if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: ThemeColor.white),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder:
          (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
