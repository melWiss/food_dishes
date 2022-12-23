import 'dart:io';

import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final Function() onLogout;
  LogoutDialog({
    required this.onLogout,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure? We will miss you."),
      actions: [
        TextButton(
            onPressed: () {
              onLogout();
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
