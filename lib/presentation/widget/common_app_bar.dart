import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/theme_color.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CommonAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: 90,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      // style:  TextStyle(
      //     color: ThemeColors.black,
      //     fontFamily: Strings.uberFont,
      //     fontSize: 24,
      //     fontWeight: FontWeight.w500)),
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(CupertinoIcons.back, color: Colors.white, size: 26),
      ),
      actions: actions,
      backgroundColor: ThemeColor.greenColor,
      elevation: 4.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
