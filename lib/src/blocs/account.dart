import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import '../models/account/account.dart';
import '../services/account.dart';
import '../events/account.dart';

class AccountBloc {
  // TODO: [Account] add your missing properties and methods here.

  /// the controller of AccountBloc events
  BehaviorSubject<AccountEvent> _controller =
      BehaviorSubject<AccountEvent>.seeded(AccountEvent.loaded);

  /// the stream of Account events
  Stream<AccountEvent> get stream => _controller.stream;

  /// the state variable of Account
  List<Account>? _state = [];

  /// the state getter of Account
  List<Account>? get state => _state;

  /// the current event of Account stream
  AccountEvent get event => _controller.value;

  /// the singleton
  static final AccountBloc instance = AccountBloc._();

  /// private constructor
  AccountBloc._() {
    // TODO: [Account] load and sync your data here
    fetchAll();
  }

  /// factory constructor, don't touch it
  factory AccountBloc() {
    return instance;
  }

  /// fetches all Account
  Future fetchAll() async {
    _controller.add(AccountEvent.loading);
    _state = await AccountService.all();
    _controller.add(AccountEvent.loaded);
  }

  /// add account
  Future<void> add(Account account) async {
    _controller.add(AccountEvent.adding);
    try {
      await AccountService.add(account);
      await fetchAll();
    } catch (e) {
      log("AccountBlocAddError", error: e);
    }
    _controller.add(AccountEvent.loaded);
  }

  /// update account
  Future<void> update(Account account) async {
    _controller.add(AccountEvent.updating);
    try {
      await AccountService.update(account);
      await fetchAll();
    } catch (e) {
      log("AccountBlocUpdateError", error: e);
    }
    _controller.add(AccountEvent.loaded);
  }

  /// switch select of account
  void switchSelect(Account account) {
    account.selected = !account.selected;
    print(account);
    _controller.add(AccountEvent.loaded);
  }

  /// delete an account
  Future<void> delete(Account account) async {
    _controller.add(AccountEvent.deleting);
    try {
      await AccountService.delete(account);
      await fetchAll();
    } catch (e) {
      log("AccountBlocDeleteError", error: e);
    }
    _controller.add(AccountEvent.loaded);
  }

  /// delete selected accounts
  Future<void> deleteSelected() async {
    _controller.add(AccountEvent.deleting);
    try {
      await AccountService.deleteSelected(
          _state?.where((element) => element.selected).toList() ?? []);
      await fetchAll();
    } catch (e) {
      log("AccountBlocDeleteError", error: e);
    }
    _controller.add(AccountEvent.loaded);
  }
}
