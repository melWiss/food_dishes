import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/models/account/account.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add user"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email", hintText: "example@mail.com"),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Email cannot be empty.";
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: "Password", hintText: "******"),
                validator: (value) {
                  if ((value?.isEmpty ?? true) || ((value?.length ?? 0) < 6)) {
                    return "Password should be 6 characters minimum.";
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                AccountBloc().add(Account(
                  email: _emailController.text,
                  password: _passwordController.text,
                ));
                Navigator.of(context)
                    .popUntil((route) => !route.hasActiveRouteBelow);
              }
            },
            child: Text("Submit")),
        TextButton(
          onPressed: () => Navigator.of(context)
              .popUntil((route) => !route.hasActiveRouteBelow),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
