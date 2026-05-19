import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
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

  // Variáveis para a lógica da Caixa de Seleção (estilo Windows)
  Vector2? inicioSelecao;
  Vector2? fimSelecao;

  // Callbacks para comunicar com a HomePage
  final Function(int) onUnlock; // Para novos elementos na Etapa 1
  final Function(String formula, String estrutura)
  onMoleculaCriada; // Para novas moléculas na Etapa 2

  AtomCGame({required this.onUnlock, required this.onMoleculaCriada});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Adiciona o componente invisível da lixeira no canto superior esquerdo.
    // Isso permite que a lixeira física (arrastar para o canto) funcione junto com o botão.
    add(LixeiraComponent());
  }

  // Cria um novo átomo na tela
  void spawnElement(int index, {Vector2? posicao}) {
    final atomo = AtomoComponent(listaElementos[index]);
    // Se não houver posição, nasce no centro.
    atomo.position = posicao ?? (size / 2);
    add(atomo);
  }

  // --- NOVA FUNÇÃO: LIMPAR O QUADRO ---
  void limparQuadro() {
    children.query<AtomoComponent>().forEach((a) => remove(a));
    children.query<LigacaoComponent>().forEach((l) => remove(l));
    desmarcarTudo(); // Aproveita e tira qualquer ferramenta de seleção ativa
  }

  // --- RECONSTRUTOR DA MOLÉCULA SALVA ---
  void carregarMolecula(String estruturaRaw) {
    if (estruturaRaw.isEmpty) return;

    limparQuadro(); // Usando a nova função para limpar a tela antes de carregar!

    try {
      final dados = jsonDecode(estruturaRaw);
      final List<dynamic> atomosJson = dados['atomos'];
      final List<dynamic> ligacoesJson = dados['ligacoes'];

      // Mapeia IDs salvos para as novas instâncias que vão nascer na tela
      Map<int, AtomoComponent> novosAtomos = {};

      // 1. Spawna os átomos nas posições exatas de antes
      for (var aJson in atomosJson) {
        int id = aJson['id'];
        int numero = aJson['numero'];
        double x = aJson['x'];
        double y = aJson['y'];

        final atomo = AtomoComponent(listaElementos[numero]);
        atomo.position = Vector2(x, y);
        add(atomo);
        novosAtomos[id] = atomo;
      }

      // 2. Reconecta os traços de ligações entre eles
      for (var lJson in ligacoesJson) {
        int de = lJson['de'];
        int para = lJson['para'];
        int tipo = lJson['tipo'];

        final atomoA = novosAtomos[de];
        final atomoB = novosAtomos[para];

        if (atomoA != null && atomoB != null) {
          add(LigacaoComponent(atomoA, atomoB, tipo));
        }
      }
    } catch (e) {
      print("Erro ao carregar estrutura da molécula: $e");
    }
  }

  // --- LÓGICA DO ARRASTE PARA CAIXA DE SELEÇÃO ---
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // Só inicia a caixa de seleção se uma ferramenta (lixeira ou registrar) estiver ativa.
    if (modoFerramenta != 0) {
      inicioSelecao = event.localPosition.clone();
      fimSelecao = event.localPosition.clone();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (modoFerramenta != 0 && inicioSelecao != null && fimSelecao != null) {
      // Atualiza o ponto final da seleção baseando-se no movimento (delta).
      fimSelecao!.add(event.localDelta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    // Quando o arraste termina, verifica quais átomos estão dentro do retângulo.
    if (modoFerramenta != 0 && inicioSelecao != null && fimSelecao != null) {
      final rectSelecao = Rect.fromPoints(
        inicioSelecao!.toOffset(),
        fimSelecao!.toOffset(),
      );

      final atomos = children.query<AtomoComponent>();
      for (var a in atomos) {
        if (rectSelecao.overlaps(a.toAbsoluteRect())) {
          a.selecionado = true; // Marca o átomo como selecionado.
        }
      }
    }
    // Reseta as variáveis da caixa visual.
    inicioSelecao = null;
    fimSelecao = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Renderiza os átomos e ligações primeiro.

    // Desenha a "Caixa do Windows" transparente por cima para feedback visual.
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
    // Coleta todos os átomos marcados como selecionados.
    final selecionados = children
        .query<AtomoComponent>()
        .where((a) => a.selecionado)
        .toList();
    if (selecionados.isEmpty) return;

    if (modoFerramenta == 1) {
      // AÇÃO: DELETAR VIA SELEÇÃO MULTIPLA
      for (var atomo in selecionados) {
        remove(atomo);
        // Remove também quaisquer ligações conectadas a este átomo.
        final ligacoes = children.query<LigacaoComponent>();
        for (var lig in ligacoes) {
          if (lig.atomoA == atomo || lig.atomoB == atomo) remove(lig);
        }
      }
    } else if (modoFerramenta == 2) {
      // AÇÃO: REGISTRAR MOLÉCULA
      // DESCOBERTA DE MÚLTIPLAS MOLÉCULAS NA SELEÇÃO
      List<String> formulasIndividuais = [];
      Set<AtomoComponent> visitados = {};
      List<AtomoComponent> selecionadosRestantes = List.from(selecionados);

      // Fica em loop enquanto ainda tiver átomo selecionado solto pelo quadro
      while (selecionadosRestantes.isNotEmpty) {
        AtomoComponent inicio = selecionadosRestantes.first;
        List<AtomoComponent> fila = [inicio];
        Map<int, int> contagemDaSubMolecula = {};

        // Segue as linhas de ligação para ver o tamanho exato DESSA molécula
        while (fila.isNotEmpty) {
          AtomoComponent atual = fila.removeAt(0);
          if (!visitados.contains(atual)) {
            visitados.add(atual);
            selecionadosRestantes.remove(atual);

            int num = atual.dados['numero'];
            contagemDaSubMolecula[num] = (contagemDaSubMolecula[num] ?? 0) + 1;

            final ligacoes = children.query<LigacaoComponent>();
            for (var lig in ligacoes) {
              if (lig.atomoA == atual &&
                  selecionados.contains(lig.atomoB) &&
                  !visitados.contains(lig.atomoB)) {
                fila.add(lig.atomoB);
              } else if (lig.atomoB == atual &&
                  selecionados.contains(lig.atomoA) &&
                  !visitados.contains(lig.atomoA)) {
                fila.add(lig.atomoA);
              }
            }
          }
        }
        // Gera a fórmula só desse bloquinho que ele encontrou ligado
        formulasIndividuais.add(gerarFormulaQuimica(contagemDaSubMolecula));
      }

      // MUDANÇA AQUI: Lógica gramatical para vírgulas e o "e" final.
      String formulaFinal = "";
      if (formulasIndividuais.length == 1) {
        formulaFinal = formulasIndividuais.first;
      } else if (formulasIndividuais.length == 2) {
        formulaFinal = formulasIndividuais.join(" e ");
      } else if (formulasIndividuais.isNotEmpty) {
        String ultimaFormula = formulasIndividuais.removeLast();
        formulaFinal = "${formulasIndividuais.join(', ')} e $ultimaFormula";
      }

      // --- SERIALIZAÇÃO GEOMÉTRICA (Átomos e Traços) ---
      List<Map<String, dynamic>> atomosJson = [];
      Map<AtomoComponent, int> mapaIds = {};

      for (int i = 0; i < selecionados.length; i++) {
        final a = selecionados[i];
        mapaIds[a] =
            i; // Atribui um ID numérico indexado para as ligações referenciarem
        atomosJson.add({
          'id': i,
          'numero': a.dados['numero'],
          'x': a.position.x,
          'y': a.position.y,
        });
      }

      List<Map<String, dynamic>> ligacoesJson = [];
      final ligacoes = children.query<LigacaoComponent>();
      for (var lig in ligacoes) {
        if (mapaIds.containsKey(lig.atomoA) &&
            mapaIds.containsKey(lig.atomoB)) {
          ligacoesJson.add({
            'de': mapaIds[lig.atomoA],
            'para': mapaIds[lig.atomoB],
            'tipo': lig.tipoLigacao,
          });
        }
      }

      String estruturaCompilada = jsonEncode({
        'atomos': atomosJson,
        'ligacoes': ligacoesJson,
      });

      // Dispara os dados estruturais completos pro app salvar
      onMoleculaCriada(formulaFinal, estruturaCompilada);

      // Limpa os átomos usados na síntese da tela.
      for (var atomo in selecionados) {
        remove(atomo);
        final ligacoes = children.query<LigacaoComponent>();
        for (var lig in ligacoes) {
          if (lig.atomoA == atomo || lig.atomoB == atomo) remove(lig);
        }
      }
    }
    desmarcarTudo(); // Sai do modo de ferramenta.
  }

  // Limpa a seleção visual e reseta o modo.
  void desmarcarTudo() {
    final atomos = children.query<AtomoComponent>();
    for (var a in atomos) {
      a.selecionado = false;
    }
    modoFerramenta = 0;
  }

  // Helper para contar quantas ligações um átomo já possui.
  int contarLigacoesAtuais(AtomoComponent atomo) {
    int total = 0;
    final ligacoes = children.query<LigacaoComponent>();
    for (var ligacao in ligacoes) {
      if (ligacao.atomoA == atomo || ligacao.atomoB == atomo) {
        total += ligacao.tipoLigacao; // Soma 1 para simples, 2 para dupla, etc.
      }
    }
    return total;
  }

  // Gera a fórmula química textual seguindo a Regra de Hill (C, depois H, depois ordem alfabética).
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

    // Regra de Hill: C primeiro, depois H.
    if (contagemSimbolos.containsKey('C')) {
      formula += "C${numeroParaSubscrito(contagemSimbolos['C']!)}";
      contagemSimbolos.remove('C');
      if (contagemSimbolos.containsKey('H')) {
        formula += "H${numeroParaSubscrito(contagemSimbolos['H']!)}";
        contagemSimbolos.remove('H');
      }
    }
    // Resto em ordem alfabética.
    var letrasRestantes = contagemSimbolos.keys.toList()..sort();
    for (var simb in letrasRestantes) {
      formula += "$simb${numeroParaSubscrito(contagemSimbolos[simb]!)}";
    }
    return formula;
  }

  // Lógica principal de interação quando um átomo é solto após o arraste.
  void verificarInteracao(AtomoComponent movido) {
    // 1. PRIMEIRA MECÂNICA DA LIXEIRA: ARRASTAR ATÉ O CANTO SUPERIOR ESQUERDO
    // Verifica se o átomo colidiu com o componente invisível da lixeira.
    final lixeiras = children.query<LixeiraComponent>();
    if (lixeiras.isNotEmpty) {
      if (movido.toAbsoluteRect().overlaps(lixeiras.first.toAbsoluteRect())) {
        remove(movido);
        final ligacoes = children.query<LigacaoComponent>();
        for (var ligacao in ligacoes) {
          if (ligacao.atomoA == movido || ligacao.atomoB == movido)
            remove(ligacao);
        }
        return; // Átomo deletado, encerra a função.
      }
    }

    // 2. FUSÃO (ETAPA 1) OU LIGAÇÕES (ETAPA 2)
    final outros = children.query<AtomoComponent>();
    for (var outro in outros) {
      if (outro == movido) continue;
      if (movido.collidingWith(outro)) {
        // ETAPA 1: Síntese Nuclear (Fusão)
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
        }
        // ETAPA 2: Síntese Molecular (Ligações)
        else if (etapaAtual == 2) {
          // Verifica se eles já não estão conectados.
          bool jaLigados = children.query<LigacaoComponent>().any(
            (lig) =>
                (lig.atomoA == movido && lig.atomoB == outro) ||
                (lig.atomoA == outro && lig.atomoB == movido),
          );

          if (!jaLigados) {
            int numA = movido.dados['numero'];
            int numB = outro.dados['numero'];

            // Lê as regras químicas específicas de cada elemento.
            var regraA = regrasQuimicas[numA];
            var regraB = regrasQuimicas[numB];

            int valMaxA = regraA != null
                ? regraA['max']
                : 8; // Padrão 8 se não houver regra.
            int valMaxB = regraB != null ? regraB['max'] : 8;

            bool bloqueiaMultiplaA = regraA != null
                ? regraA['bloqueiaMultipla']
                : false;
            bool bloqueiaMultiplaB = regraB != null
                ? regraB['bloqueiaMultipla']
                : false;

            // Validação Química:
            // 1. Impede ligações duplas/triplas se um dos elementos não suportar (ex: Hidrogênio).
            if (tipoLigacaoSelecionada > 1 &&
                (bloqueiaMultiplaA || bloqueiaMultiplaB)) {
              // Mantido o print interno como estava
              print("Ligação inválida.");
            }
            // 2. Verifica se a nova ligação excede a valência máxima permitida.
            else if (contarLigacoesAtuais(movido) + tipoLigacaoSelecionada <=
                    valMaxA &&
                contarLigacoesAtuais(outro) + tipoLigacaoSelecionada <=
                    valMaxB) {
              add(LigacaoComponent(movido, outro, tipoLigacaoSelecionada));
            }
          }
          break;
        }
      }
    }
  }
}
