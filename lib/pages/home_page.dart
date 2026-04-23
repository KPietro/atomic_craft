import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../data/elementos_data.dart';
import '../game/atom_game.dart';

// Retirei o _ do nome para ele poder ser importado lá no main.dart
class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const HomePage({super.key, required this.onThemeToggle});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;
  bool tutol = false;
  late AtomCGame game;

  // --- FUNÇÃO PARA MOSTRAR DETALHES DO ELEMENTO ---
  void _mostrarDetalhesElemento(Map<String, dynamic> elemento, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          title: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    elemento['simbolo'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  "${elemento['numero']} - ${elemento['nome']}",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Peso Atômico: ${elemento['peso']}u",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const Text(
                  "Características e Usos:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  elemento['caracteristicas'] ?? "Informações em pesquisa...",
                ),
                const SizedBox(height: 10),
                const Text(
                  "Moléculas Principais:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  elemento['moleculas_principais'] ??
                      principaisMoleculas[elemento['numero']] ??
                      "Nenhuma molécula catalogada ainda.",
                ),
                const SizedBox(height: 10),
                const Text(
                  "História e Descoberta:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  elemento['historia'] ??
                      "A história da síntese/descoberta deste elemento está sendo catalogada...",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Fechar",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // Guarda os desbloqueios em ordem
  List<int> elementosDesbloqueados = [1];

  @override
  void initState() {
    super.initState();
    game = AtomCGame(
      onUnlock: (novoNumero) {
        if (!elementosDesbloqueados.contains(novoNumero)) {
          setState(() {
            elementosDesbloqueados.add(novoNumero);
          });
        }
      },
    );
  }

  // --- FUNÇÃO AUXILIAR PARA A TABELA PERIÓDICA ---
  List<int> _obterPosicaoTabela(int n) {
    int col = 0;
    int row = 0;
    if (n == 1) {
      col = 0;
      row = 0;
    } else if (n == 2) {
      col = 17;
      row = 0;
    } else if (n >= 3 && n <= 4) {
      col = n - 3;
      row = 1;
    } else if (n >= 5 && n <= 10) {
      col = n + 7;
      row = 1;
    } else if (n >= 11 && n <= 12) {
      col = n - 11;
      row = 2;
    } else if (n >= 13 && n <= 18) {
      col = n - 1;
      row = 2;
    } else if (n >= 19 && n <= 36) {
      col = n - 19;
      row = 3;
    } else if (n >= 37 && n <= 54) {
      col = n - 37;
      row = 4;
    } else if (n >= 55 && n <= 56) {
      col = n - 55;
      row = 5;
    }
    // Lantanídeos (57-71) centralizados na linha 7 (colunas 2 a 16)
    else if (n >= 57 && n <= 71) {
      col = n - 55;
      row = 7;
    } else if (n >= 72 && n <= 86) {
      col = n - 69;
      row = 5;
    } else if (n >= 87 && n <= 88) {
      col = n - 87;
      row = 6;
    }
    // Actinídeos (89-103) centralizados na linha 8 (colunas 2 a 16)
    else if (n >= 89 && n <= 103) {
      col = n - 87;
      row = 8;
    } else if (n >= 104 && n <= 118) {
      col = n - 101;
      row = 6;
    }
    return [col, row];
  }

  // --- FUNÇÃO PARA DEFINIR A COR DA FAMÍLIA ---
  Color _obterCorFamilia(int n, bool isDark) {
    Color base;

    if (n == 1 || (n >= 6 && n <= 8) || n == 15 || n == 16 || n == 34) {
      base = Colors.green; // Não-metais
    } else if (n == 2 ||
        n == 10 ||
        n == 18 ||
        n == 36 ||
        n == 54 ||
        n == 86 ||
        n == 118) {
      base = Colors.cyan; // Gases Nobres
    } else if (n == 3 || n == 11 || n == 19 || n == 37 || n == 55 || n == 87) {
      base = Colors.orange; // Metais Alcalinos
    } else if (n == 4 || n == 12 || n == 20 || n == 38 || n == 56 || n == 88) {
      base = Colors.yellow; // Alcalinoterrosos
    } else if ((n >= 21 && n <= 30) ||
        (n >= 39 && n <= 48) ||
        (n >= 72 && n <= 80) ||
        (n >= 104 && n <= 112)) {
      base = Colors.pinkAccent; // Metais de Transição
    } else if (n == 5 || n == 14 || n == 32 || n == 33 || n == 51 || n == 52) {
      base = Colors.teal; // Metaloides
    } else if (n == 9 || n == 17 || n == 35 || n == 53 || n == 85 || n == 117) {
      base = Colors.lightBlue; // Halogênios
    } else if (n >= 57 && n <= 71) {
      base = Colors.purpleAccent; // Lantanídeos
    } else if (n >= 89 && n <= 103) {
      base = Colors.deepPurpleAccent; // Actinídeos
    } else {
      base = Colors.blueGrey; // Pós-transição (Al, Ga, Pb, etc)
    }

    // Se o modo escuro estiver ativo, deixamos a cor mais escura/transparente
    return isDark ? base.withOpacity(0.3) : base.withOpacity(0.6);
  }

  // --- WIDGET DA ENCICLOPÉDIA ---
  Widget _buildEnciclopedia(bool isDark) {
    return ListView.builder(
      itemCount: elementosDesbloqueados.length,
      itemBuilder: (context, index) {
        int numElemento = elementosDesbloqueados[index];
        var elemento = listaElementos[numElemento];
        String molecula = principaisMoleculas[numElemento] ?? "Desconhecida";

        return Card(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () => _mostrarDetalhesElemento(
              elemento,
              isDark,
            ), // AQUI: Chama o Pop-up
            leading: CircleAvatar(
              backgroundColor: isDark ? Colors.grey[700] : Colors.blueGrey,
              child: Text(
                elemento['simbolo'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text("${elemento['numero']} - ${elemento['nome']}"),
            subtitle: Text("Molécula: $molecula\nPeso: ${elemento['peso']}u"),
            trailing: const Icon(
              Icons.info_outline,
            ), // Ícone pra indicar que dá pra clicar
          ),
        );
      },
    );
  }

  // --- WIDGET DO STATUS (Tabela Periódica Geométrica) ---
  Widget _buildStatus() {
    const double tamanhoCelula = 65.0;
    const double espacamento = 4.0;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(
        60,
      ), // Margem maior para o usuário poder rolar livremente
      child: Container(
        padding: const EdgeInsets.all(16),
        width: (18 * (tamanhoCelula + espacamento)) + 112,
        height: (10 * (tamanhoCelula + espacamento)) + 250,
        child: Stack(
          children: List.generate(listaElementos.length - 1, (index) {
            var elemento = listaElementos[index + 1];
            int numero = elemento['numero'];
            bool desbloqueado = elementosDesbloqueados.contains(numero);

            List<int> pos = _obterPosicaoTabela(numero);
            double leftPos = pos[0] * (tamanhoCelula + espacamento);
            double topPos =
                pos[1] * (tamanhoCelula + espacamento) +
                (pos[1] >= 7 ? 20.0 : 0.0);

            // AQUI É ONDE A MÁGICA DA COR ACONTECE
            Color corFundo = desbloqueado
                ? _obterCorFamilia(numero, isDark)
                : (isDark
                      ? Colors.grey[800]!.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15));

            return Positioned(
              left: leftPos,
              top: topPos,
              width: tamanhoCelula,
              height: tamanhoCelula,
              child: GestureDetector(
                onTap: () {
                  if (desbloqueado) {
                    _mostrarDetalhesElemento(elemento, isDark);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Descubra este elemento primeiro!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: corFundo, // Aplica a cor definida
                    border: Border.all(
                      color: desbloqueado
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.grey.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 2,
                        left: 4,
                        child: Text(
                          numero.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: desbloqueado
                                ? (isDark ? Colors.white70 : Colors.black87)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              elemento['simbolo'],
                              style: TextStyle(
                                color: desbloqueado
                                    ? (isDark ? Colors.white : Colors.black)
                                    : Colors.black12,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (desbloqueado) ...[
                              Text(
                                elemento['nome'],
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 8,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${elemento['peso']}u",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    game.isDark = isDark;

    final List<Widget> paginas = [
      _buildPaginaCraft(isDark, context),
      _buildEnciclopedia(isDark),
      _buildStatus(),
    ];

    return Scaffold(
      body: SafeArea(child: paginas[_indiceAtual]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (i) => setState(() => _indiceAtual = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.science), label: "Craft"),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Enciclopédia",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Status",
          ),
        ],
      ),
    );
  }

  // --- WIDGET DO CRAFT ---
  Widget _buildPaginaCraft(bool isDark, BuildContext context) {
    void mostrarTutorialDialog(BuildContext context, bool isDark) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ), // Cantos bem arredondados como na foto
            ),
            backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Faz a caixa abraçar o conteúdo
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com Ícone e Título
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.menu_book_rounded, // Ícone de livrinho
                          color: isDark ? Colors.white : Colors.black,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Como Jogar",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                  ), // Linha sutil separando
                  const SizedBox(height: 16),

                  // Texto do Tutorial
                  Text(
                    "• Para fundir elementos arraste os para cima de outro.\n\n"
                    "• Somente o hidrogênio tem estoque infinito.\n\n"
                    "• Os outros elementos podem ser guardados na gaveta acima do hidrogênio.\n\n"
                    "• Os elementos já desbloqueados aparecerão embaixo do hidrogênio, meio transparentes e em ordem de desbloqueio.",
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão Fechar
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(), // Isso fecha a janelinha!
                      child: const Text(
                        "Fechar",
                        style: TextStyle(
                          color: Colors
                              .blueAccent, // Aquele azul clássico da sua foto
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              GameWidget(game: game),

              // Botão de engrenagem
              Positioned(
                bottom: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: isDark ? Colors.white : Colors.black,
                    size: 32,
                  ),
                  onPressed: () async {
                    final res = await showMenu<int>(
                      context: context,
                      position: const RelativeRect.fromLTRB(0, 680, 0, 0),
                      color: isDark
                          ? const Color(0xFF1E1325)
                          : const Color(0xFFE6FFE7),
                      items: const [
                        PopupMenuItem(value: 1, child: Text("Tutorial")),
                        PopupMenuItem(value: 2, child: Text("Modo Escuro")),
                      ],
                    );
                    // Aqui chamamos a janelinha bonita em vez de mudar o estado!
                    if (res == 1) mostrarTutorialDialog(context, isDark);
                    if (res == 2) widget.onThemeToggle();
                  },
                ),
              ),

              // Lixeira
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Barra lateral do Hidrogênio (intacta)
        Container(
          width: 85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1325) : const Color(0xFFE6FFE7),
            border: const Border(left: BorderSide(color: Colors.black12)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => game.spawnElement(1),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.white : Colors.black,
                      width: 1.2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 2,
                        left: 4,
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "H",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              "Hidrogênio",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 8,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              "1.008u",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 10,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
