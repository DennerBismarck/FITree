import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/refeicao_model.dart';
import '../controllers/data_service.dart';
import 'meal_details_screen.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  DateTime _selectedFilterDate = DateTime.now();
  List<RefeicaoModel> _filteredRefeicoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRefeicoes();
  }

  Future<void> _loadRefeicoes() async {
    setState(() => _isLoading = true);
    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedFilterDate);
      final refeicoes = await dataService.getRefeicoesPorData(formattedDate);
      setState(() {
        _filteredRefeicoes = refeicoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar refeições: $e')),
      );
    }
  }

  Future<void> _adicionarRefeicao() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      try {
        final dataService = Provider.of<DataService>(context, listen: false);
        final novaData = DateFormat('yyyy-MM-dd').format(pickedDate);
        
        final refeicaoId = await dataService.salvarRefeicao(
          refeicao: 'Nova Refeição',
          data: novaData,
          alimentos: [],
        );

        setState(() {
          _selectedFilterDate = pickedDate;
        });
        await _loadRefeicoes();
        
        // Abre a tela de detalhes para edição
        final novaRefeicao = RefeicaoModel(
          refeicao: 'Nova Refeição',
          completo: false,
          data: novaData,
          alimentos: [],
          caloriasTotais: 0,
        );
        
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetailsScreen(refeicao: novaRefeicao),
          ),
        );
        
        await _loadRefeicoes();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar refeição: $e')),
        );
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
      await _loadRefeicoes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Planejamento Alimentar'),
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
            onPressed: _loadRefeicoes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredRefeicoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.restaurant, size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma refeição para ${DateFormat('dd/MM/yyyy').format(_selectedFilterDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredRefeicoes.length,
                  itemBuilder: (context, index) {
                    final refeicao = _filteredRefeicoes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(refeicao.refeicao),
                        subtitle: Text('${refeicao.caloriasTotais.toStringAsFixed(0)} kcal | ${refeicao.alimentos.length} itens'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealDetailsScreen(refeicao: refeicao),
                            ),
                          );
                          await _loadRefeicoes();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarRefeicao,
        child: const Icon(Icons.add),
      ),
    );
  }
}