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
      return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
    } else if (isFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage ?? 'Unable to load items',
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Retry',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
          ],
        ),
      );
    } else if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
