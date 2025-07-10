// models/agua_log_model.dart
class WaterLogModel {
  final String id; 
  final double amountMl; 
  final DateTime timestamp; 

  WaterLogModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });
}