import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treino_model.dart';
import '../controllers/data_service.dart';
import 'workout_details_screen.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  DateTime _selectedFilterDate = DateTime.now();
  List<TreinoModel> _filteredTreinos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  Future<void> _loadTreinos() async {
    setState(() => _isLoading = true);
    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedFilterDate);
      final treinos = await dataService.getTreinosPorData(formattedDate);
      setState(() {
        _filteredTreinos = treinos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar treinos: $e')),
      );
    }
  }

  Future<void> _adicionarTreino() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _selectedFilterDate = pickedDate);

      final novaData = DateFormat('yyyy-MM-dd').format(pickedDate);
      final novoTreino = TreinoModel(
        titulo: 'Novo Treino',
        completo: false,
        data: novaData,
        exercicios: [],
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutDetailsScreen(treino: novoTreino),
        ),
      );

      if (result == true) {
        await _loadTreinos();
      }
    }
  }

  Future<void> _selectFilterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedFilterDate) {
      setState(() => _selectedFilterDate = picked);
      await _loadTreinos();
    }
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
            onPressed: () => _selectFilterDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTreinos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTreinos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.fitness_center, size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum treino para ${DateFormat('dd/MM/yyyy').format(_selectedFilterDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredTreinos.length,
                  itemBuilder: (context, index) {
                    final treino = _filteredTreinos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(treino.titulo),
                        subtitle: Text('Exercícios: ${treino.exercicios.length}'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutDetailsScreen(treino: treino),
                            ),
                          );
                          await _loadTreinos();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTreino,
        child: const Icon(Icons.add),
      ),
    );
  }
}