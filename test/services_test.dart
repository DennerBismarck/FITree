import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path_lib;
import '../lib/services/database_service.dart';
import '../lib/services/nutrition_service.dart';
import '../lib/services/exercise_service.dart';
import '../lib/models/refeicao_model.dart';
import '../lib/models/treino_model.dart';

void main() {
  group('Database Service Tests', () {
    late DatabaseService databaseService;

    setUpAll(() {
      // Inicializar SQLite FFI para testes
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() {
      databaseService = DatabaseService();
    });

    test('should create database and tables', () async {
      final db = await databaseService.database;
      expect(db, isNotNull);
      
      // Verificar se as tabelas foram criadas
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'"
      );
      
      final tableNames = tables.map((table) => table['name']).toList();
      expect(tableNames, contains('alimentos'));
      expect(tableNames, contains('exercicios'));
      expect(tableNames, contains('refeicoes_usuario'));
      expect(tableNames, contains('treinos_usuario'));
    });

    test('should insert and retrieve alimento', () async {
      final alimentoData = {
        'nome': 'Banana Teste',
        'calorias': 89.0,
        'carboidratos': 23.0,
        'proteinas': 1.1,
        'gorduras': 0.3,
        'fonte': 'TESTE',
      };

      final id = await databaseService.insertAlimento(alimentoData);
      expect(id, greaterThan(0));

      final alimento = await databaseService.getAlimentoById(id);
      expect(alimento, isNotNull);
      expect(alimento!['nome'], equals('Banana Teste'));
      expect(alimento['calorias'], equals(89.0));
    });

    test('should search alimentos', () async {
      // Inserir alguns alimentos de teste
      await databaseService.insertAlimento({
        'nome': 'Maçã Verde',
        'calorias': 52.0,
        'carboidratos': 14.0,
        'proteinas': 0.3,
        'gorduras': 0.2,
        'fonte': 'TESTE',
      });

      await databaseService.insertAlimento({
        'nome': 'Maçã Vermelha',
        'calorias': 55.0,
        'carboidratos': 15.0,
        'proteinas': 0.3,
        'gorduras': 0.2,
        'fonte': 'TESTE',
      });

      final results = await databaseService.searchAlimentos('maçã');
      expect(results.length, equals(2));
    });

    test('should insert and retrieve exercicio', () async {
      final exercicioData = {
        'nome': 'Flexão Teste',
        'tipo': 'strength',
        'musculo': 'chest',
        'equipamento': 'body_only',
        'dificuldade': 'beginner',
        'instrucoes': 'Instruções de teste',
        'fonte': 'TESTE',
      };

      final id = await databaseService.insertExercicio(exercicioData);
      expect(id, greaterThan(0));

      final exercicios = await databaseService.getExercicios();
      expect(exercicios, isNotEmpty);
      
      final exercicio = exercicios.firstWhere((e) => e['id'] == id);
      expect(exercicio['nome'], equals('Flexão Teste'));
      expect(exercicio['musculo'], equals('chest'));
    });
  });

  group('Nutrition Service Tests', () {
    late NutritionService nutritionService;

    setUp(() {
      nutritionService = NutritionService();
    });

    test('should calculate meal nutrition', () {
      final alimentos = [
        AlimentoModel(
          nome: 'Banana',
          calorias: 89,
          carboidratos: 23,
          proteinas: 1.1,
          gorduras: 0.3,
        ),
        AlimentoModel(
          nome: 'Maçã',
          calorias: 52,
          carboidratos: 14,
          proteinas: 0.3,
          gorduras: 0.2,
        ),
      ];

      final nutrition = nutritionService.calculateMealNutrition(alimentos);
      
      expect(nutrition['calorias'], equals(141));
      expect(nutrition['carboidratos'], equals(37));
      expect(nutrition['proteinas'], equals(1.4));
      expect(nutrition['gorduras'], equals(0.5));
    });

    test('should return mock foods when API fails', () async {
      // Este teste verifica se o fallback funciona
      final foods = await nutritionService.searchFoods('banana');
      expect(foods, isNotEmpty);
      
      final banana = foods.firstWhere(
        (food) => food.nome.toLowerCase().contains('banana'),
        orElse: () => foods.first,
      );
      expect(banana.calorias, greaterThan(0));
    });
  });

  group('Exercise Service Tests', () {
    late ExerciseService exerciseService;

    setUp(() {
      exerciseService = ExerciseService();
    });

    test('should return available muscle groups', () {
      final muscleGroups = exerciseService.getAvailableMuscleGroups();
      expect(muscleGroups, isNotEmpty);
      expect(muscleGroups, contains('chest'));
      expect(muscleGroups, contains('biceps'));
      expect(muscleGroups, contains('quadriceps'));
    });

    test('should translate muscle groups', () {
      expect(exerciseService.translateMuscleGroup('chest'), equals('Peito'));
      expect(exerciseService.translateMuscleGroup('biceps'), equals('Bíceps'));
      expect(exerciseService.translateMuscleGroup('quadriceps'), equals('Quadríceps'));
    });

    test('should return mock exercises when API fails', () async {
      // Este teste verifica se o fallback funciona
      final exercises = await exerciseService.searchExercises(muscle: 'chest');
      expect(exercises, isNotEmpty);
      
      final exercise = exercises.first;
      expect(exercise.nome, isNotEmpty);
      expect(exercise.musculo, isNotEmpty);
      expect(exercise.instrucoes, isNotEmpty);
    });
  });

  group('Model Tests', () {
    test('should create AlimentoModel correctly', () {
      final alimento = AlimentoModel(
        nome: 'Teste',
        calorias: 100,
        carboidratos: 20,
        proteinas: 5,
        gorduras: 2,
      );

      expect(alimento.nome, equals('Teste'));
      expect(alimento.calorias, equals(100));
      expect(alimento.carboidratos, equals(20));
      expect(alimento.proteinas, equals(5));
      expect(alimento.gorduras, equals(2));
    });

    test('should create ExercicioModel correctly', () {
      final exercicio = ExercicioModel(
        nome: 'Flexão',
        tipo: 'strength',
        musculo: 'chest',
        equipamento: 'body_only',
        dificuldade: 'beginner',
        instrucoes: 'Faça flexões',
      );

      expect(exercicio.nome, equals('Flexão'));
      expect(exercicio.tipo, equals('strength'));
      expect(exercicio.musculo, equals('chest'));
      expect(exercicio.detalhes, equals('strength - chest - beginner'));
    });

    test('should create TreinoModel correctly', () {
      final exercicios = [
        ExercicioModel(
          nome: 'Flexão',
          tipo: 'strength',
          musculo: 'chest',
          equipamento: 'body_only',
          dificuldade: 'beginner',
          instrucoes: 'Faça flexões',
        ),
      ];

      final treino = TreinoModel(
        titulo: 'Treino de Peito',
        completo: false,
        data: '2025-07-13',
        exercicios: exercicios,
        duracaoMinutos: 30,
      );

      expect(treino.titulo, equals('Treino de Peito'));
      expect(treino.completo, isFalse);
      expect(treino.exercicios.length, equals(1));
      expect(treino.duracaoMinutos, equals(30));
    });
  });
}

