import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/dish/dish.dart';
import 'package:food_dishes/src/models/favorite/favorite.dart';

class AddFavoriteDialog extends StatefulWidget {
  const AddFavoriteDialog({
    super.key,
    this.favorite,
  });
  final Favorite? favorite;

  @override
  State<AddFavoriteDialog> createState() => _AddFavoriteDialogState();
}

class _AddFavoriteDialogState extends State<AddFavoriteDialog> {
  final _formKey = GlobalKey<FormState>();
  late Dish _selectedDish = widget.favorite?.dish ?? DishBloc().state!.first;
  late Account _selectedUser =
      widget.favorite?.user ?? AccountBloc().state!.first;
  AccountBloc _accountBloc = AccountBloc();
  DishBloc _dishBloc = DishBloc();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.favorite == null ? "Add" : "Update"} dish"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<Account>(
              value: _selectedUser,
              items: _accountBloc.state!
                  .map<DropdownMenuItem<Account>>(
                      (e) => DropdownMenuItem<Account>(
                            child: Text(e.email!),
                            value: e,
                          ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUser = value!;
                });
              },
            ),
            DropdownButton<Dish>(
              value: _selectedDish,
              items: _dishBloc.state!
                  .map<DropdownMenuItem<Dish>>((e) => DropdownMenuItem<Dish>(
                        child: Text(e.title!),
                        value: e,
                      ))
                  .toList(),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedDish = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (widget.favorite == null) {
                FavoriteBloc().add(Favorite(
                  user: _selectedUser,
                  dish: _selectedDish,
                ));
              } else {
                FavoriteBloc().update(Favorite(
                  id: widget.favorite!.id,
                  user: _selectedUser,
                  dish: _selectedDish,
                ));
              }
              Navigator.of(context)
                  .popUntil((route) => !route.hasActiveRouteBelow);
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
