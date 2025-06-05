import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FiTreeApp());
}

class FiTreeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FiTree',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
