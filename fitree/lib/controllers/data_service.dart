import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataService {
  // Apenas armazena o índice selecionado no BottomNavigationBar
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void onBottomNavTapped(int index) {
    selectedIndex.value = index;
  }
}

final dataService = DataService();
