// screens/meal_screen.dart
import 'package:flutter/material.dart';
import '../models/refeicao_model.dart';
import 'meal_details_screen.dart';
import 'package:intl/intl.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final List<RefeicaoModel> _allRefeicoes = [
    RefeicaoModel(
      refeicao: 'Café da Manhã',
      completo: true,
      data: '2025-07-09',
      alimentos: [
        AlimentoModel(nome: 'Cereal Integral', calorias: 150, carboidratos: 30, proteinas: 3, gorduras: 1),
        AlimentoModel(nome: 'Leite Semi-desnatado', calorias: 60, carboidratos: 5, proteinas: 6, gorduras: 2),
        AlimentoModel(nome: 'Banana', calorias: 100, carboidratos: 27, proteinas: 1, gorduras: 0),
      ],
      caloriasTotais: 310,
    ),
    RefeicaoModel(
      refeicao: 'Almoço',
      completo: true,
      data: '2025-07-09',
      alimentos: [
        AlimentoModel(nome: 'Salada Mista', calorias: 80, carboidratos: 15, proteinas: 3, gorduras: 1),
        AlimentoModel(nome: 'Peito de Peru Grelhado', calorias: 140, carboidratos: 0, proteinas: 28, gorduras: 2.5),
        AlimentoModel(nome: 'Batata Assada', calorias: 130, carboidratos: 30, proteinas: 2, gorduras: 0.5),
      ],
      caloriasTotais: 350,
    ),
    RefeicaoModel(
      refeicao: 'Janta',
      completo: true,
      data: '2025-07-09',
      alimentos: [
        AlimentoModel(nome: 'Sopa de Legumes', calorias: 100, carboidratos: 20, proteinas: 5, gorduras: 2),
        AlimentoModel(nome: 'Ovo Cozido', calorias: 80, carboidratos: 1, proteinas: 7, gorduras: 6),
      ],
      caloriasTotais: 180,
    ),
    RefeicaoModel(
      refeicao: 'Café da Manhã',
      completo: false,
      data: '2025-07-10',
      alimentos: [
        AlimentoModel(nome: 'Pão de Forma Integral', calorias: 110, carboidratos: 22, proteinas: 4, gorduras: 1.5),
        AlimentoModel(nome: 'Queijo Cottage', calorias: 70, carboidratos: 3, proteinas: 12, gorduras: 1),
        AlimentoModel(nome: 'Fruta', calorias: 60, carboidratos: 15, proteinas: 1, gorduras: 0.5),
      ],
      caloriasTotais: 240,
    ),
    RefeicaoModel(
      refeicao: 'Almoço',
      completo: false,
      data: '2025-07-10',
      alimentos: [
        AlimentoModel(nome: 'Arroz Branco', calorias: 130, carboidratos: 28, proteinas: 2.7, gorduras: 0.3),
        AlimentoModel(nome: 'Feijão', calorias: 70, carboidratos: 13, proteinas: 4.5, gorduras: 0.5),
        AlimentoModel(nome: 'Carne Moída', calorias: 180, carboidratos: 0, proteinas: 25, gorduras: 8),
      ],
      caloriasTotais: 380,
    ),
    RefeicaoModel(
      refeicao: 'Lanche',
      completo: false,
      data: '2025-07-10',
      alimentos: [
        AlimentoModel(nome: 'Iogurte Natural', calorias: 80, carboidratos: 10, proteinas: 8, gorduras: 1),
      ],
      caloriasTotais: 80,
    ),
    RefeicaoModel(
      refeicao: 'Janta',
      completo: false,
      data: '2025-07-10',
      alimentos: [
        AlimentoModel(nome: 'Frango Desfiado', calorias: 120, carboidratos: 0, proteinas: 22, gorduras: 3),
        AlimentoModel(nome: 'Purê de Batata', calorias: 100, carboidratos: 20, proteinas: 2, gorduras: 2),
      ],
      caloriasTotais: 220,
    ),
  ];

  DateTime _selectedFilterDate = DateTime.now();
  List<RefeicaoModel> _filteredRefeicoes = [];

  @override
  void initState() {
    super.initState();
    _selectedFilterDate = DateTime.now();
    _filterMeals();
  }

  void _filterMeals() {
    setState(() {
      final String formattedFilterDate = DateFormat('yyyy-MM-dd').format(_selectedFilterDate);
      _filteredRefeicoes = _allRefeicoes
          .where((refeicao) => refeicao.data == formattedFilterDate)
          .toList();
    });
  }

  Future<void> _adicionarRefeicao() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecione a Data da Nova Refeição',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (pickedDate != null) {
      setState(() {
        final String novaData = DateFormat('yyyy-MM-dd').format(pickedDate);
        _allRefeicoes.add(
          RefeicaoModel(
            refeicao: "Nova Refeição",
            completo: false,
            data: novaData,
            alimentos: [],
            caloriasTotais: 0,
          ),
        );
        _filterMeals();
      });
    }
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
        _filterMeals();
      });
    }
  }

  void _removerRefeicao(int index) {
    setState(() {
      final refeicaoRemovida = _filteredRefeicoes[index];
      _allRefeicoes.removeWhere((r) => r == refeicaoRemovida);
      _filterMeals();
    });
  }

  void _toggleCompleto(int index) {
    setState(() {
      final refeicaoToggle = _filteredRefeicoes[index];
      final originalIndex = _allRefeicoes.indexOf(refeicaoToggle);
      if (originalIndex != -1) {
        _allRefeicoes[originalIndex].completo = !_allRefeicoes[originalIndex].completo;
      }
      _filterMeals();
    });
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
            tooltip: 'Selecionar Data',
            onPressed: () => _selectFilterDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Ver refeições de hoje',
            onPressed: () {
              setState(() {
                _selectedFilterDate = DateTime.now();
                _filterMeals();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exibindo refeições de hoje: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}')),
              );
            },
          ),
        ],
      ),
      body: _filteredRefeicoes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Nenhuma refeição informada!',
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
              itemCount: _filteredRefeicoes.length,
              itemBuilder: (context, index) {
                final refeicao = _filteredRefeicoes[index];
                final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(refeicao.data));
                return Card(
                  color: refeicao.completo ? Colors.green[100] : Colors.grey[200],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${refeicao.refeicao} - $formattedDate'),
                    subtitle: Text('${refeicao.caloriasTotais.toStringAsFixed(0)} kcal'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (refeicao.completo)
                          const Icon(Icons.check_circle, color: Colors.green),
                        const Icon(Icons.arrow_forward),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'remover') {
                              _removerRefeicao(index);
                            } else if (value == 'desmarcar_concluido') {
                              _toggleCompleto(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'remover',
                              child: Text('Remover refeição'),
                            ),
                            if (refeicao.completo)
                              const PopupMenuItem(
                                value: 'desmarcar_concluido',
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
                          builder: (_) => MealDetailsScreen(refeicao: refeicao),
                        ),
                      );
                      _filterMeals();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarRefeicao,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}