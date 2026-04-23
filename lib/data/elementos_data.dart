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
