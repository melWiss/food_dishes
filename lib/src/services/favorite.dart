import 'dart:convert';
import 'package:food_dishes/src/models/account/account.dart';

import '../models/favorite/favorite.dart';
import 'package:hive/hive.dart';

class FavoriteService {
  // TODO: [Favorite] add your missing static methods here.
  static final String dbName = "favorites";
  static Box<Favorite>? _box;

  /// fetch all Favorite
  static Future<List<Favorite>> all() async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    return _box!.values.toList();
  }

  /// fetch all Favorite by Account
  static Future<List<Favorite>> allByAccount(Account account) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    return _box!.values
        .where((element) => element.user!.id == account.id)
        .toList();
  }

  /// fetch Favorite by id
  static Future<Favorite> get(String id) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    return _box!.get(id)!;
  }

  /// add Favorite
  static Future<Favorite> add(Favorite favorite) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    try {
      _box!.values.firstWhere((element) =>
          element.user == favorite.user && element.dish == favorite.dish);
    } catch (e) {
      favorite.id = await _box!.add(favorite);
      await _box!.put(favorite.id, favorite);
    }
    return favorite;
  }

  /// update Favorite
  static Future<Favorite> update(Favorite favorite) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    await _box!.put(favorite.id, favorite);
    return favorite;
  }

  /// delete Favorite
  static Future<Favorite> delete(Favorite favorite) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    await _box!.delete(favorite.id);
    return favorite;
  }

  /// delete selected Favorites
  static Future<List<Favorite>> deleteSelected(List<Favorite> favorites) async {
    // TODO: [Favorite] api calls here
    _box ??= await Hive.openBox<Favorite>(dbName);
    await _box!.deleteAll(favorites.map((e) => e.id));
    return favorites;
  }
}
