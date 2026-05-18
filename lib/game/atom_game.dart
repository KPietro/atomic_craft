import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'components/atomo_component.dart';
import 'components/lixeira_component.dart';
import 'components/ligacao_component.dart';
import '../data/elementos_data.dart';

// --- MOTOR DO JOGO ---
class AtomCGame extends FlameGame with HasCollisionDetection, DragCallbacks {
  bool isDark = false;
  int etapaAtual = 1;
  int tipoLigacaoSelecionada = 1;
  int modoFerramenta =
      0; // 0 = Normal, 1 = Lixeira(Vermelho), 2 = Registrar(Verde)

  Vector2? inicioSelecao;
  Vector2? fimSelecao;

  final Function(int) onUnlock;
  final Function(String) onMoleculaCriada;

  AtomCGame({required this.onUnlock, required this.onMoleculaCriada});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    add(LixeiraComponent());
  }

  void spawnElement(int index, {Vector2? posicao}) {
    final atomo = AtomoComponent(listaElementos[index]);
    atomo.position = posicao ?? (size / 2);
    add(atomo);
  }

  // --- LÓGICA DA CAIXA DE SELEÇÃO ESTILO WINDOWS ---
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (modoFerramenta != 0) {
      inicioSelecao = event.localPosition.clone();
      fimSelecao = event.localPosition.clone();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (modoFerramenta != 0 && inicioSelecao != null && fimSelecao != null) {
      fimSelecao!.add(event.localDelta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (modoFerramenta != 0 && inicioSelecao != null && fimSelecao != null) {
      final rectSelecao = Rect.fromPoints(
        inicioSelecao!.toOffset(),
        fimSelecao!.toOffset(),
      );

      final atomos = children.query<AtomoComponent>();
      for (var a in atomos) {
        if (rectSelecao.overlaps(a.toAbsoluteRect())) {
          a.selecionado = true;
        }
      }
    }
    inicioSelecao = null;
    fimSelecao = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (modoFerramenta != 0 && inicioSelecao != null && fimSelecao != null) {
      final paint = Paint()
        ..color = (modoFerramenta == 1 ? Colors.red : Colors.green).withOpacity(
          0.2,
        )
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = modoFerramenta == 1 ? Colors.red : Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final rect = Rect.fromPoints(
        inicioSelecao!.toOffset(),
        fimSelecao!.toOffset(),
      );
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    }
  }

  // --- FUNÇÕES DE CONFIRMAÇÃO DAS FERRAMENTAS ---
  void confirmarAcao() {
    final selecionados = children
        .query<AtomoComponent>()
        .where((a) => a.selecionado)
        .toList();
    if (selecionados.isEmpty) return;

    if (modoFerramenta == 1) {
      // DELETAR VIA SELEÇÃO MULTIPLA
      for (var atomo in selecionados) {
        remove(atomo);
        final ligacoes = children.query<LigacaoComponent>();
        for (var lig in ligacoes) {
          if (lig.atomoA == atomo || lig.atomoB == atomo) remove(lig);
        }
      }
    } else if (modoFerramenta == 2) {
      // REGISTRAR MOLÉCULA
      Map<int, int> contagem = {};
      for (var atomo in selecionados) {
        int num = atomo.dados['numero'];
        contagem[num] = (contagem[num] ?? 0) + 1;
      }

      String formula = gerarFormulaQuimica(contagem);
      onMoleculaCriada(formula);

      for (var atomo in selecionados) {
        remove(atomo);
        final ligacoes = children.query<LigacaoComponent>();
        for (var lig in ligacoes) {
          if (lig.atomoA == atomo || lig.atomoB == atomo) remove(lig);
        }
      }
    }
    desmarcarTudo();
  }

  void desmarcarTudo() {
    final atomos = children.query<AtomoComponent>();
    for (var a in atomos) {
      a.selecionado = false;
    }
    modoFerramenta = 0;
  }

  int contarLigacoesAtuais(AtomoComponent atomo) {
    int total = 0;
    final ligacoes = children.query<LigacaoComponent>();
    for (var ligacao in ligacoes) {
      if (ligacao.atomoA == atomo || ligacao.atomoB == atomo)
        total += ligacao.tipoLigacao;
    }
    return total;
  }

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
    contagemAtomos.forEach(
      (num, qtd) => contagemSimbolos[listaElementos[num]['simbolo']] = qtd,
    );

    if (contagemSimbolos.containsKey('C')) {
      formula += "C${numeroParaSubscrito(contagemSimbolos['C']!)}";
      contagemSimbolos.remove('C');
      if (contagemSimbolos.containsKey('H')) {
        formula += "H${numeroParaSubscrito(contagemSimbolos['H']!)}";
        contagemSimbolos.remove('H');
      }
    }
    var letrasRestantes = contagemSimbolos.keys.toList()..sort();
    for (var simb in letrasRestantes)
      formula += "$simb${numeroParaSubscrito(contagemSimbolos[simb]!)}";
    return formula;
  }

  void verificarInteracao(AtomoComponent movido) {
    // 1. PRIMEIRA MECÂNICA DA LIXEIRA: ARRASTAR ATÉ O CANTO SUPERIOR ESQUERDO
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

    // 2. FUSÃO OU LIGAÇÕES ENTRE ÁTOMOS
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
            int numA = movido.dados['numero'];
            int numB = outro.dados['numero'];

            var regraA = regrasQuimicas[numA];
            var regraB = regrasQuimicas[numB];

            int valMaxA = regraA != null ? regraA['max'] : 8;
            int valMaxB = regraB != null ? regraB['max'] : 8;

            bool bloqueiaMultiplaA = regraA != null
                ? regraA['bloqueiaMultipla']
                : false;
            bool bloqueiaMultiplaB = regraB != null
                ? regraB['bloqueiaMultipla']
                : false;

            // REGRA 1: Bloqueia dupla/tripla em átomos que não suportam (ex: Hidrogênio, Flúor)
            if (tipoLigacaoSelecionada > 1 &&
                (bloqueiaMultiplaA || bloqueiaMultiplaB)) {
              print(
                "Ligação negada: Um dos átomos não suporta ligações múltiplas.",
              );
            }
            // REGRA 2: Verifica se a ligação estoura a valência máxima do átomo
            else if (contarLigacoesAtuais(movido) + tipoLigacaoSelecionada <=
                    valMaxA &&
                contarLigacoesAtuais(outro) + tipoLigacaoSelecionada <=
                    valMaxB) {
              add(LigacaoComponent(movido, outro, tipoLigacaoSelecionada));
            } else {
              print("Ligação negada: Excedeu o limite máximo de ligações.");
            }
          }

          break;
        }
      }
    }
  }
}
