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
        ExercicioModel(
          nome: "Supino Reto",
          tipo: "Força",
          musculo: "Peito",
          equipamento: "Barra",
          dificuldade: "Intermediário",
          instrucoes: "Execute o supino reto com controle.",
          series: 4,
          repeticoes: 10,
          tempoSegundos: 60,
        ),
        ExercicioModel(
          nome: "Supino Inclinado",
          tipo: "Força",
          musculo: "Peito Superior",
          equipamento: "Halter",
          dificuldade: "Intermediário",
          instrucoes: "Incline o banco e empurre os halteres para cima.",
          series: 3,
          repeticoes: 12,
          tempoSegundos: 60,
        ),
      ],
    ),
    TreinoModel(
      titulo: "Treino A - Tríceps",
      completo: true,
      data: '2025-07-07',
      exercicios: [
        ExercicioModel(
          nome: "Crossover",
          tipo: "Isolado",
          musculo: "Peito",
          equipamento: "Cabo",
          dificuldade: "Fácil",
          instrucoes: "Cruze os cabos à frente do corpo.",
          series: 3,
          repeticoes: 15,
          tempoSegundos: 45,
        ),
        ExercicioModel(
          nome: "Tríceps Pulley",
          tipo: "Força",
          musculo: "Tríceps",
          equipamento: "Cabo",
          dificuldade: "Fácil",
          instrucoes: "Empurre a barra até estender completamente o braço.",
          series: 4,
          repeticoes: 12,
          tempoSegundos: 60,
        ),
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Costas",
      completo: true,
      data: '2025-07-08',
      exercicios: [
        ExercicioModel(
          nome: "Barra Fixa",
          tipo: "Força",
          musculo: "Costas",
          equipamento: "Peso corporal",
          dificuldade: "Avançado",
          instrucoes: "Eleve seu corpo até o queixo ultrapassar a barra.",
          series: 3,
          repeticoes: 10,
          tempoSegundos: 60,
        ),
        ExercicioModel(
          nome: "Remada Curvada",
          tipo: "Força",
          musculo: "Costas",
          equipamento: "Barra",
          dificuldade: "Intermediário",
          instrucoes: "Puxe a barra em direção ao abdômen.",
          series: 4,
          repeticoes: 10,
          tempoSegundos: 60,
        ),
      ],
    ),
    TreinoModel(
      titulo: "Treino B - Bíceps",
      completo: true,
      data: '2025-07-08',
      exercicios: [
        ExercicioModel(
          nome: "Rosca Direta",
          tipo: "Força",
          musculo: "Bíceps",
          equipamento: "Barra",
          dificuldade: "Intermediário",
          instrucoes: "Flexione os cotovelos sem movimentar os ombros.",
          series: 3,
          repeticoes: 12,
          tempoSegundos: 45,
        ),
        ExercicioModel(
          nome: "Rosca Martelo",
          tipo: "Força",
          musculo: "Bíceps",
          equipamento: "Halter",
          dificuldade: "Intermediário",
          instrucoes: "Segure os halteres na posição neutra e flexione.",
          series: 3,
          repeticoes: 12,
          tempoSegundos: 45,
        ),
      ],
    ),
    TreinoModel(
      titulo: "Treino C - Pernas",
      completo: true,
      data: '2025-07-09',
      exercicios: [
        ExercicioModel(
          nome: "Agachamento Livre",
          tipo: "Força",
          musculo: "Quadríceps/Glúteos",
          equipamento: "Barra",
          dificuldade: "Avançado",
          instrucoes: "Desça até 90 graus com a coluna reta.",
          series: 4,
          repeticoes: 8,
          tempoSegundos: 90,
        ),
        ExercicioModel(
          nome: "Leg Press",
          tipo: "Força",
          musculo: "Pernas",
          equipamento: "Máquina",
          dificuldade: "Intermediário",
          instrucoes: "Empurre a plataforma até quase estender os joelhos.",
          series: 3,
          repeticoes: 10,
          tempoSegundos: 60,
        ),
        ExercicioModel(
          nome: "Cadeira Extensora",
          tipo: "Isolado",
          musculo: "Quadríceps",
          equipamento: "Máquina",
          dificuldade: "Fácil",
          instrucoes: "Estenda os joelhos controlando o peso.",
          series: 3,
          repeticoes: 15,
          tempoSegundos: 45,
        ),
        ExercicioModel(
          nome: "Mesa Flexora",
          tipo: "Isolado",
          musculo: "Posterior de coxa",
          equipamento: "Máquina",
          dificuldade: "Fácil",
          instrucoes: "Flexione os joelhos até o máximo possível.",
          series: 3,
          repeticoes: 12,
          tempoSegundos: 60,
        ),
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

  Future<void> _editarTreino(int index) async {
    final treinoParaEditar = _filteredTreinos[index];
    final TextEditingController _tituloController = TextEditingController(text: treinoParaEditar.titulo);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Treino'),
          content: TextField(
            controller: _tituloController,
            decoration: const InputDecoration(labelText: 'Título do Treino'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final originalIndex = _allTreinos.indexOf(treinoParaEditar);
                  if (originalIndex != -1) {
                    _allTreinos[originalIndex].titulo = _tituloController.text.trim();
                  }
                  _filterTreinos(); 
                });
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
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
                            if (value == 'editar') {
                              _editarTreino(index);
                            } else if (value == 'remover') {
                              _removerTreino(index);
                            } else if (value == 'toggle_concluido') {
                              _toggleCompleto(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: 'editar',
                              child: Text('Editar treino'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'remover',
                              child: Text('Remover treino'),
                            ),
                            if (treino.completo)
                              const PopupMenuItem<String>(
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