import 'package:hive/hive.dart';

part 'role.g.dart';

@HiveType(typeId: 3)
enum Role {
  @HiveField(0)
  user,

  @HiveField(1)
  admin,
}
