import 'dart:convert';
import '../models/dish/dish.dart';
import 'package:hive/hive.dart';

class DishService {
  // TODO: [Dish] add your missing static methods here.
  static final String dbName = "dishes";
  static Box<Dish>? _box;

  /// fetch all Dish
  static Future<List<Dish>> all() async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    return _box!.values.toList();
  }

  /// fetch Dish by id
  static Future<Dish> get(String id) async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    return _box!.get(id)!;
  }

  /// add Dish
  static Future<Dish> add(Dish dish) async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    dish.id = await _box!.add(dish);
    await _box!.put(dish.id, dish);
    return dish;
  }

  /// update Dish
  static Future<Dish> update(Dish dish) async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    await _box!.put(dish.id, dish);
    return dish;
  }

  /// delete Dish
  static Future<Dish> delete(Dish dish) async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    await _box!.delete(dish.id);
    return dish;
  }

  /// delete selected Dishes
  static Future<List<Dish>> deleteSelected(List<Dish> dishes) async {
    // TODO: [Dish] api calls here
    _box ??= await Hive.openBox<Dish>(dbName);
    await _box!.deleteAll(dishes.map((e) => e.id));
    return dishes;
  }
}
