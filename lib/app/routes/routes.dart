import 'package:flutter/material.dart';

import '../../features/authentication/pages/home_page.dart';
import '../../features/authentication/pages/login.dart';
import '../../features/authentication/pages/otp_view.dart';
import '../../features/authentication/pages/sign_up.dart';


class AppRoutes {
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signUp:
        return MaterialPageRoute(builder: (context) => RegistrationPage());
      case login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case otp:
        final email = settings.arguments as String; // Extract email from arguments
        return MaterialPageRoute(
          builder: (context) => OTPView(email: email),
        );
      case home:
        return MaterialPageRoute(builder: (context) => Home());

      default:
        return MaterialPageRoute(builder: (context) => RegistrationPage());
    }
  }
}

