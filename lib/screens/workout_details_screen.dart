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
      widget.treino.exercicios.add(
        ExercicioModel(
          nome: "Novo Exercício",
          tipo: "Força",
          musculo: "Geral",
          equipamento: "Livre",
          dificuldade: "Fácil",
          instrucoes: "Adicione instruções aqui.",
          series: 3,
          repeticoes: 10,
          tempoSegundos: 60,
        ),
      );
    });
  }

  void _removerExercicio(int index) {
    setState(() {
      widget.treino.exercicios.removeAt(index);
    });
  }

  void _editarExercicio(int index) {
    final exercicio = widget.treino.exercicios[index];
    TextEditingController nomeController = TextEditingController(text: exercicio.nome);
    TextEditingController seriesController = TextEditingController(text: exercicio.series?.toString() ?? '');
    TextEditingController descansoController = TextEditingController(text: exercicio.tempoSegundos?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Exercício"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: "Nome")),
            const SizedBox(height: 16),
            TextField(controller: seriesController, decoration: const InputDecoration(labelText: "Séries")),
            const SizedBox(height: 16),
            TextField(controller: descansoController, decoration: const InputDecoration(labelText: "Descanso (s)")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.treino.exercicios[index] = ExercicioModel(
                  nome: nomeController.text,
                  tipo: exercicio.tipo,
                  musculo: exercicio.musculo,
                  equipamento: exercicio.equipamento,
                  dificuldade: exercicio.dificuldade,
                  instrucoes: exercicio.instrucoes,
                  series: int.tryParse(seriesController.text),
                  repeticoes: exercicio.repeticoes,
                  peso: exercicio.peso,
                  tempoSegundos: int.tryParse(descansoController.text),
                );
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
    final exercicios = widget.treino.exercicios;

    return Scaffold(
      appBar: AppBar(title: Text(widget.treino.titulo)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = exercicios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(exercicio.nome, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(
                      "Séries: ${exercicio.series ?? '-'} | Descanso: ${exercicio.tempoSegundos ?? '-'}s",
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
