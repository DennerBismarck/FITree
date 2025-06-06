import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E7), // Fundo neutro
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
              const Text(
                "Welcome to FiTree",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF224B2F), // Verde escuro
                ),
              ),

              const SizedBox(height: 32),

              // CAMPO DE E-MAIL
              TextField(
                style: const TextStyle(color: Color(0xFF224B2F)),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Color(0x80224B2F)),
                  filled: true,
                  fillColor: Color(0xFFE5CFA2), // Bege suave
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
                style: const TextStyle(color: Color(0xFF224B2F)),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Color(0x80224B2F)),
                  filled: true,
                  fillColor: Color(0xFFE5CFA2),
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
                  onPressed: () {
                    // Ação de login
                    // Aqui você pode adicionar a lógica de autenticação
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF709255), // Verde médio
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
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Color(0xFF709255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
