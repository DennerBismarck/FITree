import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../controllers/data_service.dart'; // ajuste o caminho se necessário

class FitNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  const FitNavBar({required this.itemSelectedCallback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = useListenable(dataService.selectedIndex);

    return BottomNavigationBar(
      currentIndex: selectedIndex.value,
      onTap: (index) {
        dataService.onBottomNavTapped(index);
        itemSelectedCallback(index);
      },
      selectedItemColor: theme.colorScheme.secondary,
      unselectedItemColor: Colors.grey,
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Meals'),
        BottomNavigationBarItem(icon: Icon(Icons.opacity), label: 'Water'),
      ],
    );
  }
}
