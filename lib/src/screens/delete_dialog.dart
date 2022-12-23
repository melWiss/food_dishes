import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/dish/dish.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

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
