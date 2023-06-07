import 'package:flutter/material.dart';
import 'package:technical_test/Styles/colors.dart';

Widget customButton(
    {VoidCallback? tap,
      bool? status = false,
      String? text = 'Save',
      BuildContext? context}) {
  return GestureDetector(
    onTap: status == true ? null : tap,
    child: Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == false ? AppColor.primaryColor : AppColor.grey,
          borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context!).size.width,
      child: Text(
        status == false ? text! : 'Please wait...',
        style: const TextStyle(color: AppColor.white, fontSize: 18),
      ),
    ),
  );
}