import 'package:flutter/material.dart';
import 'package:technical_test/Styles/colors.dart';

void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(
        message!,
        style: TextStyle(color: AppColor.white),
      ),
      backgroundColor: AppColor.primaryColor));
}