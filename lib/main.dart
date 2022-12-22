import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/consts/routes.dart';
import 'package:food_dishes/src/events/authentication.dart';
import 'package:food_dishes/src/widgets/stream.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
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
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          routerConfig: routes,
        );
      },
    );
  }
}
