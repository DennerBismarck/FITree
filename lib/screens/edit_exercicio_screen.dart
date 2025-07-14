import 'package:flutter/material.dart';
import '../models/treino_model.dart';

class EditExercicioScreen extends StatefulWidget {
  final ExercicioModel exercicio;

  const EditExercicioScreen({super.key, required this.exercicio});

  @override
  State<EditExercicioScreen> createState() => _EditExercicioScreenState();
}

class _EditExercicioScreenState extends State<EditExercicioScreen> {
  late TextEditingController nomeController;
  late TextEditingController seriesController;
  late TextEditingController repeticoesController;
  late TextEditingController pesoController;
  late TextEditingController tempoController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.exercicio.nome);
    seriesController = TextEditingController(text: widget.exercicio.series.toString());
    repeticoesController = TextEditingController(text: widget.exercicio.repeticoes.toString());
    pesoController = TextEditingController(text: widget.exercicio.peso.toString());
    tempoController = TextEditingController(text: widget.exercicio.tempoSegundos.toString());
  }

  @override
  void dispose() {
    nomeController.dispose();
    seriesController.dispose();
    repeticoesController.dispose();
    pesoController.dispose();
    tempoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final editado = ExercicioModel(
      id: widget.exercicio.id,
      nome: nomeController.text,
      tipo: widget.exercicio.tipo,
      musculo: widget.exercicio.musculo,
      equipamento: widget.exercicio.equipamento,
      dificuldade: widget.exercicio.dificuldade,
      instrucoes: widget.exercicio.instrucoes,
      series: int.tryParse(seriesController.text) ?? 0,
      repeticoes: int.tryParse(repeticoesController.text) ?? 0,
      peso: double.tryParse(pesoController.text) ?? 0.0,
      tempoSegundos: int.tryParse(tempoController.text) ?? 0,
    );

    Navigator.pop(context, editado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: seriesController,
              decoration: const InputDecoration(labelText: 'Séries'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repeticoesController,
              decoration: const InputDecoration(labelText: 'Repetições'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tempoController,
              decoration: const InputDecoration(labelText: 'Tempo (segundos)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
