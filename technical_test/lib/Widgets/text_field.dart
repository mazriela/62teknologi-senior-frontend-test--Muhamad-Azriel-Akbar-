import 'package:flutter/material.dart';
import 'package:technical_test/Styles/colors.dart';

Widget customTextField(
    {String? title,
      String? hint,
      TextEditingController? controller,
      int? maxLines = 1}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.lightGrey,
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,


          decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        ),
      )
    ],
  );
}