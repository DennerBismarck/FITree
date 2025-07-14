import 'package:fitree/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme_notifier.dart';
import 'login_screen.dart';
import 'workout_screen.dart';
import 'meal_screen.dart';
import 'water_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  ProgressModel dailyProgress = ProgressModel(
    workoutCompleted: false,
    mealsLogged: 2,
    totalMeals: 3,
    waterConsumed: 1.2,
    waterGoal: 2.0,
    sleepTime: '21:30',
  );

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
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM').format(now);

    final List<Widget> screens = [
      _HomeDashboard(progress: dailyProgress),
      WorkoutScreen(),
      MealScreen(),
      WaterScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá, Usuário!', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
            Text(formattedDate, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'theme', child: Text('Alterar tema')),
              const PopupMenuItem(value: 'edit', child: Text('Editar perfil')),
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
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
  final ProgressModel progress;
  
  const _HomeDashboard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage = (progress.mealsLogged / progress.totalMeals) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção de progresso diário
          Text("Seu progresso hoje", style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildProgressCard(context),
          const SizedBox(height: 24),
          
          // Seção de atividades rápidas
          Text("Atividades rápidas", style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildQuickActionCard(
                context,
                "Treino",
                Icons.fitness_center,
                progress.workoutCompleted ? "Concluído" : "Pendente",
                progress.workoutCompleted ? Colors.green : Colors.orange,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  WorkoutScreen())),
              ),
              _buildQuickActionCard(
                context,
                "Refeições",
                Icons.restaurant,
                "${progress.mealsLogged}/${progress.totalMeals}",
                progress.mealsLogged == progress.totalMeals ? Colors.green : Colors.orange,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MealScreen())),
              ),
              _buildQuickActionCard(
                context,
                "Água",
                Icons.opacity,
                "${progress.waterConsumed}L/${progress.waterGoal}L",
                progress.waterConsumed >= progress.waterGoal ? Colors.green : Colors.blue,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterScreen())),
              ),
              _buildQuickActionCard(
                context,
                "Sono",
                Icons.bedtime,
                progress.sleepTime,
                Colors.purple,
                () {},
              ),
            ],
          ),
          
          // Seção de dicas
          const SizedBox(height: 24),
          Text("Dica do dia", style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildTipCard(
            "Beba água regularmente",
            "Manter-se hidratado ajuda no desempenho físico e mental.",
            Icons.opacity,
            theme),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress.mealsLogged / progress.totalMeals,
              backgroundColor: theme.colorScheme.surfaceVariant,
              color: theme.colorScheme.primary,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progresso diário", style: theme.textTheme.titleMedium),
                Text("${(progress.mealsLogged / progress.totalMeals * 100).toStringAsFixed(0)}%", 
                    style: theme.textTheme.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context,
      String title,
      IconData icon,
      String status,
      Color statusColor,
      VoidCallback onTap) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(status, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content, IconData icon, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.secondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(content, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProgressModel {
  final bool workoutCompleted;
  final int mealsLogged;
  final int totalMeals;
  final double waterConsumed;
  final double waterGoal;
  final String sleepTime;

  ProgressModel({
    required this.workoutCompleted,
    required this.mealsLogged,
    required this.totalMeals,
    required this.waterConsumed,
    required this.waterGoal,
    required this.sleepTime,
  });
}