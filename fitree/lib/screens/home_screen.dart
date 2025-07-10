import 'package:fitree/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart';
import 'login_screen.dart';
import 'workout_screen.dart';
import 'meal_screen.dart';
import 'water_screen.dart';
// import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  void handleMenuAction(String value) {
    switch (value) {
      case 'theme':
        Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Editar perfil ainda não implementado')),
        );
        break;
      case 'logout':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> screens = [
      const _HomeDashboard(),
      WorkoutScreen(),
      MealScreen(),
      WaterScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text('FiTree', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: Colors.white),
            onSelected: handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'theme', child: Text('Change theme')),
              const PopupMenuItem(value: 'edit', child: Text('Profile')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, _) {
          return value < screens.length
              ? screens[value]
              : const Center(child: Text('Tela não disponível'));
        },
      ),
      bottomNavigationBar: FitNavBar(itemSelectedCallback: (index) {
        selectedIndex.value = index;
      }),
    );
  }
}


class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome back, Denner!", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text("Here's your progress today:",
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          _buildCard("Workout", Icons.fitness_center,
              "Arms training: Incomplete", theme),
          const SizedBox(height: 12),
          _buildCard("Meals", Icons.restaurant, "2 of 3 meals logged", theme),
          const SizedBox(height: 12),
          _buildCard("Water", Icons.opacity, "1.2L of 2L goal", theme),
          const SizedBox(height: 12),
          _buildCard("Sleep mode", Icons.bed_outlined, "Sleep at 21:30", theme),
        ],
      ),
    );
  }
}

Widget _buildCard(
    String title, IconData icon, String subtitle, ThemeData theme) {
  return Card(
    color: theme.cardColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: theme.colorScheme.secondary),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
      },
    ),
  );
}
