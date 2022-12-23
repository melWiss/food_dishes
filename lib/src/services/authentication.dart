import 'dart:convert';
import 'package:food_dishes/src/consts/consts.dart';
import 'package:food_dishes/src/models/account/account.dart';

import 'package:crypto/crypto.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  // TODO: [Authentication] add your missing static methods here.
  static final String dbName = "accounts";
  static Box<Account>? _box;

  /// load form cache
  static Future<Account> load() async {
    _box ??= await Hive.openBox<Account>(dbName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("user_id")!;
    return _box!.get(user_id)!;
  }

  /// login
  static Future<Account> login(String email, String password) async {
    _box ??= await Hive.openBox<Account>(dbName);
    // String hashedPass = BCrypt.hashpw(password, hashSalt);
    String hashedPass =
        String.fromCharCodes(md5.convert(password.codeUnits).bytes);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Account account = _box!.values.firstWhere((element) =>
          element.email == email && element.password == hashedPass);
      await prefs.setInt("user_id", account.id!);
      return account;
    } catch (e) {
      if (_box!.isEmpty) {
        Account account = Account(
          email: email,
          password: hashedPass,
          role: Role.admin,
        );
        account.id = await _box!.add(account);
        await prefs.setInt("user_id", account.id!);
        await _box!.put(account.id, account);
        return account;
      } else {
        rethrow;
      }
    }
  }

  /// logout
  static Future<void> logout() async {
    _box ??= await Hive.openBox<Account>(dbName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
