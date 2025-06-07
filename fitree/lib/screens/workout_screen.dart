// screens/workout_screen.dart
import 'package:flutter/material.dart';
import '../models/treino_model.dart';
import 'workout_details_screen.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<TreinoModel> treinos = [
    TreinoModel(
      titulo: "Treino A - Peito e Tríceps",
      completo: false,
      exercicios: [
        {"nome": "Supino Reto", "series": "4x10", "descanso": "60s"},
        {"nome": "Supino Inclinado", "series": "3x12", "descanso": "60s"},
        {"nome": "Crossover", "series": "3x15", "descanso": "45s"},
        {"nome": "Tríceps Pulley", "series": "4x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Costas e Bíceps",
      completo: true,
      exercicios: [
        {"nome": "Barra Fixa", "series": "3x10", "descanso": "60s"},
        {"nome": "Remada Curvada", "series": "4x10", "descanso": "60s"},
        {"nome": "Rosca Direta", "series": "3x12", "descanso": "45s"},
        {"nome": "Rosca Martelo", "series": "3x12", "descanso": "45s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino C - Pernas",
      completo: false,
      exercicios: [
        {"nome": "Agachamento Livre", "series": "4x8", "descanso": "90s"},
        {"nome": "Leg Press", "series": "3x10", "descanso": "60s"},
        {"nome": "Cadeira Extensora", "series": "3x15", "descanso": "45s"},
        {"nome": "Mesa Flexora", "series": "3x12", "descanso": "60s"},
      ],
    ),
  ];

  void _adicionarTreino() {
    setState(() {
      treinos.add(TreinoModel(
        titulo: 'Novo Treino',
        completo: false,
        exercicios: [],
      ));
    });
  }

  void _removerTreino(int index) {
    setState(() {
      treinos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rotina de Treinos')),
      body: ListView.builder(
        itemCount: treinos.length,
        itemBuilder: (context, index) {
          final treino = treinos[index];
          return Card(
            color: treino.completo ? Colors.green[100] : Colors.grey[200],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(treino.titulo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_forward),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'remover') {
                        _removerTreino(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'remover',
                        child: Text('Remover treino'),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsScreen(treino: treino),
                  ),
                );
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTreino,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
