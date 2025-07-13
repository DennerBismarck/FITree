import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../controllers/data_service.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                "Create your FiTree account",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // NOME
              TextField(
                style: TextStyle(color: theme.colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.primary.withOpacity(0.5)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // EMAIL
              TextField(
                style: TextStyle(color: theme.colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.primary.withOpacity(0.5)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // SENHA
              TextField(
                obscureText: true,
                style: TextStyle(color: theme.colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.primary.withOpacity(0.5)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BOTÃO CADASTRAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final nameController = TextEditingController();
                    final emailController = TextEditingController();
                    final passwordController = TextEditingController();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      await dataService.registrarUsuario(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      Navigator.of(context).pop(); // Remove loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Registration successful!')),
                      );
                    } on Exception catch (e) {
                      Navigator.of(context).pop(); // Remove loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
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
                    "Sign Up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // VOLTAR PARA LOGIN
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Log in",
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
