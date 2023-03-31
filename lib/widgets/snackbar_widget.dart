import 'package:flutter/material.dart';
import 'package:vdo/theme/theme_color.dart';

class ShowSnackbar {
  snackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: ThemeColor.primary,
        content: Text(
          content,
          style: const TextStyle(color: ThemeColor.white),
        ),
      ),
    );
  }
}
