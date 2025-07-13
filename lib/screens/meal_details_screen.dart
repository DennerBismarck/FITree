// screens/meal_details_screen.dart
import 'package:flutter/material.dart';
import '../models/refeicao_model.dart';
import 'package:intl/intl.dart';

class MealDetailsScreen extends StatefulWidget {
  final RefeicaoModel refeicao;

  const MealDetailsScreen({Key? key, required this.refeicao}) : super(key: key);

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  double _totalCarboidratos = 0;
  double _totalProteinas = 0;
  double _totalGorduras = 0;

  @override
  void initState() {
    super.initState();
    _recalcularTotais();
  }

  void _adicionarAlimento() {
    setState(() {
      widget.refeicao.alimentos.add(
        AlimentoModel(
          nome: 'Novo Alimento',
          calorias: 0,
          carboidratos: 0,
          proteinas: 0,
          gorduras: 0,
        ),
      );
      _recalcularTotais(); 
    });
  }

  void _removerAlimento(int index) {
    setState(() {
      widget.refeicao.alimentos.removeAt(index);
      _recalcularTotais(); 
    });
  }

  void _recalcularTotais() {
    double totalCalorias = 0;
    double totalCarboidratos = 0;
    double totalProteinas = 0;
    double totalGorduras = 0;

    for (var alimento in widget.refeicao.alimentos) {
      totalCalorias += alimento.calorias;
      totalCarboidratos += alimento.carboidratos;
      totalProteinas += alimento.proteinas;
      totalGorduras += alimento.gorduras;
    }

    setState(() {
      widget.refeicao.caloriasTotais = totalCalorias; 
      _totalCarboidratos = totalCarboidratos; 
      _totalProteinas = totalProteinas;     
      _totalGorduras = totalGorduras;       
    });
  }

  void _editarAlimento(int index) {
    final alimentoAtual = widget.refeicao.alimentos[index];
    TextEditingController nomeController = TextEditingController(text: alimentoAtual.nome);
    TextEditingController caloriasController = TextEditingController(text: alimentoAtual.calorias.toString());
    TextEditingController carboidratosController = TextEditingController(text: alimentoAtual.carboidratos.toString());
    TextEditingController proteinasController = TextEditingController(text: alimentoAtual.proteinas.toString());
    TextEditingController gordurasController = TextEditingController(text: alimentoAtual.gorduras.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Alimento"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriasController,
                decoration: const InputDecoration(labelText: "Calorias"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: carboidratosController,
                decoration: const InputDecoration(labelText: "Carboidratos (g)"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: proteinasController,
                decoration: const InputDecoration(labelText: "Proteínas (g)"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gordurasController,
                decoration: const InputDecoration(labelText: "Gorduras (g)"),
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
                widget.refeicao.alimentos[index] = AlimentoModel(
                  nome: nomeController.text,
                  calorias: double.tryParse(caloriasController.text) ?? 0.0,
                  carboidratos: double.tryParse(carboidratosController.text) ?? 0.0,
                  proteinas: double.tryParse(proteinasController.text) ?? 0.0,
                  gorduras: double.tryParse(gordurasController.text) ?? 0.0,
                );
                _recalcularTotais(); 
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
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.refeicao.data));

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.refeicao.refeicao} - $formattedDate'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4, 
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo Nutricional da Refeição',
                      style: Theme.of(context).textTheme.titleLarge, 
                    ),
                    const SizedBox(height: 10), 
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2), 
                        1: FlexColumnWidth(1.5), 
                      },
                      border: TableBorder.all(color: Colors.grey.shade300), 
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Nutriente', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Calorias'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${widget.refeicao.caloriasTotais.toStringAsFixed(0)} kcal'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Carboidratos'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${_totalCarboidratos.toStringAsFixed(1)} g'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Proteínas'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${_totalProteinas.toStringAsFixed(1)} g'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Gorduras'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${_totalGorduras.toStringAsFixed(1)} g'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.refeicao.alimentos.length,
              itemBuilder: (context, index) {
                final alimento = widget.refeicao.alimentos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(alimento.nome,
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(
                        "Calorias: ${alimento.calorias.toStringAsFixed(0)} | Carboidratos: ${alimento.carboidratos.toStringAsFixed(1)}g | Proteínas: ${alimento.proteinas.toStringAsFixed(1)}g | Gorduras: ${alimento.gorduras.toStringAsFixed(1)}g"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          _editarAlimento(index);
                        } else if (value == 'remover') {
                          _removerAlimento(index);
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
                  widget.refeicao.completo = true; 
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text("Marcar como concluído"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 40),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarAlimento,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}