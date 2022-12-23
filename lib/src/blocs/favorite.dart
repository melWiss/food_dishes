import 'dart:developer';

import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:rxdart/rxdart.dart';
import '../models/favorite/favorite.dart';
import '../services/favorite.dart';
import '../events/favorite.dart';

class FavoriteBloc {
  // TODO: [Favorite] add your missing properties and methods here.

  /// the controller of FavoriteBloc events
  BehaviorSubject<FavoriteEvent> _controller =
      BehaviorSubject<FavoriteEvent>.seeded(FavoriteEvent.loaded);

  /// the stream of Favorite events
  Stream<FavoriteEvent> get stream => _controller.stream;

  /// the state variable of Favorite
  List<Favorite>? _state = [];

  /// the state getter of Favorite
  List<Favorite>? get state => _state;

  /// the current event of Favorite stream
  FavoriteEvent get event => _controller.value;

  /// the singleton
  static final FavoriteBloc instance = FavoriteBloc._();

  /// private constructor
  FavoriteBloc._() {
    // TODO: [Favorite] load and sync your data here
    fetchAll();
  }

  /// factory constructor, don't touch it
  factory FavoriteBloc() {
    return instance;
  }

  /// fetches all Favorite
  Future fetchAll() async {
    _controller.add(FavoriteEvent.loading);
    if (AuthenticationBloc().state!.role == Role.admin) {
      _state = await FavoriteService.all();
    } else {
      _state = await FavoriteService.allByAccount(AuthenticationBloc().state!);
    }
    _controller.add(FavoriteEvent.loaded);
  }

  /// add favorite
  Future<void> add(Favorite favorite) async {
    _controller.add(FavoriteEvent.adding);
    try {
      if (AuthenticationBloc().state!.role != Role.admin) {
        favorite.user = AuthenticationBloc().state;
      }
      await FavoriteService.add(favorite);
      await fetchAll();
    } catch (e) {
      log("FavoriteBlocAddError", error: e);
    }
    _controller.add(FavoriteEvent.loaded);
  }

  /// update favorite
  Future<void> update(Favorite favorite) async {
    _controller.add(FavoriteEvent.updating);
    try {
      if (AuthenticationBloc().state!.role != Role.admin) {
        favorite.user = AuthenticationBloc().state;
      }
      await FavoriteService.update(favorite);
      await fetchAll();
    } catch (e) {
      log("FavoriteBlocUpdateError", error: e);
    }
    _controller.add(FavoriteEvent.loaded);
  }

  /// delete an favorite
  Future<void> delete(Favorite favorite) async {
    _controller.add(FavoriteEvent.deleting);
    try {
      await FavoriteService.delete(favorite);
      await fetchAll();
    } catch (e) {
      log("FavoriteBlocDeleteError", error: e);
    }
    _controller.add(FavoriteEvent.loaded);
  }

  /// delete selected favorites
  Future<void> deleteSelected() async {
    _controller.add(FavoriteEvent.deleting);
    try {
      await FavoriteService.deleteSelected(_state
              ?.where(
                (element) => element.selected,
              )
              .toList() ??
          []);
      await fetchAll();
    } catch (e) {
      log("FavoriteBlocDeleteError", error: e);
    }
    _controller.add(FavoriteEvent.loaded);
  }

  /// switch select of Favorite
  void switchSelect(Favorite favorite) {
    favorite.selected = !favorite.selected;
    _controller.add(FavoriteEvent.loaded);
  }
}
