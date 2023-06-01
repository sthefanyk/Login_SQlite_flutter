import 'package:flutter/material.dart';
import 'package:login_with_sqllite/model/user_model.dart';
import 'package:login_with_sqllite/screen/login_form.dart';
import 'package:login_with_sqllite/screen/signup_form.dart';
import 'package:login_with_sqllite/screen/update_form.dart';
import 'package:login_with_sqllite/screen/admin_home.dart';

class RoutesApp {
  static const home = '/';
  static const loginSgnup = '/loginSignup';
  static const loginUpdate = '/loginUpdate';
  static const adminPage = '/adminPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const LoginForm());

      case loginSgnup:
        return MaterialPageRoute(builder: (context) => const SignUp());

      case loginUpdate:
        if (arguments is UserModel) {
          return MaterialPageRoute(
            // builder: (context) => UdpateUser(arguments),
            builder: (context) => const UpdateUser(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }
      case adminPage:
        if (arguments is UserModel) {
          return MaterialPageRoute(
            // builder: (context) => UdpateUser(arguments),
            builder: (context) => const AdminPage(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
