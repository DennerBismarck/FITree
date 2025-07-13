import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/refeicao_model.dart';
import 'database_service.dart';

class NutritionService {
  static const String _baseUrl = 'https://api.nal.usda.gov/fdc/v1';
  static const String _apiKey = 'DEMO_KEY'; 
  
  final DatabaseService _databaseService = DatabaseService();

 
  Future<List<AlimentoModel>> searchFoods(String query) async {
    try {
     
      final cachedFoods = await _searchCachedFoods(query);
      if (cachedFoods.isNotEmpty) {
        return cachedFoods;
      }

      
      final url = Uri.parse('$_baseUrl/foods/search?api_key=$_apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'pageSize': 10,
          'dataType': ['Foundation', 'SR Legacy'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = <AlimentoModel>[];

        for (var food in data['foods']) {
          final alimento = _parseUSDAFood(food);
          if (alimento != null) {
            foods.add(alimento);
           
            await _cacheFood(alimento, food['fdcId'].toString());
          }
        }

        return foods;
      } else {
        throw Exception('Erro ao buscar alimentos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no serviço de nutrição: $e');
      
      return _getMockFoods(query);
    }
  }

 
  Future<List<AlimentoModel>> _searchCachedFoods(String query) async {
    final cachedFoods = await _databaseService.searchAlimentos(query);
    return cachedFoods.map((food) => AlimentoModel(
      nome: food['nome'],
      calorias: food['calorias'],
      carboidratos: food['carboidratos'],
      proteinas: food['proteinas'],
      gorduras: food['gorduras'],
    )).toList();
  }

 
  AlimentoModel? _parseUSDAFood(Map<String, dynamic> food) {
    try {
      final nutrients = food['foodNutrients'] as List;
      
      double calorias = 0;
      double carboidratos = 0;
      double proteinas = 0;
      double gorduras = 0;

      for (var nutrient in nutrients) {
        final nutrientNumber = nutrient['nutrientNumber']?.toString();
        final amount = (nutrient['value'] ?? 0).toDouble();

        switch (nutrientNumber) {
          case '208': // Energia (kcal)
            calorias = amount;
            break;
          case '205': // Carboidratos
            carboidratos = amount;
            break;
          case '203': // Proteínas
            proteinas = amount;
            break;
          case '204': // Gorduras totais
            gorduras = amount;
            break;
        }
      }

      return AlimentoModel(
        nome: food['description'] ?? 'Alimento desconhecido',
        calorias: calorias,
        carboidratos: carboidratos,
        proteinas: proteinas,
        gorduras: gorduras,
      );
    } catch (e) {
      print('Erro ao converter alimento USDA: $e');
      return null;
    }
  }

 
  Future<void> _cacheFood(AlimentoModel alimento, String fdcId) async {
    await _databaseService.insertAlimento({
      'nome': alimento.nome,
      'calorias': alimento.calorias,
      'carboidratos': alimento.carboidratos,
      'proteinas': alimento.proteinas,
      'gorduras': alimento.gorduras,
      'fonte': 'USDA',
      'fdc_id': fdcId,
    });
  }


  List<AlimentoModel> _getMockFoods(String query) {
    final mockFoods = [
      AlimentoModel(
        nome: 'Arroz branco cozido',
        calorias: 130,
        carboidratos: 28,
        proteinas: 2.7,
        gorduras: 0.3,
      ),
      AlimentoModel(
        nome: 'Feijão preto cozido',
        calorias: 132,
        carboidratos: 24,
        proteinas: 8.9,
        gorduras: 0.5,
      ),
      AlimentoModel(
        nome: 'Peito de frango grelhado',
        calorias: 165,
        carboidratos: 0,
        proteinas: 31,
        gorduras: 3.6,
      ),
      AlimentoModel(
        nome: 'Banana',
        calorias: 89,
        carboidratos: 23,
        proteinas: 1.1,
        gorduras: 0.3,
      ),
      AlimentoModel(
        nome: 'Aveia',
        calorias: 389,
        carboidratos: 66,
        proteinas: 17,
        gorduras: 7,
      ),
    ];

    return mockFoods
        .where((food) => food.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<AlimentoModel?> getFoodDetails(String fdcId) async {
    try {
      final url = Uri.parse('$_baseUrl/food/$fdcId?api_key=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUSDAFood(data);
      }
    } catch (e) {
      print('Erro ao obter detalhes do alimento: $e');
    }
    return null;
  }


  Map<String, double> calculateMealNutrition(List<AlimentoModel> alimentos) {
    double totalCalorias = 0;
    double totalCarboidratos = 0;
    double totalProteinas = 0;
    double totalGorduras = 0;

    for (var alimento in alimentos) {
      totalCalorias += alimento.calorias;
      totalCarboidratos += alimento.carboidratos;
      totalProteinas += alimento.proteinas;
      totalGorduras += alimento.gorduras;
    }

    return {
      'calorias': totalCalorias,
      'carboidratos': totalCarboidratos,
      'proteinas': totalProteinas,
      'gorduras': totalGorduras,
    };
  }


  Future<void> clearOldCache() async {
    await _databaseService.clearOldCache();
  }
}

