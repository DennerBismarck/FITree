import 'package:flutter_test/flutter_test.dart';
import '../lib/models/refeicao_model.dart';
import '../lib/models/treino_model.dart';
import '../lib/services/nutrition_service.dart';
import '../lib/services/exercise_service.dart';

void main() {
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

  group('Service Logic Tests', () {
    test('should calculate meal nutrition correctly', () {
      final nutritionService = NutritionService();
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
      expect(nutrition['proteinas'], closeTo(1.4, 0.01));
      expect(nutrition['gorduras'], closeTo(0.5, 0.01));
    });

    test('should return available muscle groups', () {
      final exerciseService = ExerciseService();
      final muscleGroups = exerciseService.getAvailableMuscleGroups();
      
      expect(muscleGroups, isNotEmpty);
      expect(muscleGroups, contains('chest'));
      expect(muscleGroups, contains('biceps'));
      expect(muscleGroups, contains('quadriceps'));
    });

    test('should translate muscle groups correctly', () {
      final exerciseService = ExerciseService();
      
      expect(exerciseService.translateMuscleGroup('chest'), equals('Peito'));
      expect(exerciseService.translateMuscleGroup('biceps'), equals('Bíceps'));
      expect(exerciseService.translateMuscleGroup('quadriceps'), equals('Quadríceps'));
    });

    test('should translate exercise types correctly', () {
      final exerciseService = ExerciseService();
      
      expect(exerciseService.translateExerciseType('strength'), equals('Força'));
      expect(exerciseService.translateExerciseType('cardio'), equals('Cardio'));
      expect(exerciseService.translateExerciseType('stretching'), equals('Alongamento'));
    });

    test('should translate difficulty levels correctly', () {
      final exerciseService = ExerciseService();
      
      expect(exerciseService.translateDifficulty('beginner'), equals('Iniciante'));
      expect(exerciseService.translateDifficulty('intermediate'), equals('Intermediário'));
      expect(exerciseService.translateDifficulty('expert'), equals('Avançado'));
    });
  });
}

