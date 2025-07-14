import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/treino_model.dart';
import '../controllers/data_service.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final TreinoModel treino;

  const WorkoutDetailsScreen({required this.treino, super.key});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _isSaving = false;

  Future<void> _salvarTreino() async {
    setState(() => _isSaving = true);
    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      await dataService.salvarTreino(
        nome: widget.treino.titulo,
        data: widget.treino.data,
        exercicios: widget.treino.exercicios,
        duracaoMinutos: widget.treino.duracaoMinutos,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino salvo com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar treino: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

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
        ),
      );
    });
    _salvarTreino();
  }

  void _removerExercicio(int index) {
    setState(() {
      widget.treino.exercicios.removeAt(index);
    });
    _salvarTreino();
  }

  Future<void> _editarExercicio(int index) async {
    final exercicio = widget.treino.exercicios[index];
    
    final controllers = {
      'nome': TextEditingController(text: exercicio.nome),
      'tipo': TextEditingController(text: exercicio.tipo),
      'musculo': TextEditingController(text: exercicio.musculo),
      'equipamento': TextEditingController(text: exercicio.equipamento),
      'dificuldade': TextEditingController(text: exercicio.dificuldade),
      'instrucoes': TextEditingController(text: exercicio.instrucoes),
      'series': TextEditingController(text: exercicio.series?.toString()),
      'repeticoes': TextEditingController(text: exercicio.repeticoes?.toString()),
    };

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Exercício"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              for (var entry in controllers.entries)
                Column(
                  children: [
                    TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: entry.key),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.treino.exercicios[index] = ExercicioModel(
                  nome: controllers['nome']!.text,
                  tipo: controllers['tipo']!.text,
                  musculo: controllers['musculo']!.text,
                  equipamento: controllers['equipamento']!.text,
                  dificuldade: controllers['dificuldade']!.text,
                  instrucoes: controllers['instrucoes']!.text,
                  series: int.tryParse(controllers['series']!.text),
                  repeticoes: int.tryParse(controllers['repeticoes']!.text),
                );
              });
              Navigator.of(context).pop();
              _salvarTreino();
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
      appBar: AppBar(
        title: Text(widget.treino.titulo),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _salvarTreino,
            ),
        ],
      ),
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
                    title: Text(exercicio.nome),
                    subtitle: Text("${exercicio.series}x${exercicio.repeticoes} - ${exercicio.musculo}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removerExercicio(index),
                    ),
                    onTap: () => _editarExercicio(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() => widget.treino.completo = true);
                _salvarTreino();
                Navigator.pop(context);
              },
              child: const Text("Marcar como concluído"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarExercicio,
        child: const Icon(Icons.add),
      ),
    );
  }
}