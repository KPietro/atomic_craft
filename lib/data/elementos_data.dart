import 'dart:convert';
import 'package:flutter/services.dart';

// As variáveis exatamente com os mesmos nomes que você já usava
List<Map<String, dynamic>> listaElementos = [];
Map<int, String> principaisMoleculas = {};

Future<void> carregarDados() async {
  // 1. Carrega a lista de elementos
  final String jsonElementos = await rootBundle.loadString(
    'assets/data/elementos.json',
  );
  final List<dynamic> dadosElementos = jsonDecode(jsonElementos);
  listaElementos = dadosElementos.cast<Map<String, dynamic>>();

  // 2. Carrega o dicionário de moléculas
  final String jsonMoleculas = await rootBundle.loadString(
    'assets/data/moleculas.json',
  );
  final Map<String, dynamic> dadosMoleculas = jsonDecode(jsonMoleculas);

  // Converte a chave do JSON (que é String) de volta para int (para não quebrar seu código)
  dadosMoleculas.forEach((key, value) {
    principaisMoleculas[int.parse(key)] = value.toString();
  });
}

// Adicione isso no final do seu elementos_data.dart
const Map<int, int> valenciasMaximas = {
  1: 1, // Hidrogênio (H) - 1 ligação
  6: 4, // Carbono (C) - 4 ligações
  7: 3, // Nitrogênio (N) - 3 ligações
  8: 2, // Oxigênio (O) - 2 ligações
  9: 1, // Flúor (F) - 1 ligação
  15: 5, // Fósforo (P) - até 5
  16: 6, // Enxofre (S) - até 6
  17: 1, // Cloro (Cl) - 1 ligação
  // ... adicione mais halogênios e ametais depois
};
