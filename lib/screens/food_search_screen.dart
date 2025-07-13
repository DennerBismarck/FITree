import 'package:flutter/material.dart';
import '../models/refeicao_model.dart';
import '../controllers/data_service.dart';

class FoodSearchScreen extends StatefulWidget {
  final String refeicao;
  final String data;

  const FoodSearchScreen({
    Key? key,
    required this.refeicao,
    required this.data,
  }) : super(key: key);

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AlimentoModel> _searchResults = [];
  List<AlimentoModel> _selectedFoods = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Alimentos - ${widget.refeicao}'),
        actions: [
          if (_selectedFoods.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveSelectedFoods,
            ),
        ],
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Digite o nome do alimento...',
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
              onSubmitted: _searchFoods,
            ),
          ),

          // Botão de busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _searchFoods(_searchController.text),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Buscar'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Alimentos selecionados
          if (_selectedFoods.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alimentos Selecionados (${_selectedFoods.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_selectedFoods.map((food) => Chip(
                    label: Text(food.nome),
                    onDeleted: () {
                      setState(() {
                        _selectedFoods.remove(food);
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
                      'Digite um alimento para buscar informações nutricionais',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final food = _searchResults[index];
                      final isSelected = _selectedFoods.contains(food);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(food.nome),
                          subtitle: Text(
                            '${food.calorias.toStringAsFixed(0)} kcal | '
                            'C: ${food.carboidratos.toStringAsFixed(1)}g | '
                            'P: ${food.proteinas.toStringAsFixed(1)}g | '
                            'G: ${food.gorduras.toStringAsFixed(1)}g',
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.add_circle_outline),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFoods.remove(food);
                              } else {
                                _selectedFoods.add(food);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchFoods(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await dataService.buscarAlimentos(query.trim());
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar alimentos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedFoods() async {
    if (_selectedFoods.isEmpty) return;

    try {
      await dataService.salvarRefeicao(
        refeicao: widget.refeicao,
        data: widget.data,
        alimentos: _selectedFoods,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refeição salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true); // Retorna true para indicar que foi salvo
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar refeição: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

