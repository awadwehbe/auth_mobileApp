import 'package:flutter/material.dart';

import 'app/routes/routes.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.signUp, // Use the checkAuth route as the initial route
      onGenerateRoute: AppRoutes.generateRoute, // Use the generateRoute method for dynamic routes
    );
  }
}