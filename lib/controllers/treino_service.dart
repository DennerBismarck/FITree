import '../models/treino_model.dart';
import '../services/exercise_service.dart';
import '../services/database_service.dart';

class TreinoService {
  final ExerciseService _exerciseService = ExerciseService();
  final DatabaseService _databaseService = DatabaseService();

  
  List<TreinoModel> getTreinosMockados() {
    return [
      TreinoModel(
        titulo: 'Treino de Peito',
        completo: false,
        data: DateTime.now().toString().split(' ')[0],
        exercicios: [
          ExercicioModel(
            nome: 'Flexão de braço',
            tipo: 'strength',
            musculo: 'chest',
            equipamento: 'body_only',
            dificuldade: 'beginner',
            instrucoes: 'Deite-se de bruços, apoie as mãos no chão na largura dos ombros e empurre o corpo para cima.',
            series: 3,
            repeticoes: 15,
          ),
        ],
        duracaoMinutos: 30,
      ),
      TreinoModel(
        titulo: 'Treino de Pernas',
        completo: true,
        data: DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0],
        exercicios: [
          ExercicioModel(
            nome: 'Agachamento',
            tipo: 'strength',
            musculo: 'quadriceps',
            equipamento: 'body_only',
            dificuldade: 'beginner',
            instrucoes: 'Fique em pé com os pés na largura dos ombros, desça como se fosse sentar em uma cadeira.',
            series: 4,
            repeticoes: 12,
          ),
        ],
        duracaoMinutos: 45,
      ),
    ];
  }

  // Buscar exercícios por grupo muscular
  Future<List<ExercicioModel>> buscarExerciciosPorMusculo(String musculo) async {
    return await _exerciseService.getExercisesByMuscle(musculo);
  }

  // Buscar exercícios por nome
  Future<List<ExercicioModel>> buscarExerciciosPorNome(String nome) async {
    return await _exerciseService.searchExercises(name: nome);
  }

  // Obter grupos musculares disponíveis
  List<String> getGruposMusculares() {
    return _exerciseService.getAvailableMuscleGroups();
  }

  // Traduzir grupo muscular
  String traduzirGrupoMuscular(String musculo) {
    return _exerciseService.translateMuscleGroup(musculo);
  }

  // Criar novo treino
  Future<int> criarTreino({
    required String nome,
    required String data,
    required List<ExercicioModel> exercicios,
    int? duracaoMinutos,
  }) async {
    // Inserir treino no banco
    final treinoId = await _databaseService.insertTreinoUsuario({
      'nome': nome,
      'data': data,
      'completo': 0,
      'duracao_minutos': duracaoMinutos,
    });

    // Inserir exercícios do treino
    for (var exercicio in exercicios) {
      // Primeiro, verificar se o exercício já existe no banco
      final exerciciosExistentes = await _databaseService.searchExercicios(exercicio.nome);
      int exercicioId;

      if (exerciciosExistentes.isNotEmpty) {
        exercicioId = exerciciosExistentes.first['id'];
      } else {
        // Inserir novo exercício
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

      // Inserir relação exercício-treino
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

  // Obter treinos por data
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

  // Marcar treino como completo
  Future<void> marcarTreinoCompleto(int treinoId, bool completo) async {
    await _databaseService.updateTreinoCompleto(treinoId, completo);
  }

  // Obter sugestões de treino por grupo muscular
  Future<TreinoModel> gerarSugestaoTreino(String grupoMuscular) async {
    final exercicios = await buscarExerciciosPorMusculo(grupoMuscular);
    
    // Pegar os primeiros 3-5 exercícios
    final exerciciosSelecionados = exercicios.take(5).map((e) {
      e.series = 3;
      e.repeticoes = 12;
      return e;
    }).toList();

    return TreinoModel(
      titulo: 'Treino de ${traduzirGrupoMuscular(grupoMuscular)}',
      completo: false,
      data: DateTime.now().toString().split(' ')[0],
      exercicios: exerciciosSelecionados,
      duracaoMinutos: 45,
    );
  }

  // Limpar cache antigo
  Future<void> limparCacheAntigo() async {
    await _exerciseService.clearOldCache();
  }
}

