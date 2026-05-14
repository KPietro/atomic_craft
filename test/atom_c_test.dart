import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:atomic_craft/data/db_helper.dart';
import 'package:atomic_craft/game/atom_game.dart';
import 'package:atomic_craft/data/elementos_data.dart';

void main() {
  // 1. SETUP DO BANCO DE DADOS PARA O TESTE
  // Isso diz ao Flutter para usar a simulação de banco de dados no PC
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // =========================================================
  // GRUPO 1: TESTANDO OS FUTURES (MÉTODOS ASSÍNCRONOS)
  // =========================================================
  group("Testes Assíncronos (Future) - Banco de Dados:", () {
    test(
      "O método getDesbloqueados deve iniciar contendo o Hidrogênio (1)",
      () async {
        // O "await" resolve o Future antes do teste continuar
        List<int> desbloqueados = await DbHelper.instance.getDesbloqueados();

        // Verificamos se a lista não é nula e se contém o número 1
        expect(desbloqueados, isNotNull);
        expect(desbloqueados, contains(1));
      },
    );

    test(
      "O método addMolecula (Future) deve salvar uma nova fórmula no banco",
      () async {
        // Aguardamos o Future de salvar
        await DbHelper.instance.addMolecula("H₂O");

        // Aguardamos o Future de ler a lista atualizada
        List<String> moleculas = await DbHelper.instance.getMoleculas();

        // A lista final deve conter a molécula que acabamos de sintetizar
        expect(moleculas, contains("H₂O"));
      },
    );
  });

  // =========================================================
  // GRUPO 2: TESTE DE UNIDADE SÍNCRONO (Lógica do Jogo)
  // =========================================================
  group("Testes de Unidade - Lógica de Química:", () {
    test(
      "A função gerarFormulaQuimica deve aplicar a Regra de Hill (C, H, alfabética)",
      () {
        // Como não estamos rodando o app real e lendo o JSON,
        // populamos a lista global "listaElementos" com os átomos necessários para o teste.
        listaElementos = List.generate(
          10,
          (index) => {},
        ); // Cria posições vazias
        listaElementos[1] = {'numero': 1, 'simbolo': 'H'};
        listaElementos[6] = {'numero': 6, 'simbolo': 'C'};
        listaElementos[8] = {'numero': 8, 'simbolo': 'O'};

        // Inicializa o jogo com funções vazias apenas para acessar seus métodos internos
        final game = AtomCGame(
          onUnlock: (numero) {},
          onMoleculaCriada: (formula) {},
        );

        // Simulamos a contagem gerada ao conectar: 2 Carbonos, 6 Hidrogênios, 1 Oxigênio (Etanol)
        Map<int, int> atomosEtanol = {6: 2, 1: 6, 8: 1};

        // Executamos a lógica de fato
        String resultado = game.gerarFormulaQuimica(atomosEtanol);

        // Verificamos se o gerador transformou os números em subscritos na ordem exata: C₂H₆O
        expect(resultado, equals("C₂H₆O"));
      },
    );
  });
}
