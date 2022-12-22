import 'dart:convert';

import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/dish/dish.dart';
import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  Account? user;

  @HiveField(2)
  Dish? dish;

  Favorite({
    this.id,
    this.user,
    this.dish,
  });
}
