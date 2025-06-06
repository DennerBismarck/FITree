import 'package:flutter/material.dart';
import 'routes/app_routes.dart';


void main() {
  runApp(const FiTreeApp());
}

class FiTreeApp extends StatelessWidget {
  const FiTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FiTree',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
