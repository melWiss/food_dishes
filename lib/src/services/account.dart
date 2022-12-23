import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../models/account/account.dart';
import 'package:hive/hive.dart';

class AccountService {
  // TODO: [Account] add your missing static methods here.
  static final String dbName = "accounts";
  static Box<Account>? _box;

  /// fetch all Account
  static Future<List<Account>> all() async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    return _box!.values.toList();
  }

  /// fetch Account by id
  static Future<Account> get(String id) async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    Account account = _box!.get(id)!;
    return account;
  }

  /// add Account
  static Future<Account> add(Account account) async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    account.password =
        String.fromCharCodes(md5.convert(account.password!.codeUnits).bytes);
    account.id = await _box!.add(account);
    await _box!.put(account.id, account);
    return account;
  }

  /// update Account
  static Future<Account> update(Account account) async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    account.password =
        String.fromCharCodes(md5.convert(account.password!.codeUnits).bytes);
    await _box!.put(account.id, account);
    return account;
  }

  /// delete Account
  static Future<Account> delete(Account account) async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    await _box!.delete(account.id);
    return account;
  }

  /// delete selected Accounts
  static Future<List<Account>> deleteSelected(List<Account> accounts) async {
    // TODO: [Account] api calls here
    _box ??= await Hive.openBox<Account>(dbName);
    await _box!.deleteAll(accounts.map((e) => e.id));
    return accounts;
  }
}
