import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/workout_screen.dart';
import '../screens/meal_screen.dart';
import '../screens/water_screen.dart';
import '../screens/sleep_screen.dart';
import '../screens/report_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const workout = '/workout';
  static const meal = '/meal';
  static const water = '/water';
  static const sleep = '/sleep';
  static const report = '/report';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    register: (_) => const SignUpScreen(),
    home: (_) => HomeScreen(),
  //  profile: (_) => ProfileScreen(),
  //  workout: (_) => WorkoutScreen(),
  //  meal: (_) => MealScreen(),
  //  water: (_) => WaterScreen(),
  //  sleep: (_) => SleepScreen(),
  //  report: (_) => ReportScreen(),
  };
}
