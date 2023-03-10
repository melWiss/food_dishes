import 'dart:io';

import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final Function() onDelete;
  DeleteDialog({
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      actions: [
        TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context)
                  .popUntil((route) => !route.hasActiveRouteBelow);
            },
            child: Text("Yes")),
        TextButton(
          onPressed: () => Navigator.of(context)
              .popUntil((route) => !route.hasActiveRouteBelow),
          child: Text("No"),
        ),
      ],
    );
  }
}
