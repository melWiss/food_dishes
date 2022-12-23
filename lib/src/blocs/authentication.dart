import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:rxdart/rxdart.dart';
import '../services/authentication.dart';
import '../events/authentication.dart';

class AuthenticationBloc {
  // TODO: [Authentication] add your missing properties and methods here.

  /// the controller of AuthenticationBloc events
  BehaviorSubject<AuthenticationEvent> _controller =
      BehaviorSubject<AuthenticationEvent>.seeded(AuthenticationEvent.loading);

  /// the stream of Authentication events
  Stream<AuthenticationEvent> get stream => _controller.stream;

  /// the state variable of Authentication
  Account? _state;

  /// the state getter of Authentication
  Account? get state => _state;

  /// the current event of Authentication stream
  AuthenticationEvent get event => _controller.value;

  /// the singleton
  static final AuthenticationBloc instance = AuthenticationBloc._();

  /// private constructor
  AuthenticationBloc._() {
    // TODO: [Authentication] load and sync your data here
    fetchAll();
  }

  /// factory constructor, don't touch it
  factory AuthenticationBloc() {
    return instance;
  }

  /// fetches all Authentication
  Future<void> fetchAll() async {
    _controller.add(AuthenticationEvent.loading);
    try {
      _state = await AuthenticationService.load();
      _controller.add(AuthenticationEvent.loggedIn);
    } catch (e) {
      _controller.add(AuthenticationEvent.loggedOut);
    }
  }

  /// login to the app
  Future<void> login(String email, String password) async {
    _controller.add(AuthenticationEvent.loggingIn);
    try {
      _state = await AuthenticationService.login(email, password);
      _controller.add(AuthenticationEvent.loggedIn);
      DishBloc().fetchAll();
      FavoriteBloc().fetchAll();
    } catch (e) {
      _controller.add(AuthenticationEvent.errorLogin);
      _controller.add(AuthenticationEvent.loggedOut);
    }
  }

  /// logout from the app
  Future<void> logout() async {
    _controller.add(AuthenticationEvent.loggingOut);
    try {
      await AuthenticationService.logout();
      _state = null;
      _controller.add(AuthenticationEvent.loggedOut);
    } catch (e) {
      _controller.add(AuthenticationEvent.loggedIn);
    }
  }
}
