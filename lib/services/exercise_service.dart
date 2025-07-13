import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/treino_model.dart';
import 'database_service.dart';

class ExerciseService {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1';
  static const String _apiKey = 'fy/MtfHhUcOhAEHFeyDIBA==yWnvRSU43DNdOwWN';
  
  final DatabaseService _databaseService = DatabaseService();

  // Buscar exercícios na API Ninjas
  Future<List<ExercicioModel>> searchExercises({
    String? name,
    String? muscle,
    String? type,
    String? difficulty,
  }) async {
    try {
      // Primeiro, buscar no cache local
      final cachedExercises = await _searchCachedExercises(name ?? muscle ?? '');
      if (cachedExercises.isNotEmpty) {
        return cachedExercises;
      }

      // Construir URL com parâmetros
      final queryParams = <String, String>{};
      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (muscle != null && muscle.isNotEmpty) queryParams['muscle'] = muscle;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (difficulty != null && difficulty.isNotEmpty) queryParams['difficulty'] = difficulty;

      final uri = Uri.parse('$_baseUrl/exercises').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {'X-Api-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final exercises = <ExercicioModel>[];

        for (var exercise in data) {
          final exercicio = _parseNinjaExercise(exercise);
          if (exercicio != null) {
            exercises.add(exercicio);
            // Salvar no cache local
            await _cacheExercise(exercicio);
          }
        }

        return exercises;
      } else {
        throw Exception('Erro ao buscar exercícios: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no serviço de exercícios: $e');
      // Não retorna mocks
      return [];
    }
  }

  // Buscar exercícios no cache local
  Future<List<ExercicioModel>> _searchCachedExercises(String query) async {
    final cachedExercises = await _databaseService.searchExercicios(query);
    return cachedExercises.map((exercise) => ExercicioModel(
      nome: exercise['nome'],
      tipo: exercise['tipo'],
      musculo: exercise['musculo'],
      equipamento: exercise['equipamento'] ?? '',
      dificuldade: exercise['dificuldade'],
      instrucoes: exercise['instrucoes'],
    )).toList();
  }

  // Buscar exercícios por grupo muscular
  Future<List<ExercicioModel>> getExercisesByMuscle(String muscle) async {
    return await searchExercises(muscle: muscle);
  }

  // Buscar todos os exercícios de um grupo muscular (usando endpoint específico)
  Future<List<String>> getAllExercisesByMuscle(String muscle) async {
    try {
      final uri = Uri.parse('$_baseUrl/allexercises').replace(
        queryParameters: {'muscle': muscle},
      );
      
      final response = await http.get(
        uri,
        headers: {'X-Api-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.cast<String>();
      } else {
        throw Exception('Erro ao buscar lista de exercícios: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar lista de exercícios: $e');
      return [];
    }
  }

  // Converter dados da API Ninjas para ExercicioModel
  ExercicioModel? _parseNinjaExercise(Map<String, dynamic> exercise) {
    try {
      return ExercicioModel(
        nome: exercise['name'] ?? 'Exercício desconhecido',
        tipo: exercise['type'] ?? 'strength',
        musculo: exercise['muscle'] ?? 'unknown',
        equipamento: exercise['equipment'] ?? '',
        dificuldade: exercise['difficulty'] ?? 'beginner',
        instrucoes: exercise['instructions'] ?? 'Instruções não disponíveis',
      );
    } catch (e) {
      print('Erro ao converter exercício Ninja: $e');
      return null;
    }
  }

  // Salvar exercício no cache local
  Future<void> _cacheExercise(ExercicioModel exercicio) async {
    await _databaseService.insertExercicio({
      'nome': exercicio.nome,
      'tipo': exercicio.tipo,
      'musculo': exercicio.musculo,
      'equipamento': exercicio.equipamento,
      'dificuldade': exercicio.dificuldade,
      'instrucoes': exercicio.instrucoes,
      'fonte': 'API-Ninjas',
    });
  }

  // Obter grupos musculares disponíveis
  List<String> getAvailableMuscleGroups() {
    return [
      'abdominals',
      'abductors',
      'adductors',
      'biceps',
      'calves',
      'chest',
      'forearms',
      'glutes',
      'hamstrings',
      'lats',
      'lower_back',
      'middle_back',
      'neck',
      'quadriceps',
      'traps',
      'triceps',
    ];
  }

  // Obter tipos de exercício disponíveis
  List<String> getAvailableExerciseTypes() {
    return [
      'cardio',
      'olympic_weightlifting',
      'plyometrics',
      'powerlifting',
      'strength',
      'stretching',
      'strongman',
    ];
  }

  // Obter níveis de dificuldade disponíveis
  List<String> getAvailableDifficultyLevels() {
    return [
      'beginner',
      'intermediate',
      'expert',
    ];
  }

  // Traduzir grupo muscular para português
  String translateMuscleGroup(String muscle) {
    const translations = {
      'abdominals': 'Abdominais',
      'abductors': 'Abdutores',
      'adductors': 'Adutores',
      'biceps': 'Bíceps',
      'calves': 'Panturrilhas',
      'chest': 'Peito',
      'forearms': 'Antebraços',
      'glutes': 'Glúteos',
      'hamstrings': 'Posteriores da coxa',
      'lats': 'Dorsais',
      'lower_back': 'Lombar',
      'middle_back': 'Meio das costas',
      'neck': 'Pescoço',
      'quadriceps': 'Quadríceps',
      'traps': 'Trapézio',
      'triceps': 'Tríceps',
    };
    return translations[muscle] ?? muscle;
  }

  // Traduzir tipo de exercício para português
  String translateExerciseType(String type) {
    const translations = {
      'cardio': 'Cardio',
      'olympic_weightlifting': 'Levantamento olímpico',
      'plyometrics': 'Pliometria',
      'powerlifting': 'Powerlifting',
      'strength': 'Força',
      'stretching': 'Alongamento',
      'strongman': 'Strongman',
    };
    return translations[type] ?? type;
  }

  // Traduzir dificuldade para português
  String translateDifficulty(String difficulty) {
    const translations = {
      'beginner': 'Iniciante',
      'intermediate': 'Intermediário',
      'expert': 'Avançado',
    };
    return translations[difficulty] ?? difficulty;
  }

  // Limpar cache antigo
  Future<void> clearOldCache() async {
    await _databaseService.clearOldCache();
  }
}
