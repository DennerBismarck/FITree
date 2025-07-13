import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/nutrition_service.dart';
import '../services/exercise_service.dart';
import '../services/database_service.dart';
import '../models/refeicao_model.dart';
import '../models/treino_model.dart';

class DataService {
  
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  
  final NutritionService _nutritionService = NutritionService();
  final ExerciseService _exerciseService = ExerciseService();
  final DatabaseService _databaseService = DatabaseService();

  void onBottomNavTapped(int index) {
    selectedIndex.value = index;
  }

  Future<List<AlimentoModel>> buscarAlimentos(String query) async {
    return await _nutritionService.searchFoods(query);
  }

  Future<Map<String, double>> calcularNutricaoRefeicao(List<AlimentoModel> alimentos) async {
    return _nutritionService.calculateMealNutrition(alimentos);
  }

  
  Future<List<ExercicioModel>> buscarExercicios({
    String? nome,
    String? musculo,
    String? tipo,
    String? dificuldade,
  }) async {
    return await _exerciseService.searchExercises(
      name: nome,
      muscle: musculo,
      type: tipo,
      difficulty: dificuldade,
    );
  }

  Future<List<ExercicioModel>> buscarExerciciosPorMusculo(String musculo) async {
    return await _exerciseService.getExercisesByMuscle(musculo);
  }

  List<String> getGruposMusculares() {
    return _exerciseService.getAvailableMuscleGroups();
  }

  String traduzirGrupoMuscular(String musculo) {
    return _exerciseService.translateMuscleGroup(musculo);
  }


  Future<void> inicializarBanco() async {
    await _databaseService.database;
  }

 
  Future<int> salvarRefeicao({
    required String refeicao,
    required String data,
    required List<AlimentoModel> alimentos,
  }) async {
    final nutricao = calcularNutricaoRefeicao(alimentos);
    final calorias = (await nutricao)['calorias'] ?? 0;

    final refeicaoId = await _databaseService.insertRefeicaoUsuario({
      'refeicao': refeicao,
      'data': data,
      'completo': 0,
      'calorias_totais': calorias,
    });

  
    for (var alimento in alimentos) {
      
      final alimentosExistentes = await _databaseService.searchAlimentos(alimento.nome);
      int alimentoId;

      if (alimentosExistentes.isNotEmpty) {
        alimentoId = alimentosExistentes.first['id'];
      } else {
        alimentoId = await _databaseService.insertAlimento({
          'nome': alimento.nome,
          'calorias': alimento.calorias,
          'carboidratos': alimento.carboidratos,
          'proteinas': alimento.proteinas,
          'gorduras': alimento.gorduras,
          'fonte': 'USDA',
        });
      }

      await _databaseService.insertAlimentoRefeicao({
        'refeicao_id': refeicaoId,
        'alimento_id': alimentoId,
        'quantidade': 1.0,
      });
    }

    return refeicaoId;
  }

  Future<List<RefeicaoModel>> getRefeicoesPorData(String data) async {
    final refeicoes = await _databaseService.getRefeicoesByData(data);
    final refeicoesModel = <RefeicaoModel>[];

    for (var refeicao in refeicoes) {
      final alimentosRefeicao = await _databaseService.getAlimentosRefeicao(refeicao['id']);
      final alimentos = alimentosRefeicao.map((ar) => AlimentoModel(
        nome: ar['nome'],
        calorias: ar['calorias'],
        carboidratos: ar['carboidratos'],
        proteinas: ar['proteinas'],
        gorduras: ar['gorduras'],
      )).toList();

      refeicoesModel.add(RefeicaoModel(
        refeicao: refeicao['refeicao'],
        completo: refeicao['completo'] == 1,
        data: refeicao['data'],
        alimentos: alimentos,
        caloriasTotais: refeicao['calorias_totais'],
      ));
    }

    return refeicoesModel;
  }


  Future<int> salvarTreino({
    required String nome,
    required String data,
    required List<ExercicioModel> exercicios,
    int? duracaoMinutos,
  }) async {
    final treinoId = await _databaseService.insertTreinoUsuario({
      'nome': nome,
      'data': data,
      'completo': 0,
      'duracao_minutos': duracaoMinutos,
    });

    for (var exercicio in exercicios) {
      final exerciciosExistentes = await _databaseService.searchExercicios(exercicio.nome);
      int exercicioId;

      if (exerciciosExistentes.isNotEmpty) {
        exercicioId = exerciciosExistentes.first['id'];
      } else {
        exercicioId = await _databaseService.insertExercicio({
          'nome': exercicio.nome,
          'tipo': exercicio.tipo,
          'musculo': exercicio.musculo,
          'equipamento': exercicio.equipamento,
          'dificuldade': exercicio.dificuldade,
          'instrucoes': exercicio.instrucoes,
          'fonte': 'API-Ninjas',
        });
      }

      await _databaseService.insertExercicioTreino({
        'treino_id': treinoId,
        'exercicio_id': exercicioId,
        'series': exercicio.series,
        'repeticoes': exercicio.repeticoes,
        'peso': exercicio.peso,
        'tempo_segundos': exercicio.tempoSegundos,
      });
    }

    return treinoId;
  }

  Future<List<TreinoModel>> getTreinosPorData(String data) async {
    final treinos = await _databaseService.getTreinosByData(data);
    final treinosModel = <TreinoModel>[];

    for (var treino in treinos) {
      final exerciciosTreino = await _databaseService.getExerciciosTreino(treino['id']);
      final exercicios = exerciciosTreino.map((et) => ExercicioModel(
        nome: et['nome'],
        tipo: et['tipo'],
        musculo: et['musculo'],
        equipamento: et['equipamento'] ?? '',
        dificuldade: et['dificuldade'],
        instrucoes: et['instrucoes'],
        series: et['series'],
        repeticoes: et['repeticoes'],
        peso: et['peso'],
        tempoSegundos: et['tempo_segundos'],
      )).toList();

      treinosModel.add(TreinoModel(
        titulo: treino['nome'],
        completo: treino['completo'] == 1,
        data: treino['data'],
        exercicios: exercicios,
        duracaoMinutos: treino['duracao_minutos'],
      ));
    }

    return treinosModel;
  }

  // Limpeza de cache
  Future<void> limparCacheAntigo() async {
    await _nutritionService.clearOldCache();
    await _exerciseService.clearOldCache();
  }
}

final dataService = DataService();
