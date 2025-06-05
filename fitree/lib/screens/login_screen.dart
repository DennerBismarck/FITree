import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Enter'),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.home);
          },
        ),
      ),
    );
  }
}
