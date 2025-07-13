import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../controllers/data_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                'lib/assets/images/fitree_logo.png',
                height: 120,
              ),
              const SizedBox(height: 40),

              // TÍTULO
              Text(
                "Your Fitness Journey Starts Here",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // CAMPO DE E-MAIL
              TextField(
                style: TextStyle(color: theme.colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: theme.colorScheme.primary.withOpacity(0.5)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CAMPO DE SENHA
              TextField(
                obscureText: true,
                style: TextStyle(color: theme.colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: theme.colorScheme.primary.withOpacity(0.5)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BOTÃO DE LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final emailController = TextEditingController();
                    final passwordController = TextEditingController();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );

                    final success = await dataService.login(
                      emailController.text.trim(),
                      passwordController.text,
                    );

                    Navigator.of(context).pop(); // Remove loading dialog

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid email or password')),
                      );
                      return;
                    }
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // LINK DE CADASTRO
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
