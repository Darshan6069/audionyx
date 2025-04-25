import 'package:audionyx/presentation/widget/common_app_bar.dart';
import 'package:flutter/material.dart';

class FavouriteSongsScreen extends StatelessWidget {
  const FavouriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Favourite Songs'),
    );
  }
}
