import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/treino_model.dart';
import '../controllers/data_service.dart';
import 'edit_exercicio_screen.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final TreinoModel treino;

  const WorkoutDetailsScreen({Key? key, required this.treino}) : super(key: key);

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  late TreinoModel _treinoEditado;
  final _tituloController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _treinoEditado = TreinoModel.fromMap(widget.treino.toMap());
    _tituloController.text = _treinoEditado.titulo;
  }

  void _removerExercicio(int index) {
    setState(() {
      _treinoEditado.exercicios.removeAt(index);
    });
  }

  Future<void> _editarExercicio(int index) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditExercicioScreen(exercicio: _treinoEditado.exercicios[index]),
      ),
    );

    if (resultado != null && resultado is ExercicioModel) {
      setState(() {
        _treinoEditado.exercicios[index] = resultado;
      });
    }
  }

  Future<void> _adicionarExercicio() async {
    final novo = ExercicioModel(
      id: DateTime.now().millisecondsSinceEpoch,
      nome: '',
      tipo: '',
      musculo: '',
      equipamento: '',
      dificuldade: '',
      instrucoes: '',
      series: 3,
      repeticoes: 10,
      peso: 0.0,
      tempoSegundos: 0,
    );

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditExercicioScreen(exercicio: novo)),
    );

    if (resultado != null && resultado is ExercicioModel) {
      setState(() {
        _treinoEditado.exercicios.add(resultado);
      });
    }
  }

  Future<void> _salvarTreino() async {
  if (_formKey.currentState!.validate()) {
    _treinoEditado.titulo = _tituloController.text;

    if (_treinoEditado.exercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um exercício.')),
      );
      return;
    }

    final dataService = Provider.of<DataService>(context, listen: false);
    try {
      if (_treinoEditado.id == null) {
        final newId = await dataService.salvarTreino(
          nome: _treinoEditado.titulo,
          data: _treinoEditado.data,
          exercicios: _treinoEditado.exercicios,
        );
        _treinoEditado.id = newId;
      } else {
        await dataService.atualizarTreino(
          id: _treinoEditado.id!,
          nome: _treinoEditado.titulo,
          data: _treinoEditado.data,
          exercicios: _treinoEditado.exercicios,
        );
      }

      Navigator.pop(context, true); // Retorna true indicando sucesso
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar treino: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Treino'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarTreino,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título do Treino'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Título obrigatório' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Exercícios',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ..._treinoEditado.exercicios.asMap().entries.map(
                    (entry) => Card(
                      child: ListTile(
                        title: Text(entry.value.nome.isEmpty ? 'Exercício sem nome' : entry.value.nome),
                        subtitle: Text('${entry.value.series}x${entry.value.repeticoes}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerExercicio(entry.key),
                        ),
                        onTap: () => _editarExercicio(entry.key),
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _adicionarExercicio,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Exercício'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _salvarTreino,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Salvar Treino',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}