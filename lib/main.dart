import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'theme/theme.dart';
import 'theme/theme_notifier.dart';
import 'screens/login_screen.dart';
import 'routes/app_routes.dart';
import 'controllers/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa FFI do SQFlite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dataService = DataService();
  await dataService.inicializarBanco(); // Inicializa banco antes do runApp

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier(false)),
        Provider<DataService>.value(value: dataService), // Correto!
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'FITree',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
