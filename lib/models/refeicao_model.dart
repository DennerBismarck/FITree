// models/refeicao_model.dart
class RefeicaoModel {
  int? id;
  String refeicao;
  bool completo;
  String data;
  List<AlimentoModel> alimentos;
  double caloriasTotais; 

  RefeicaoModel({
    this.id,
    required this.refeicao,
    required this.completo,
    required this.data,
    required this.alimentos,
    required this.caloriasTotais,
  });

  factory RefeicaoModel.fromMap(Map<String, dynamic> map) {
    return RefeicaoModel(
      id: map["id"],
      refeicao: map["refeicao"],
      completo: map["completo"] == 1,
      data: map["data"],
      caloriasTotais: map["calorias_totais"],
      alimentos: (map["alimentos"] as List)
          .map((e) => AlimentoModel.fromMap(e))
          .toList(),
    );
  }

  toMap() {
    return {
      "id": id,
      "refeicao": refeicao,
      "completo": completo ? 1 : 0,
      "data": data,
      "calorias_totais": caloriasTotais,
      "alimentos": alimentos.map((e) => e.toMap()).toList(),
    };
  }
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

  factory AlimentoModel.fromMap(Map<String, dynamic> map) {
    return AlimentoModel(
      nome: map["nome"],
      calorias: map["calorias"],
      carboidratos: map["carboidratos"],
      proteinas: map["proteinas"],
      gorduras: map["gorduras"],
    );
  }

  toMap() {
    return {
      "nome": nome,
      "calorias": calorias,
      "carboidratos": carboidratos,
      "proteinas": proteinas,
      "gorduras": gorduras,
    };
  }
}

