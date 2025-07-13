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
          peso: 0.0, // Adicionado valor padrão
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

  Future<void> _editarExercicio(int index) async {
    final exercicio = widget.treino.exercicios[index];

    final TextEditingController nomeController = TextEditingController(text: exercicio.nome);
    final TextEditingController tipoController = TextEditingController(text: exercicio.tipo);
    final TextEditingController musculoController = TextEditingController(text: exercicio.musculo);
    final TextEditingController equipamentoController = TextEditingController(text: exercicio.equipamento);
    final TextEditingController dificuldadeController = TextEditingController(text: exercicio.dificuldade);
    final TextEditingController instrucoesController = TextEditingController(text: exercicio.instrucoes);
    final TextEditingController seriesController = TextEditingController(text: exercicio.series?.toString() ?? '');
    final TextEditingController repeticoesController = TextEditingController(text: exercicio.repeticoes?.toString() ?? '');
    final TextEditingController pesoController = TextEditingController(text: exercicio.peso?.toString() ?? '');
    final TextEditingController tempoSegundosController = TextEditingController(text: exercicio.tempoSegundos?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Exercício"),
        content: SingleChildScrollView( 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: "Nome")),
              const SizedBox(height: 16),
              TextField(controller: tipoController, decoration: const InputDecoration(labelText: "Tipo")),
              const SizedBox(height: 16),
              TextField(controller: musculoController, decoration: const InputDecoration(labelText: "Músculo")),
              const SizedBox(height: 16),
              TextField(controller: equipamentoController, decoration: const InputDecoration(labelText: "Equipamento")),
              const SizedBox(height: 16),
              TextField(controller: dificuldadeController, decoration: const InputDecoration(labelText: "Dificuldade")),
              const SizedBox(height: 16),
              TextField(controller: instrucoesController, decoration: const InputDecoration(labelText: "Instruções"), maxLines: 3),
              const SizedBox(height: 16),
              TextField(
                controller: seriesController,
                decoration: const InputDecoration(labelText: "Séries"),
                keyboardType: TextInputType.number, 
              ),
              const SizedBox(height: 16),
              TextField(
                controller: repeticoesController,
                decoration: const InputDecoration(labelText: "Repetições"),
                keyboardType: TextInputType.number, 
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pesoController,
                decoration: const InputDecoration(labelText: "Peso (kg)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true), 
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tempoSegundosController,
                decoration: const InputDecoration(labelText: "Descanso (s)"),
                keyboardType: TextInputType.number, 
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.treino.exercicios[index] = ExercicioModel(
                  nome: nomeController.text.trim(),
                  tipo: tipoController.text.trim(),
                  musculo: musculoController.text.trim(),
                  equipamento: equipamentoController.text.trim(),
                  dificuldade: dificuldadeController.text.trim(),
                  instrucoes: instrucoesController.text.trim(),
                  series: int.tryParse(seriesController.text),
                  repeticoes: int.tryParse(repeticoesController.text),
                  peso: double.tryParse(pesoController.text), // Usar double.tryParse
                  tempoSegundos: int.tryParse(tempoSegundosController.text),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tipo: ${exercicio.tipo ?? '-'} | Músculo: ${exercicio.musculo ?? '-'}"),
                        Text("Séries: ${exercicio.series ?? '-'} | Repetições: ${exercicio.repeticoes ?? '-'}"),
                        Text("Peso: ${exercicio.peso != null ? '${exercicio.peso}kg' : '-'} | Descanso: ${exercicio.tempoSegundos ?? '-'}s"),
                        Text("Equipamento: ${exercicio.equipamento ?? '-'} | Dificuldade: ${exercicio.dificuldade ?? '-'}"),
                        Text("Instruções: ${exercicio.instrucoes ?? '-'}"),
                      ],
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
                Navigator.pop(context);
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
