import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/events/authentication.dart';
import 'package:food_dishes/src/widgets/stream.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});
  static const String path = "/";

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationBloc _bloc = AuthenticationBloc();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorAuth = "";

  @override
  void initState() {
    // TODO: implement initState
    _bloc.stream.listen((event) {
      if (event == AuthenticationEvent.errorLogin) {
        _errorAuth = "Email or password are incorrect.";
      } else if (event == AuthenticationEvent.loggingIn) {
        _errorAuth = "";
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamWidget<AuthenticationEvent>(
          stream: _bloc.stream,
          widget: (context, event) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 400,
                maxWidth: 400,
                minHeight: 400,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Sign in",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: "Email", hintText: "example@mail.com"),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Email cannot be empty.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password", hintText: "******"),
                          validator: (value) {
                            if ((value?.isEmpty ?? true) ||
                                ((value?.length ?? 0) < 6)) {
                              return "Password should be 6 characters minimum.";
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: event == AuthenticationEvent.loggedOut
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _bloc.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  }
                                : null,
                            child: event == AuthenticationEvent.loggedOut
                                ? Text("Sign In")
                                : Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ),
                        ),
                        Text(
                          _errorAuth,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
