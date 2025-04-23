import 'package:flutter/material.dart';
import '../../core/constants/theme_color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomTextField(
      { super.key, required this.hintText, this.obscureText = false, this.controller, this.suffixIcon, this.onSuffixTap,});

  @override Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: ThemeColor.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: ThemeColor.grey, fontSize: 16),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeColor.grey),),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeColor.white),),
        suffixIcon: suffixIcon != null ? IconButton(
          icon: Icon(suffixIcon, color: ThemeColor.grey),
          onPressed: onSuffixTap,) : null,),);
  }
}