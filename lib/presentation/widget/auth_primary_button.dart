import 'package:audionyx/core/constants/theme_color.dart';
import 'package:flutter/material.dart';


class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, 49),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        backgroundColor: ThemeColor.greenColor,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontFamily: "AB", fontSize: 16, color: ThemeColor.blackColor),
      ),
    );
  }
}

class AuthOutlinedButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  const AuthOutlinedButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, 49),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        side: const BorderSide(width: 1, color: ThemeColor.lightGrey),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(iconPath),
          Text(
            label,
            style: const TextStyle(fontFamily: "AB", fontSize: 16, color: ThemeColor.whiteColor),
          ),
          const SizedBox(height: 18, width: 18),
        ],
      ),
    );
  }
}
