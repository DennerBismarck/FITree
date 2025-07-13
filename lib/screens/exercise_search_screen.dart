import 'package:flutter/material.dart';
import '../models/treino_model.dart';
import '../controllers/data_service.dart';

class ExerciseSearchScreen extends StatefulWidget {
  final String treinoNome;
  final String data;

  const ExerciseSearchScreen({
    Key? key,
    required this.treinoNome,
    required this.data,
  }) : super(key: key);

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ExercicioModel> _searchResults = [];
  List<ExercicioModel> _selectedExercises = [];
  String? _selectedMuscleGroup;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Exercícios - ${widget.treinoNome}'),
        actions: [
          if (_selectedExercises.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveSelectedExercises,
            ),
        ],
      ),
      body: Column(
        children: [
          // Filtro por grupo muscular
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedMuscleGroup,
              decoration: InputDecoration(
                labelText: 'Grupo Muscular',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Todos os grupos'),
                ),
                ...dataService.getGruposMusculares().map((muscle) =>
                  DropdownMenuItem<String>(
                    value: muscle,
                    child: Text(dataService.traduzirGrupoMuscular(muscle)),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMuscleGroup = value;
                });
                if (value != null) {
                  _searchByMuscleGroup(value);
                }
              },
            ),
          ),

          // Campo de busca por nome
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Digite o nome do exercício...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
              ),
              onSubmitted: _searchExercises,
            ),
          ),

          const SizedBox(height: 16),

          // Botão de busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _searchExercises(_searchController.text),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Buscar por Nome'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Exercícios selecionados
          if (_selectedExercises.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercícios Selecionados (${_selectedExercises.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_selectedExercises.map((exercise) => Chip(
                    label: Text(exercise.nome),
                    onDeleted: () {
                      setState(() {
                        _selectedExercises.remove(exercise);
                      });
                    },
                  ))),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Resultados da busca
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text(
                      'Selecione um grupo muscular ou digite o nome de um exercício',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final exercise = _searchResults[index];
                      final isSelected = _selectedExercises.contains(exercise);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ExpansionTile(
                          title: Text(exercise.nome),
                          subtitle: Text(
                            '${dataService.traduzirGrupoMuscular(exercise.musculo)} | '
                            '${_translateDifficulty(exercise.dificuldade)}',
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      _selectedExercises.add(exercise);
                                    });
                                  },
                                ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipo: ${_translateType(exercise.tipo)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (exercise.equipamento.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text('Equipamento: ${exercise.equipamento}'),
                                  ],
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Instruções:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(exercise.instrucoes),
                                  const SizedBox(height: 8),
                                  if (!isSelected)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedExercises.add(exercise);
                                          });
                                        },
                                        child: const Text('Adicionar ao Treino'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchExercises(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await dataService.buscarExercicios(nome: query.trim());
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar exercícios: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchByMuscleGroup(String muscleGroup) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await dataService.buscarExerciciosPorMusculo(muscleGroup);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar exercícios: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedExercises() async {
    if (_selectedExercises.isEmpty) return;

    // Definir valores padrão para séries e repetições
    for (var exercise in _selectedExercises) {
      exercise.series = 3;
      exercise.repeticoes = 12;
    }

    try {
      await dataService.salvarTreino(
        nome: widget.treinoNome,
        data: widget.data,
        exercicios: _selectedExercises,
        duracaoMinutos: 45,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treino salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true); // Retorna true para indicar que foi salvo
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar treino: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _translateType(String type) {
    const translations = {
      'cardio': 'Cardio',
      'strength': 'Força',
      'stretching': 'Alongamento',
      'plyometrics': 'Pliometria',
      'powerlifting': 'Powerlifting',
      'olympic_weightlifting': 'Levantamento Olímpico',
      'strongman': 'Strongman',
    };
    return translations[type] ?? type;
  }

  String _translateDifficulty(String difficulty) {
    const translations = {
      'beginner': 'Iniciante',
      'intermediate': 'Intermediário',
      'expert': 'Avançado',
    };
    return translations[difficulty] ?? difficulty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

