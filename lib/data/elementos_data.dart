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

const Map<int, Map<String, dynamic>> regrasQuimicas = {
  1: {
    'max': 1,
    'estaveis': [1],
    'bloqueiaMultipla': true,
  }, // H: Regra do dueto, só 1 ligação simples
  2: {
    'max': 0,
    'estaveis': [0],
    'bloqueiaMultipla': true,
  }, // He: Gás Nobre
  4: {
    'max': 2,
    'estaveis': [2],
    'bloqueiaMultipla': true,
  }, // Be: Octeto incompleto
  5: {
    'max': 3,
    'estaveis': [3],
    'bloqueiaMultipla': false,
  }, // B: Octeto incompleto
  6: {
    'max': 4,
    'estaveis': [4],
    'bloqueiaMultipla': false,
  }, // C: Octeto clássico (4)
  7: {
    'max': 4,
    'estaveis': [3, 4],
    'bloqueiaMultipla': false,
  }, // N: Estável com 3, mas faz 4 (íon amônio)
  8: {
    'max': 3,
    'estaveis': [2, 3],
    'bloqueiaMultipla': false,
  }, // O: Estável com 2, mas faz 3 (ozônio/hidrônio)
  9: {
    'max': 1,
    'estaveis': [1],
    'bloqueiaMultipla': true,
  }, // F: Halogênio, apenas 1 ligação simples
  10: {
    'max': 0,
    'estaveis': [0],
    'bloqueiaMultipla': true,
  }, // Ne: Gás Nobre
  14: {
    'max': 4,
    'estaveis': [4],
    'bloqueiaMultipla': false,
  }, // Si: Octeto clássico
  15: {
    'max': 5,
    'estaveis': [3, 5],
    'bloqueiaMultipla': false,
  }, // P: Octeto Expandido (3 ou 5)
  16: {
    'max': 6,
    'estaveis': [2, 4, 6],
    'bloqueiaMultipla': false,
  }, // S: Octeto Expandido (2, 4 ou 6)
  17: {
    'max': 7,
    'estaveis': [1, 3, 5, 7],
    'bloqueiaMultipla': false,
  }, // Cl: Halogênio expandido
  18: {
    'max': 0,
    'estaveis': [0],
    'bloqueiaMultipla': true,
  }, // Ar: Gás Nobre
  35: {
    'max': 7,
    'estaveis': [1, 3, 5, 7],
    'bloqueiaMultipla': false,
  }, // Br: Halogênio expandido
  53: {
    'max': 7,
    'estaveis': [1, 3, 5, 7],
    'bloqueiaMultipla': false,
  }, // I: Halogênio expandido
  // OBS: Elementos que não estão nessa lista (metais de transição, etc) vão assumir padrão livre no jogo
};
