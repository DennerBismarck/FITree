// models/treino_model.dart
class TreinoModel {
  String titulo;
  bool completo;
  String data;
  List<ExercicioModel> exercicios;
  int? duracaoMinutos;

  TreinoModel({
    required this.titulo,
    required this.completo,
    required this.data,
    required this.exercicios,
    this.duracaoMinutos,
  });
}

class ExercicioModel {
  final String nome;
  final String tipo;
  final String musculo;
  final String equipamento;
  final String dificuldade;
  final String instrucoes;
  int? series;
  int? repeticoes;
  double? peso;
  int? tempoSegundos;

  ExercicioModel({
    required this.nome,
    required this.tipo,
    required this.musculo,
    required this.equipamento,
    required this.dificuldade,
    required this.instrucoes,
    this.series,
    this.repeticoes,
    this.peso,
    this.tempoSegundos,
  });


  String get detalhes => '$tipo - $musculo - $dificuldade';
}
