import 'dart:convert';

import 'package:hive/hive.dart';

part 'dish.g.dart';

@HiveType(typeId: 1)
class Dish extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? imagePath;

  Dish({
    this.id,
    this.title,
    this.description,
    this.imagePath,
  });
}
