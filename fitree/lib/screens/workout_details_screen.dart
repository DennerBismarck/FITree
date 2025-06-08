// screens/workout_details_screen.dart
import 'package:flutter/material.dart';
import '../models/treino_model.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final TreinoModel treino;

  const WorkoutDetailsScreen({required this.treino, super.key});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  void _adicionarExercicio() {
    setState(() {
      widget.treino.exercicios.add({
        "nome": "Novo Exercício",
        "series": "3x10",
        "descanso": "60s",
      });
    });
  }

  void _removerExercicio(int index) {
    setState(() {
      widget.treino.exercicios.removeAt(index);
    });
  }

  void _editarExercicio(int index) {
    final exercicio = widget.treino.exercicios[index];
    TextEditingController nomeController = TextEditingController(text: exercicio['nome']);
    TextEditingController seriesController = TextEditingController(text: exercicio['series']);
    TextEditingController descansoController = TextEditingController(text: exercicio['descanso']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Exercício"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: seriesController,
              decoration: const InputDecoration(labelText: "Séries"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descansoController,
              decoration: const InputDecoration(labelText: "Descanso"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.treino.exercicios[index] = {
                  "nome": nomeController.text,
                  "series": seriesController.text,
                  "descanso": descansoController.text,
                };
              });
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.treino.titulo)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.treino.exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = widget.treino.exercicios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(exercicio['nome'] ?? '', style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(
                      "Séries: ${exercicio['series'] ?? ''} | Descanso: ${exercicio['descanso'] ?? ''}",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          _editarExercicio(index);
                        } else if (value == 'remover') {
                          _removerExercicio(index);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(value: 'editar', child: Text('Editar')),
                        const PopupMenuItem(value: 'remover', child: Text('Remover')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  widget.treino.completo = true;
                });
                Navigator.pop(context); // volta para WorkoutScreen
              },
              icon: const Icon(Icons.check),
              label: const Text("Marcar como concluído"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), 
        child: FloatingActionButton(
          onPressed: _adicionarExercicio,
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
