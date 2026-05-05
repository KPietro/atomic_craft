import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/atomo_component.dart';
import 'components/lixeira_component.dart';
import 'components/ligacao_component.dart';
import '../data/elementos_data.dart';

class AtomCGame extends FlameGame with HasCollisionDetection {
  bool isDark = false;
  int etapaAtual = 1;
  int tipoLigacaoSelecionada = 1;

  final Function(int) onUnlock;
  final Function(String) onMoleculaCriada; // Novo: Avisa quando criar molécula!

  AtomCGame({required this.onUnlock, required this.onMoleculaCriada});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    add(LixeiraComponent());
  }

  // Novo spawn que permite dizer ONDE o átomo vai nascer (útil pro Drag and Drop)
  void spawnElement(int index, {Vector2? posicao}) {
    final atomo = AtomoComponent(listaElementos[index]);
    atomo.position = posicao ?? (size / 2);
    add(atomo);
  }

  int contarLigacoesAtuais(AtomoComponent atomo) {
    int total = 0;
    final ligacoes = children.query<LigacaoComponent>();
    for (var ligacao in ligacoes) {
      if (ligacao.atomoA == atomo || ligacao.atomoB == atomo) {
        total += ligacao.tipoLigacao;
      }
    }
    return total;
  }

  // --- GERADOR DA FÓRMULA QUÍMICA ---
  String gerarFormulaQuimica(Map<int, int> contagemAtomos) {
    String formula = "";
    const subscritos = {
      '0': '₀',
      '1': '₁',
      '2': '₂',
      '3': '₃',
      '4': '₄',
      '5': '₅',
      '6': '₆',
      '7': '₇',
      '8': '₈',
      '9': '₉',
    };

    String numeroParaSubscrito(int num) {
      if (num <= 1) return "";
      return num.toString().split('').map((c) => subscritos[c]!).join('');
    }

    Map<String, int> contagemSimbolos = {};
    contagemAtomos.forEach((num, qtd) {
      contagemSimbolos[listaElementos[num]['simbolo']] = qtd;
    });

    // Regra de Hill (C primeiro, H depois, resto alfabético)
    if (contagemSimbolos.containsKey('C')) {
      formula += "C${numeroParaSubscrito(contagemSimbolos['C']!)}";
      contagemSimbolos.remove('C');
      if (contagemSimbolos.containsKey('H')) {
        formula += "H${numeroParaSubscrito(contagemSimbolos['H']!)}";
        contagemSimbolos.remove('H');
      }
    }

    var letrasRestantes = contagemSimbolos.keys.toList()..sort();
    for (var simb in letrasRestantes) {
      formula += "$simb${numeroParaSubscrito(contagemSimbolos[simb]!)}";
    }
    return formula;
  }

  // --- VARREDURA DA MOLÉCULA ---
  void _descobrirMolecula(AtomoComponent inicio) {
    final visitados = <AtomoComponent>{};
    final fila = <AtomoComponent>[inicio];

    // Navega pelas linhas pra descobrir quem tá conectado com quem
    while (fila.isNotEmpty) {
      final atual = fila.removeAt(0);
      if (!visitados.contains(atual)) {
        visitados.add(atual);
        final ligacoes = children.query<LigacaoComponent>();
        for (var lig in ligacoes) {
          if (lig.atomoA == atual && !visitados.contains(lig.atomoB))
            fila.add(lig.atomoB);
          else if (lig.atomoB == atual && !visitados.contains(lig.atomoA))
            fila.add(lig.atomoA);
        }
      }
    }

    // Conta quantos átomos de cada tipo tem no desenho
    Map<int, int> contagem = {};
    for (var atomo in visitados) {
      int numAtomico = atomo.dados['numero'];
      contagem[numAtomico] = (contagem[numAtomico] ?? 0) + 1;
    }

    if (visitados.length > 1) {
      // Tem que ter no mínimo 2 átomos interligados
      String formula = gerarFormulaQuimica(contagem);
      onMoleculaCriada(formula); // Manda pra página inicial!
    }
  }

  void verificarInteracao(AtomoComponent movido) {
    final lixeiras = children.query<LixeiraComponent>();
    if (lixeiras.isNotEmpty) {
      if (movido.toAbsoluteRect().overlaps(lixeiras.first.toAbsoluteRect())) {
        remove(movido);
        final ligacoes = children.query<LigacaoComponent>();
        for (var ligacao in ligacoes) {
          if (ligacao.atomoA == movido || ligacao.atomoB == movido)
            remove(ligacao);
        }
        return;
      }
    }

    final outros = children.query<AtomoComponent>();
    for (var outro in outros) {
      if (outro == movido) continue;
      if (movido.collidingWith(outro)) {
        if (etapaAtual == 1) {
          int soma = movido.dados['numero'] + outro.dados['numero'];
          if (soma < listaElementos.length) {
            final posFinal = outro.position.clone();
            remove(movido);
            remove(outro);
            add(AtomoComponent(listaElementos[soma])..position = posFinal);
            onUnlock(soma);
            break;
          }
        } else if (etapaAtual == 2) {
          bool jaLigados = children.query<LigacaoComponent>().any(
            (lig) =>
                (lig.atomoA == movido && lig.atomoB == outro) ||
                (lig.atomoA == outro && lig.atomoB == movido),
          );

          if (!jaLigados) {
            int numeroA = movido.dados['numero'];
            int numeroB = outro.dados['numero'];

            int valMaxA = valenciasMaximas[numeroA] ?? 8;
            int valMaxB = valenciasMaximas[numeroB] ?? 8;

            if (contarLigacoesAtuais(movido) + tipoLigacaoSelecionada <=
                    valMaxA &&
                contarLigacoesAtuais(outro) + tipoLigacaoSelecionada <=
                    valMaxB) {
              // Cria a linha!
              add(LigacaoComponent(movido, outro, tipoLigacaoSelecionada));

              // Faz a varredura pra ler a molécula
              _descobrirMolecula(movido);
            }
          }
          // Afasta os quadrados pra não colar
          movido.position.x -= 35;
          movido.position.y -= 35;
          break;
        }
      }
    }
  }
}
