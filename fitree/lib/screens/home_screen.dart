import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'meal_screen.dart';
import 'water_screen.dart';
import 'profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    _HomeDashboard(),
    //WorkoutScreen(),
   // MealScreen(),
   // WaterScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // fundo claro
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C5E4A), // verde escuro
        title: const Text(
          'FiTree',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
            //  Navigator.push(
             //   context,
             //   MaterialPageRoute(builder: (_) => const ProfileScreen()),
             // );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF6ABF4B), // verde claro
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            label: 'Water',
          ),
        ],
      ),
    );
  }
}


class _HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Here's your progress today:",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildCard("Workout", Icons.fitness_center, const Color(0xFF6ABF4B)),
          const SizedBox(height: 12),
          _buildCard("Meals", Icons.restaurant, const Color(0xFF6ABF4B)),
          const SizedBox(height: 12),
          _buildCard("Water", Icons.opacity, const Color(0xFF6ABF4B)),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color iconColor) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Ação específica aqui se desejar
        },
      ),
    );
  }
}
