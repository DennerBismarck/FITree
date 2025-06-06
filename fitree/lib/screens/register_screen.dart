import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E7), // Fundo neutro
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // LOGO
                Image.asset(
                  'lib/assets/images/fitree_logo.png',
                  height: 100,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create your FiTree account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF224B2F), // Verde escuro
                  ),
                ),

                const SizedBox(height: 32),

                // NOME
                TextField(
                  style: const TextStyle(color: Color(0xFF224B2F)),
                  decoration: InputDecoration(
                    hintText: "Full Name",
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

                // EMAIL
                TextField(
                  style: const TextStyle(color: Color(0xFF224B2F)),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Color(0x80224B2F)),
                    filled: true,
                    fillColor: Color(0xFFE5CFA2),
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

                // BOTÃO CADASTRAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aqui você pode adicionar a lógica de cadastro
                      // Por enquanto, apenas redireciona para a tela inicial
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
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // VOLTAR PARA LOGIN
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(color: Color(0xFF709255)),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
