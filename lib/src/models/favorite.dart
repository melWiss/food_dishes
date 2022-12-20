import 'dart:convert';

import 'package:food_dishes/src/models/account.dart';
import 'package:food_dishes/src/models/dish.dart';

class Favorite {
  int? id;
  Account? user;
  Dish? dish;
  Favorite({
    this.id,
    this.user,
    this.dish,
  });

  Favorite copyWith({
    int? id,
    Account? user,
    Dish? dish,
  }) {
    return Favorite(
      id: id ?? this.id,
      user: user ?? this.user,
      dish: dish ?? this.dish,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user?.toMap(),
      'dish': dish?.toMap(),
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id']?.toInt(),
      user: map['user'] != null ? Account.fromMap(map['user']) : null,
      dish: map['dish'] != null ? Dish.fromMap(map['dish']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) =>
      Favorite.fromMap(json.decode(source));

  @override
  String toString() => 'Favorite(id: $id, user: $user, dish: $dish)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Favorite &&
        other.id == id &&
        other.user == user &&
        other.dish == dish;
  }

  @override
  int get hashCode => id.hashCode ^ user.hashCode ^ dish.hashCode;
}
