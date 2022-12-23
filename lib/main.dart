import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/consts/routes.dart';
import 'package:food_dishes/src/events/authentication.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/dish/dish.dart';
import 'package:food_dishes/src/models/favorite/favorite.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:food_dishes/src/widgets/error_widget.dart';
import 'package:food_dishes/src/widgets/stream.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  ErrorWidget.builder = (details) => WErrorWidget(exception: details);
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(DishAdapter());
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(RoleAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamWidget<AuthenticationEvent>(
      stream: AuthenticationBloc().stream,
      widget: (context, data) {
        if (data == AuthenticationEvent.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: MaterialColor(
                Colors.black.value,
                const {
                  50: Colors.black,
                  100: Colors.black,
                  200: Colors.black,
                  300: Colors.black,
                  400: Colors.black,
                  500: Colors.black,
                  600: Colors.black,
                  700: Colors.black,
                  800: Colors.black,
                  900: Colors.black,
                },
              ),
              useMaterial3: true),
          routerConfig: routes,
        );
      },
    );
  }
}
