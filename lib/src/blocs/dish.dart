import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import '../models/dish/dish.dart';
import '../services/dish.dart';
import '../events/dish.dart';

class DishBloc {
  // TODO: [Dish] add your missing properties and methods here.

  /// the controller of DishBloc events
  BehaviorSubject<DishEvent> _controller =
      BehaviorSubject<DishEvent>.seeded(DishEvent.loaded);

  /// the stream of Dish events
  Stream<DishEvent> get stream => _controller.stream;

  /// the state variable of Dish
  List<Dish>? _state = [];

  /// the state getter of Dish
  List<Dish>? get state => _state;

  /// the current event of Dish stream
  DishEvent get event => _controller.value;

  /// the singleton
  static final DishBloc instance = DishBloc._();

  /// private constructor
  DishBloc._() {
    // TODO: [Dish] load and sync your data here
    fetchAll();
  }

  /// factory constructor, don't touch it
  factory DishBloc() {
    return instance;
  }

  /// fetches all Dish
  Future fetchAll() async {
    _controller.add(DishEvent.loading);
    _state = await DishService.all();
    _controller.add(DishEvent.loaded);
  }

  /// add account
  Future<void> add(Dish account) async {
    _controller.add(DishEvent.adding);
    try {
      await DishService.add(account);
      await fetchAll();
    } catch (e) {
      log("DishBlocAddError", error: e);
    }
    _controller.add(DishEvent.loaded);
  }

  /// update account
  Future<void> update(Dish account) async {
    _controller.add(DishEvent.updating);
    try {
      await DishService.update(account);
      await fetchAll();
    } catch (e) {
      log("DishBlocUpdateError", error: e);
    }
    _controller.add(DishEvent.loaded);
  }

  /// delete an account
  Future<void> delete(Dish account) async {
    _controller.add(DishEvent.deleting);
    try {
      await DishService.delete(account);
      await fetchAll();
    } catch (e) {
      log("DishBlocDeleteError", error: e);
    }
    _controller.add(DishEvent.loaded);
  }

  /// delete selected accounts
  Future<void> deleteSelected() async {
    _controller.add(DishEvent.deleting);
    try {
      await DishService.deleteSelected(
          _state?.where((element) => element.selected).toList() ?? []);
      await fetchAll();
    } catch (e) {
      log("DishBlocDeleteError", error: e);
    }
    _controller.add(DishEvent.loaded);
  }

  /// switch select of Dish
  void switchSelect(Dish dish) {
    dish.selected = !dish.selected;
    _controller.add(DishEvent.loaded);
  }
}
