// screens/workout_screen.dart
import 'package:flutter/material.dart';
import '../models/treino_model.dart'; 
import 'workout_details_screen.dart';
import 'package:intl/intl.dart'; 

class WorkoutScreen extends StatefulWidget {
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<TreinoModel> _allTreinos = [
    TreinoModel(
      titulo: "Treino A - Peito",
      completo: true,
      data: '2025-07-07',
      exercicios: [
        {"nome": "Supino Reto", "series": "4x10", "descanso": "60s"},
        {"nome": "Supino Inclinado", "series": "3x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino A - Tríceps",
      completo: true,
      data: '2025-07-07',
      exercicios: [
        {"nome": "Crossover", "series": "3x15", "descanso": "45s"},
        {"nome": "Tríceps Pulley", "series": "4x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Costas",
      completo: true,
      data: '2025-07-08',
      exercicios: [
        {"nome": "Barra Fixa", "series": "3x10", "descanso": "60s"},
        {"nome": "Remada Curvada", "series": "4x10", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Bíceps",
      completo: true,
      data: '2025-07-08',
      exercicios: [
        {"nome": "Rosca Direta", "series": "3x12", "descanso": "45s"},
        {"nome": "Rosca Martelo", "series": "3x12", "descanso": "45s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino C - Pernas",
      completo: true,
      data: '2025-07-09',
      exercicios: [
        {"nome": "Agachamento Livre", "series": "4x8", "descanso": "90s"},
        {"nome": "Leg Press", "series": "3x10", "descanso": "60s"},
        {"nome": "Cadeira Extensora", "series": "3x15", "descanso": "45s"},
        {"nome": "Mesa Flexora", "series": "3x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino A - Peito",
      completo: false,
      data: '2025-07-10',
      exercicios: [
        {"nome": "Supino Reto", "series": "4x10", "descanso": "60s"},
        {"nome": "Supino Inclinado", "series": "3x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino A - Tríceps",
      completo: false,
      data: '2025-07-10',
      exercicios: [
        {"nome": "Crossover", "series": "3x15", "descanso": "45s"},
        {"nome": "Tríceps Pulley", "series": "4x12", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Costas",
      completo: false,
      data: '2025-07-11',
      exercicios: [
        {"nome": "Remada Curvada", "series": "4x10", "descanso": "60s"},
        {"nome": "Barra Fixa", "series": "3x10", "descanso": "60s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Bíceps",
      completo: false,
      data: '2025-07-11',
      exercicios: [
        {"nome": "Rosca Direta", "series": "3x12", "descanso": "45s"},
        {"nome": "Rosca Martelo", "series": "3x12", "descanso": "45s"},
      ],
    ),
    TreinoModel(
      titulo: "Treino C - Pernas",
      completo: false,
      data: '2025-07-12',
      exercicios: [
        {"nome": "Agachamento Livre", "series": "4x8", "descanso": "90s"},
        {"nome": "Leg Press", "series": "3x10", "descanso": "60s"},
      ],
    ),
  ];

  DateTime _selectedFilterDate = DateTime.now(); 
  List<TreinoModel> _filteredTreinos = [];

  @override
  void initState() {
    super.initState();
    _selectedFilterDate = DateTime.now();
    _filterTreinos(); 
  }

  void _filterTreinos() {
    setState(() {
      final String formattedFilterDate = DateFormat('yyyy-MM-dd').format(_selectedFilterDate);
      _filteredTreinos = _allTreinos
          .where((treino) => treino.data == formattedFilterDate)
          .toList();
    });
  }

  Future<void> _adicionarTreino() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate, 
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecione a Data do Novo Treino',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (pickedDate != null) {
      setState(() {
        final String novaData = DateFormat('yyyy-MM-dd').format(pickedDate);
        _allTreinos.add(TreinoModel(
          titulo: 'Novo Treino',
          completo: false,
          data: novaData, 
          exercicios: [],
        ));
        _filterTreinos(); 
      });
    }
  }

  void _removerTreino(int index) {
    setState(() {
      final treinoRemovido = _filteredTreinos[index];
      _allTreinos.removeWhere((t) => t == treinoRemovido);
      _filterTreinos(); 
    });
  }

  Future<void> _selectFilterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate, 
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecionar Data de Visualização',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (picked != null && picked != _selectedFilterDate) {
      setState(() {
        _selectedFilterDate = picked;
        _filterTreinos(); 
      });
    }
  }

  void _toggleCompleto(int index) {
    setState(() {
      final treinoToggle = _filteredTreinos[index];
      final originalIndex = _allTreinos.indexOf(treinoToggle);
      if (originalIndex != -1) {
        _allTreinos[originalIndex].completo = !_allTreinos[originalIndex].completo;
      }
      _filterTreinos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotina de Treinos'), 
            Text(
              DateFormat('dd/MM/yyyy').format(_selectedFilterDate), 
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Selecionar Data',
            onPressed: () => _selectFilterDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh), 
            tooltip: 'Ver treinos de hoje',
            onPressed: () {
              setState(() {
                _selectedFilterDate = DateTime.now();
                _filterTreinos();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exibindo treinos de hoje: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}')),
              );
            },
          ),
        ],
      ),
      body: _filteredTreinos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Nenhum treino informado!', 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'para ${DateFormat('dd/MM/yyyy').format(_selectedFilterDate)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredTreinos.length,
              itemBuilder: (context, index) {
                final treino = _filteredTreinos[index];
                final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(treino.data));
                return Card(
                  color: treino.completo ? Colors.green[100] : Colors.grey[200],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${treino.titulo} - $formattedDate'), 
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (treino.completo)
                          const Icon(Icons.check_circle, color: Colors.green, size: 24.0),

                        const Icon(Icons.arrow_forward),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'remover') {
                              _removerTreino(index);
                            } else if (value == 'toggle_concluido') {
                              _toggleCompleto(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'remover',
                              child: Text('Remover treino'),
                            ),
                            if (!treino.completo)
                              const PopupMenuItem(
                                value: 'toggle_concluido',
                                child: Text('Marcar como Concluído'),
                              ),
                            if (treino.completo)
                              const PopupMenuItem(
                                value: 'toggle_concluido',
                                child: Text('Desmarcar concluído'),
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
                      setState(() {
                        _filterTreinos(); 
                      });
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