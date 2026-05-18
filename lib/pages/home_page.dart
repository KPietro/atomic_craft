import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../game/atom_game.dart';
import '../data/elementos_data.dart';
import '../data/db_helper.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const HomePage({super.key, required this.onThemeToggle});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int indiceAtual = 0;
  bool tutol = false;
  int etapaAtual = 1;
  int tipoLigacao = 1;
  int modoFerramenta = 0;
  late AtomCGame game;

  List<int> elementosDesbloqueados = [];
  // Agora é uma lista de Dicionários (Maps) para guardar a fórmula e a descrição
  List<Map<String, dynamic>> moleculasDesbloqueadas = [];
  bool carregandoDb = true;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();

    game = AtomCGame(
      onUnlock: (novoNumero) async {
        if (!elementosDesbloqueados.contains(novoNumero)) {
          setState(() => elementosDesbloqueados.add(novoNumero));
          await DbHelper.instance.addDesbloqueado(novoNumero);
        }
      },
      onMoleculaCriada: (formula) async {
        bool jaExiste = moleculasDesbloqueadas.any(
          (m) => m['formula'] == formula,
        );
        if (!jaExiste) {
          setState(
            () => moleculasDesbloqueadas.add({
              'formula': formula,
              'descricao': '',
            }),
          );
          await DbHelper.instance.addMolecula(formula);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Nova fórmula sintetizada: $formula"),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
  }

  Future<void> _carregarProgresso() async {
    final salvos = await DbHelper.instance.getDesbloqueados();
    final molsSalvas = await DbHelper.instance
        .getMoleculas(); // Pega a lista com as descrições
    setState(() {
      elementosDesbloqueados = salvos;
      moleculasDesbloqueadas = molsSalvas;
      carregandoDb = false;
    });
  }

  // --- NOVO: POP-UP DE ANOTAÇÃO DA MOLÉCULA ---
  void _editarDescricaoMolecula(int index, bool isDark) {
    String formula = moleculasDesbloqueadas[index]['formula'];
    TextEditingController controller = TextEditingController(
      text: moleculasDesbloqueadas[index]['descricao'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.edit_note, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                "Anotações: $formula",
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            maxLines: 4,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Escreva suas anotações sobre essa molécula...",
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () async {
                String novaDesc = controller.text;
                await DbHelper.instance.atualizarDescricaoMolecula(
                  formula,
                  novaDesc,
                );
                setState(() {
                  moleculasDesbloqueadas[index]['descricao'] = novaDesc;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- FUNÇÃO PARA MOSTRAR DETALHES DO ELEMENTO ---
  void _mostrarDetalhesElemento(Map<String, dynamic> elemento, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
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

  List<int> _obterPosicaoTabela(int n) {
    int col = 0, row = 0;
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
    } else if (n >= 57 && n <= 71) {
      col = n - 55;
      row = 7;
    } else if (n >= 72 && n <= 86) {
      col = n - 69;
      row = 5;
    } else if (n >= 87 && n <= 88) {
      col = n - 87;
      row = 6;
    } else if (n >= 89 && n <= 103) {
      col = n - 87;
      row = 8;
    } else if (n >= 104 && n <= 118) {
      col = n - 101;
      row = 6;
    }
    return [col, row];
  }

  Color _obterCorFamilia(int n, bool isDark) {
    Color base;
    if (n == 1 || (n >= 6 && n <= 8) || n == 15 || n == 16 || n == 34)
      base = Colors.green;
    else if (n == 2 ||
        n == 10 ||
        n == 18 ||
        n == 36 ||
        n == 54 ||
        n == 86 ||
        n == 118)
      base = Colors.cyan;
    else if (n == 3 || n == 11 || n == 19 || n == 37 || n == 55 || n == 87)
      base = Colors.orange;
    else if (n == 4 || n == 12 || n == 20 || n == 38 || n == 56 || n == 88)
      base = Colors.yellow;
    else if ((n >= 21 && n <= 30) ||
        (n >= 39 && n <= 48) ||
        (n >= 72 && n <= 80) ||
        (n >= 104 && n <= 112))
      base = Colors.pinkAccent;
    else if (n == 5 || n == 14 || n == 32 || n == 33 || n == 51 || n == 52)
      base = Colors.teal;
    else if (n == 9 || n == 17 || n == 35 || n == 53 || n == 85 || n == 117)
      base = Colors.lightBlue;
    else if (n >= 57 && n <= 71)
      base = Colors.purpleAccent;
    else if (n >= 89 && n <= 103)
      base = Colors.deepPurpleAccent;
    else
      base = Colors.blueGrey;
    return isDark ? base.withOpacity(0.3) : base.withOpacity(0.6);
  }

  // --- WIDGET DA ENCICLOPÉDIA E STATUS ---
  Widget _buildEnciclopedia(bool isDark) {
    bool tabelaCompleta = elementosDesbloqueados.length >= 118;
    if (etapaAtual == 2) {
      return Column(
        children: [
          Card(
            color: Colors.blueAccent.withOpacity(0.2),
            margin: const EdgeInsets.all(16),
            child: ListTile(
              onTap: () => setState(() => etapaAtual = 1),
              leading: const Icon(Icons.arrow_back),
              title: const Text(
                "VOLTAR PARA ETAPA 1",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Retornar à síntese nuclear"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: moleculasDesbloqueadas.length,
              itemBuilder: (context, index) {
                String formula = moleculasDesbloqueadas[index]['formula'];
                String descricao = moleculasDesbloqueadas[index]['descricao'];
                bool temDescricao = descricao.isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () =>
                        _editarDescricaoMolecula(index, isDark), // ABRE O POPUP
                    leading: CircleAvatar(
                      backgroundColor: isDark
                          ? Colors.grey[700]
                          : Colors.blueGrey,
                      child: const Text(
                        "M",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      formula,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      temDescricao
                          ? descricao
                          : "Toque para adicionar suas anotações...",
                    ),
                    trailing: const Icon(
                      Icons.edit_note,
                      color: Colors.blueAccent,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: elementosDesbloqueados.length + (tabelaCompleta ? 1 : 0),
      itemBuilder: (context, index) {
        if (tabelaCompleta && index == 0) {
          return Card(
            elevation: 5,
            color: isDark ? const Color(0xFF3D3D3D) : Colors.amber[50],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isDark ? Colors.white54 : Colors.orangeAccent,
                width: 1.5,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => etapaAtual = 2),
              leading: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Icon(
                  FontAwesomeIcons.atom,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              title: const Text(
                "ETAPA 2: SÍNTESE MOLECULAR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "O núcleo está pronto. Toque para transcender.",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        }
        int indiceElemento = tabelaCompleta ? index - 1 : index;
        int numElemento = elementosDesbloqueados[indiceElemento];
        var elemento = listaElementos[numElemento];
        return Card(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () => _mostrarDetalhesElemento(elemento, isDark),
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
            subtitle: Text(
              "Molécula: ${principaisMoleculas[numElemento] ?? "Desconhecida"}\nPeso: ${elemento['peso']}u",
            ),
            trailing: const Icon(Icons.info_outline),
          ),
        );
      },
    );
  }

  Widget _buildStatus() {
    const double tamanhoCelula = 65.0, espacamento = 4.0;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(60),
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
                  if (desbloqueado)
                    _mostrarDetalhesElemento(elemento, isDark);
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Descubra este elemento primeiro!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: corFundo,
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
    if (carregandoDb)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    game.isDark = isDark;
    game.etapaAtual = etapaAtual;
    game.tipoLigacaoSelecionada = tipoLigacao;
    game.modoFerramenta =
        modoFerramenta; // Passa pro jogo se estamos em seleção

    final List<Widget> paginas = [
      _buildPaginaCraft(isDark, context),
      _buildEnciclopedia(isDark),
      _buildStatus(),
    ];

    return Scaffold(
      body: SafeArea(child: paginas[indiceAtual]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        onTap: (i) => setState(() => indiceAtual = i),
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

  Widget _botaoLigacao(int valor, String texto, bool isDark) {
    bool selecionado = tipoLigacao == valor;
    return ChoiceChip(
      label: Text(
        texto,
        style: TextStyle(
          fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selecionado,
      selectedColor: Colors.orangeAccent,
      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
      onSelected: (bool selected) {
        if (selected) setState(() => tipoLigacao = valor);
      },
    );
  }

  // --- WIDGET DO CRAFT ---
  Widget _buildPaginaCraft(bool isDark, BuildContext context) {
    void mostrarTutorialDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                              Icons.menu_book_rounded,
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
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("O que é Nucleossíntese?"),
                              content: const Text(
                                "Nucleossíntese é o processo de criação de novos núcleos atômicos a partir de núcleos pré-existentes. Ocorre principalmente no interior das estrelas sob imensas pressões e temperaturas, fundindo elementos mais leves em mais pesados!",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Entendi!"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    "• Para fundir elementos arraste os para cima de outro.\n\n• Somente o hidrogênio tem estoque infinito.\n\n• Os elemntos desbloqueados poderão ser vistos nas abas Enciclopédia e Status la tera mais datalhes de cada elemento.\n\n• Na aba enciclopédia Haverá a opção de ir para a segunda etapa do jogo complete a tabela periódica e encontre a.",
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Fechar",
                        style: TextStyle(
                          color: Colors.blueAccent,
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

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    DragTarget<int>(
                      builder: (context, candidateData, rejectedData) =>
                          GameWidget(game: game),
                      onAcceptWithDetails: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localPosition = renderBox.globalToLocal(
                          details.offset,
                        );
                        game.spawnElement(
                          details.data,
                          posicao: Vector2(localPosition.dx, localPosition.dy),
                        );
                      },
                    ),

                    if (modoFerramenta != 0)
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() => modoFerramenta = 0);
                                game.desmarcarTudo();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: modoFerramenta == 1
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              onPressed: () {
                                game.confirmarAcao();
                                setState(() => modoFerramenta = 0);
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                modoFerramenta == 1
                                    ? "Deletar Seleção"
                                    : "Registrar Molécula",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              PopupMenuItem(
                                value: 2,
                                child: Text("Modo Escuro"),
                              ),
                            ],
                          );
                          if (res == 1) mostrarTutorialDialog();
                          if (res == 2) widget.onThemeToggle();
                        },
                      ),
                    ),

                    Positioned(
                      top: 15,
                      left: 15,
                      child: GestureDetector(
                        onTap: () {
                          setState(
                            () => modoFerramenta = modoFerramenta == 1 ? 0 : 1,
                          );
                          if (modoFerramenta == 0) game.desmarcarTudo();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: modoFerramenta == 1
                                ? Colors.red.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                              width: modoFerramenta == 1 ? 3 : 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 85,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E1325)
                      : const Color(0xFFE6FFE7),
                  border: const Border(left: BorderSide(color: Colors.black12)),
                ),
                child: etapaAtual == 1
                    ? _barraLateralEtapa1(isDark)
                    : _barraLateralEtapa2(isDark),
              ),
            ],
          ),
        ),

        if (etapaAtual == 2)
          Container(
            height: 60,
            color: isDark ? const Color(0xFF1E1325) : const Color(0xFFE6FFE7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botaoLigacao(1, "Simples (-)", isDark),
                _botaoLigacao(2, "Dupla (=)", isDark),
                _botaoLigacao(3, "Tripla (≡)", isDark),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: modoFerramenta == 2
                        ? Colors.green[700]
                        : Colors.green,
                  ),
                  onPressed: () {
                    setState(
                      () => modoFerramenta = modoFerramenta == 2 ? 0 : 2,
                    );
                    if (modoFerramenta == 0) game.desmarcarTudo();
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    "Registrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _barraLateralEtapa1(bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Draggable<int>(
          data: 1,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                ),
                child: Center(
                  child: Text(
                    "H",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
          child: GestureDetector(
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "H",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Hidrogênio",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 8,
                            ),
                          ),
                          Text(
                            "1.008u",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _barraLateralEtapa2(bool isDark) {
    return ListView.builder(
      itemCount: listaElementos.length - 1,
      itemBuilder: (context, index) {
        var el = listaElementos[index + 1];
        bool podeUsar = elementosDesbloqueados.contains(el['numero']);
        return Opacity(
          opacity: podeUsar ? 1.0 : 0.3,
          child: Draggable<int>(
            data: podeUsar ? el['numero'] : null,
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    border: Border.all(color: Colors.orangeAccent, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      el['simbolo'],
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(),
            child: GestureDetector(
              onTap: () {
                if (podeUsar) game.spawnElement(el['numero']);
              },
              child: Container(
                width: 65,
                height: 65,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                    width: 1.2,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        el['simbolo'],
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        el['nome'],
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
