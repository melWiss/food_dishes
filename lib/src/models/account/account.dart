import 'dart:convert';

import 'package:hive/hive.dart';
import '../role/role.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? password;

  @HiveField(3)
  Role? role;

  Account({
    this.id,
    this.email,
    this.password,
    this.role,
  });
}
