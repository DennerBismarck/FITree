// models/treino_model.dart
class TreinoModel {
  int? id;
  String titulo;
  bool completo;
  String data;
  List<ExercicioModel> exercicios;
  int? duracaoMinutos;

  TreinoModel({
    this.id,
    required this.titulo,
    required this.completo,
    required this.data,
    required this.exercicios,
    this.duracaoMinutos,
  });

  factory TreinoModel.fromMap(Map<String, dynamic> map) {
    return TreinoModel(
      id: map["id"],
      titulo: map["titulo"],
      completo: map["completo"] == 1,
      data: map["data"],
      duracaoMinutos: map["duracao_minutos"],
      exercicios: (map["exercicios"] as List)
          .map((e) => ExercicioModel.fromMap(e))
          .toList(),
    );
  }

  toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "completo": completo ? 1 : 0,
      "data": data,
      "duracao_minutos": duracaoMinutos,
      "exercicios": exercicios.map((e) => e.toMap()).toList(),
    };
  }
}

class ExercicioModel {
  int? id;
  String nome;
  String tipo;
  String musculo;
  String equipamento;
  String dificuldade;
  String instrucoes;
  int? series;
  int? repeticoes;
  double? peso;
  int? tempoSegundos;

  ExercicioModel({
    required this.id,
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


  factory ExercicioModel.fromMap(Map<String, dynamic> map) {
    return ExercicioModel(
      id: map["id"],
      nome: map["nome"],
      tipo: map["tipo"],
      musculo: map["musculo"],
      equipamento: map["equipamento"] ?? "",
      dificuldade: map["dificuldade"],
      instrucoes: map["instrucoes"],
      series: map["series"],
      repeticoes: map["repeticoes"],
      peso: map["peso"]?.toDouble(),
      tempoSegundos: map["tempo_segundos"],
    );
  }

  toMap() {
    return {
      "id": id,
      "nome": nome,
      "tipo": tipo,
      "musculo": musculo,
      "equipamento": equipamento,
      "dificuldade": dificuldade,
      "instrucoes": instrucoes,
      "series": series,
      "repeticoes": repeticoes,
      "peso": peso,
      "tempo_segundos": tempoSegundos,
    };
  }
}

