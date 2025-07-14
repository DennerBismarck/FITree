import 'package:flutter/material.dart';
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

  int? _usuarioId;

  void onBottomNavTapped(int index) => selectedIndex.value = index;

  // Funções de login
  Future<bool> login(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      return false;
    }

    final usuario =
        await _databaseService.getUsuarioByEmailAndPassword(email, senha);
    if (usuario != null) {
      _usuarioId = usuario['id'];
      return true;
    }
    return false;
  }

  Future<int> registrarUsuario(String nome, String email, String senha) async {
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      throw Exception('Name, email and password cannot be empty.');
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      throw Exception('Invalid email format.');
    }

    final usuarioExistente = await _databaseService.getUsuarioByEmail(email);
    if (usuarioExistente != null) {
      throw Exception('User already exists for email: $email');
    }
    final id = await _databaseService.insertUsuario({
      'nome': nome,
      'email': email,
      'senha': senha,
    });
    _usuarioId = id;
    return id;
  }

  void logout() {
    _usuarioId = null;
  }

  int? get usuarioId => _usuarioId;

  Future<List<AlimentoModel>> buscarAlimentos(String query) =>
      _nutritionService.searchFoods(query);

  Future<Map<String, double>> calcularNutricaoRefeicao(
          List<AlimentoModel> alimentos) async =>
      await _nutritionService.calculateMealNutrition(alimentos);

  Future<List<ExercicioModel>> buscarExercicios({
    String? nome,
    String? musculo,
    String? tipo,
    String? dificuldade,
  }) =>
      _exerciseService.searchExercises(
        name: nome,
        muscle: musculo,
        type: tipo,
        difficulty: dificuldade,
      );

  Future<List<ExercicioModel>> buscarExerciciosPorMusculo(String musculo) =>
      _exerciseService.getExercisesByMuscle(musculo);

  List<String> getGruposMusculares() =>
      _exerciseService.getAvailableMuscleGroups();

  String traduzirGrupoMuscular(String musculo) =>
      _exerciseService.translateMuscleGroup(musculo);

  Future<void> inicializarBanco() async {
    try {
      await _databaseService.database;
      print('Banco inicializado com sucesso!');
    } catch (e) {
      print('Erro ao inicializar banco: $e');
      // Adicione um fallback ou tratamento adequado
      rethrow; // Ou continue sem banco de dados se for possível
    }
  }

  Future<int> salvarRecurso<T>({
    required List<T> itens,
    required Future<List<Map<String, dynamic>>> Function(String) searchFn,
    required Future<int> Function(Map<String, dynamic>) insertFn,
    required Map<String, dynamic> Function(T) toMap,
    required Future<void> Function(Map<String, dynamic>) insertRelation,
    required int relationId,
    required String relationKey,
    required String itemKey,
  }) async {
    for (var item in itens) {
      final existentes = await searchFn((item as dynamic).nome);
      int itemId;
      if (existentes.isNotEmpty) {
        itemId = existentes.first['id'];
      } else {
        itemId = await insertFn(toMap(item));
      }
      await insertRelation({
        relationKey: relationId,
        itemKey: itemId,
        ..._getRelationExtras(item)
      });
    }
    return relationId;
  }

  Map<String, dynamic> _getRelationExtras(dynamic item) {
    if (item is AlimentoModel) {
      return {'quantidade': 1.0};
    } else if (item is ExercicioModel) {
      return {
        'series': item.series,
        'repeticoes': item.repeticoes,
        'peso': item.peso,
        'tempo_segundos': item.tempoSegundos,
      };
    }
    return {};
  }

  Future<int> salvarRefeicao({
    required String refeicao,
    required String data,
    required List<AlimentoModel> alimentos,
  }) async {
    final nutricao = await calcularNutricaoRefeicao(alimentos);
    final calorias = nutricao['calorias'] ?? 0;

    final refeicaoId = await _databaseService.insertRefeicaoUsuario({
      'refeicao': refeicao,
      'data': data,
      'completo': 0,
      'calorias_totais': calorias,
      'usuario_id': _usuarioId,
    });

    return salvarRecurso<AlimentoModel>(
      itens: alimentos,
      searchFn: _databaseService.searchAlimentos,
      insertFn: _databaseService.insertAlimento,
      toMap: (alimento) => {
        'nome': alimento.nome,
        'calorias': alimento.calorias,
        'carboidratos': alimento.carboidratos,
        'proteinas': alimento.proteinas,
        'gorduras': alimento.gorduras,
        'fonte': 'USDA',
      },
      insertRelation: _databaseService.insertAlimentoRefeicao,
      relationId: refeicaoId,
      relationKey: 'refeicao_id',
      itemKey: 'alimento_id',
    );
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
      'usuario_id': _usuarioId,
    });

    return salvarRecurso<ExercicioModel>(
      itens: exercicios,
      searchFn: _databaseService.searchExercicios,
      insertFn: _databaseService.insertExercicio,
      toMap: (exercicio) => {
        'nome': exercicio.nome,
        'tipo': exercicio.tipo,
        'musculo': exercicio.musculo,
        'equipamento': exercicio.equipamento,
        'dificuldade': exercicio.dificuldade,
        'instrucoes': exercicio.instrucoes,
        'fonte': 'API-Ninjas',
      },
      insertRelation: _databaseService.insertExercicioTreino,
      relationId: treinoId,
      relationKey: 'treino_id',
      itemKey: 'exercicio_id',
    );
  }

  Future<List<RefeicaoModel>> getRefeicoesPorData(String data) async {
    if (_usuarioId == null) return [];
    final refeicoes =
        await _databaseService.getRefeicoesByDataUsuario(data, _usuarioId!);
    return Future.wait(refeicoes.map((refeicao) async {
      final alimentosRefeicao =
          await _databaseService.getAlimentosRefeicao(refeicao['id']);
      final alimentos = alimentosRefeicao.map(_alimentoFromMap).toList();
      return RefeicaoModel(
        refeicao: refeicao['refeicao'],
        completo: refeicao['completo'] == 1,
        data: refeicao['data'],
        alimentos: alimentos,
        caloriasTotais: refeicao['calorias_totais'],
      );
    }));
  }

  Future<List<TreinoModel>> getTreinosPorData(String data) async {
    if (_usuarioId == null) return [];
    final treinos =
        await _databaseService.getTreinosByDataUsuario(data, _usuarioId!);
    return Future.wait(treinos.map((treino) async {
      final exerciciosTreino =
          await _databaseService.getExerciciosTreino(treino['id']);
      final exercicios = exerciciosTreino.map(_exercicioFromMap).toList();
      return TreinoModel(
        titulo: treino['nome'],
        completo: treino['completo'] == 1,
        data: treino['data'],
        exercicios: exercicios,
        duracaoMinutos: treino['duracao_minutos'],
      );
    }));
  }

  AlimentoModel _alimentoFromMap(Map<String, dynamic> ar) => AlimentoModel(
        nome: ar['nome'],
        calorias: ar['calorias'],
        carboidratos: ar['carboidratos'],
        proteinas: ar['proteinas'],
        gorduras: ar['gorduras'],
      );

  ExercicioModel _exercicioFromMap(Map<String, dynamic> et) => ExercicioModel(
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
      );


  Future<void> limparCacheAntigo() async {
    await _nutritionService.clearOldCache();
    await _exerciseService.clearOldCache();
  }
}

final dataService = DataService();
