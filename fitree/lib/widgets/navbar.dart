import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FitNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  const FitNavBar({required this.itemSelectedCallback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: state.value,
      onTap: (index) {
        state.value = index;
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
