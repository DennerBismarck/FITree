// models/treino_model.dart
class TreinoModel {
  String titulo;
  bool completo;
  List<Map<String, String>> exercicios;

  TreinoModel({
    required this.titulo,
    required this.completo,
    required this.exercicios,
  });
}



class ExercicioModel {
  final String nome;
  final String detalhes;

  ExercicioModel({required this.nome, required this.detalhes});
}
