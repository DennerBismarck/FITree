// models/refeicao_model.dart
class RefeicaoModel {
  String refeicao;
  bool completo;
  String data;
  List<AlimentoModel> alimentos;
  double caloriasTotais; 

  RefeicaoModel({
    required this.refeicao,
    required this.completo,
    required this.data,
    required this.alimentos,
    required this.caloriasTotais,
  });
}

class AlimentoModel {
  final String nome;
  final double calorias;
  final double carboidratos;
  final double proteinas;
  final double gorduras;

  AlimentoModel({
    required this.nome,
    required this.calorias,
    required this.carboidratos,
    required this.proteinas,
    required this.gorduras
  });
}
