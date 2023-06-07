import 'package:flutter/material.dart';


class BusinessFilterByPopup extends StatelessWidget {
  const BusinessFilterByPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (c) =>
      [
        const PopupMenuItem(
          value: 1,
          child: Text('edit'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('delete'),
        ),
      ],
    );
  }
}
