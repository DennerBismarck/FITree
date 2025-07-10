// models/agua_lembrete_model.dart
import 'package:flutter/material.dart';

class WaterReminderModel {
  final String id;
  final TimeOfDay time;
  bool isActive;

  WaterReminderModel({
    required this.id,
    required this.time,
    this.isActive = true,
  });
}