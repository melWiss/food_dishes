import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/events/authentication.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:food_dishes/src/screens/admin.dart';
import 'package:food_dishes/src/screens/authentication.dart';
import 'package:food_dishes/src/screens/user.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        if (AuthenticationBloc().event != AuthenticationEvent.loggedIn) {
          return AuthenticationScreen();
        }

        if (AuthenticationBloc().state!.role == Role.admin) {
          return AdminScreen();
        } else {
          return UserScreen();
        }
      },
    ),
  ],
);
