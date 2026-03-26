import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 1. Variável de estado movida para dentro do Estado do MyApp
  bool escu = false;
  List<Map<String, dynamic>> elementos = [
  {"nome": "Nulo", "simbolo": "0", "numero": 0, "peso": 0.0},
  {"nome": "Hidrogênio", "simbolo": "H", "numero": 1, "peso": 1.008},
  {"nome": "Hélio", "simbolo": "He", "numero": 2, "peso": 4.0026},
  {"nome": "Lítio", "simbolo": "Li", "numero": 3, "peso": 6.94},
  {"nome": "Berílio", "simbolo": "Be", "numero": 4, "peso": 9.0122},
  {"nome": "Boro", "simbolo": "B", "numero": 5, "peso": 10.81},
  {"nome": "Carbono", "simbolo": "C", "numero": 6, "peso": 12.01},
  {"nome": "Nitrogênio", "simbolo": "N", "numero": 7, "peso": 14.01},
  {"nome": "Oxigênio", "simbolo": "O", "numero": 8, "peso": 16.00},
  {"nome": "Flúor", "simbolo": "F", "numero": 9, "peso": 19.00},
  {"nome": "Neônio", "simbolo": "Ne", "numero": 10, "peso": 20.18},
  {"nome": "Sódio", "simbolo": "Na", "numero": 11, "peso": 22.99},
  {"nome": "Magnésio", "simbolo": "Mg", "numero": 12, "peso": 24.31},
  {"nome": "Alumínio", "simbolo": "Al", "numero": 13, "peso": 26.98},
  {"nome": "Silício", "simbolo": "Si", "numero": 14, "peso": 28.09},
  {"nome": "Fósforo", "simbolo": "P", "numero": 15, "peso": 30.97},
  {"nome": "Enxofre", "simbolo": "S", "numero": 16, "peso": 32.06},
  {"nome": "Cloro", "simbolo": "Cl", "numero": 17, "peso": 35.45},
  {"nome": "Argônio", "simbolo": "Ar", "numero": 18, "peso": 39.95},
  {"nome": "Potássio", "simbolo": "K", "numero": 19, "peso": 39.10},
  {"nome": "Cálcio", "simbolo": "Ca", "numero": 20, "peso": 40.08},
  {"nome": "Escândio", "simbolo": "Sc", "numero": 21, "peso": 44.96},
  {"nome": "Titânio", "simbolo": "Ti", "numero": 22, "peso": 47.87},
  {"nome": "Vanádio", "simbolo": "V", "numero": 23, "peso": 50.94},
  {"nome": "Cromo", "simbolo": "Cr", "numero": 24, "peso": 52.00},
  {"nome": "Manganês", "simbolo": "Mn", "numero": 25, "peso": 54.94},
  {"nome": "Ferro", "simbolo": "Fe", "numero": 26, "peso": 55.85},
  {"nome": "Cobalto", "simbolo": "Co", "numero": 27, "peso": 58.93},
  {"nome": "Níquel", "simbolo": "Ni", "numero": 28, "peso": 58.69},
  {"nome": "Cobre", "simbolo": "Cu", "numero": 29, "peso": 63.55},
  {"nome": "Zinco", "simbolo": "Zn", "numero": 30, "peso": 65.38},
  {"nome": "Gálio", "simbolo": "Ga", "numero": 31, "peso": 69.72},
  {"nome": "Germânio", "simbolo": "Ge", "numero": 32, "peso": 72.63},
  {"nome": "Arsênio", "simbolo": "As", "numero": 33, "peso": 74.92},
  {"nome": "Selênio", "simbolo": "Se", "numero": 34, "peso": 78.97},
  {"nome": "Bromo", "simbolo": "Br", "numero": 35, "peso": 79.90},
  {"nome": "Criptônio", "simbolo": "Kr", "numero": 36, "peso": 83.80},
  {"nome": "Rubídio", "simbolo": "Rb", "numero": 37, "peso": 85.47},
  {"nome": "Estrôncio", "simbolo": "Sr", "numero": 38, "peso": 87.62},
  {"nome": "Ítrio", "simbolo": "Y", "numero": 39, "peso": 88.91},
  {"nome": "Zircônio", "simbolo": "Zr", "numero": 40, "peso": 91.22},
  {"nome": "Nióbio", "simbolo": "Nb", "numero": 41, "peso": 92.91},
  {"nome": "Molibdênio", "simbolo": "Mo", "numero": 42, "peso": 95.95},
  {"nome": "Tecnécio", "simbolo": "Tc", "numero": 43, "peso": 98.0},
  {"nome": "Rutênio", "simbolo": "Ru", "numero": 44, "peso": 101.1},
  {"nome": "Ródio", "simbolo": "Rh", "numero": 45, "peso": 102.9},
  {"nome": "Paládio", "simbolo": "Pd", "numero": 46, "peso": 106.4},
  {"nome": "Prata", "simbolo": "Ag", "numero": 47, "peso": 107.9},
  {"nome": "Cádmio", "simbolo": "Cd", "numero": 48, "peso": 112.4},
  {"nome": "Índio", "simbolo": "In", "numero": 49, "peso": 114.8},
  {"nome": "Estanho", "simbolo": "Sn", "numero": 50, "peso": 118.7},
  {"nome": "Antimônio", "simbolo": "Sb", "numero": 51, "peso": 121.8},
  {"nome": "Telúrio", "simbolo": "Te", "numero": 52, "peso": 127.6},
  {"nome": "Iodo", "simbolo": "I", "numero": 53, "peso": 126.9},
  {"nome": "Xenônio", "simbolo": "Xe", "numero": 54, "peso": 131.3},
  {"nome": "Césio", "simbolo": "Cs", "numero": 55, "peso": 132.9},
  {"nome": "Bário", "simbolo": "Ba", "numero": 56, "peso": 137.3},
  {"nome": "Lantânio", "simbolo": "La", "numero": 57, "peso": 138.9},
  {"nome": "Cério", "simbolo": "Ce", "numero": 58, "peso": 140.1},
  {"nome": "Praseodímio", "simbolo": "Pr", "numero": 59, "peso": 140.9},
  {"nome": "Neodímio", "simbolo": "Nd", "numero": 60, "peso": 144.2},
  {"nome": "Promécio", "simbolo": "Pm", "numero": 61, "peso": 145.0},
  {"nome": "Samário", "simbolo": "Sm", "numero": 62, "peso": 150.4},
  {"nome": "Európio", "simbolo": "Eu", "numero": 63, "peso": 152.0},
  {"nome": "Gadolínio", "simbolo": "Gd", "numero": 64, "peso": 157.3},
  {"nome": "Térbio", "simbolo": "Tb", "numero": 65, "peso": 158.9},
  {"nome": "Disprósio", "simbolo": "Dy", "numero": 66, "peso": 162.5},
  {"nome": "Hólmio", "simbolo": "Ho", "numero": 67, "peso": 164.9},
  {"nome": "Érbio", "simbolo": "Er", "numero": 68, "peso": 167.3},
  {"nome": "Túlio", "simbolo": "Tm", "numero": 69, "peso": 168.9},
  {"nome": "Itérbio", "simbolo": "Yb", "numero": 70, "peso": 173.1},
  {"nome": "Lutécio", "simbolo": "Lu", "numero": 71, "peso": 175.0},
  {"nome": "Háfnio", "simbolo": "Hf", "numero": 72, "peso": 178.5},
  {"nome": "Tântalo", "simbolo": "Ta", "numero": 73, "peso": 180.9},
  {"nome": "Tungstênio", "simbolo": "W", "numero": 74, "peso": 183.8},
  {"nome": "Rênio", "simbolo": "Re", "numero": 75, "peso": 186.2},
  {"nome": "Ósmio", "simbolo": "Os", "numero": 76, "peso": 190.2},
  {"nome": "Irídio", "simbolo": "Ir", "numero": 77, "peso": 192.2},
  {"nome": "Platina", "simbolo": "Pt", "numero": 78, "peso": 195.1},
  {"nome": "Ouro", "simbolo": "Au", "numero": 79, "peso": 197.0},
  {"nome": "Mercúrio", "simbolo": "Hg", "numero": 80, "peso": 200.6},
  {"nome": "Tálio", "simbolo": "Tl", "numero": 81, "peso": 204.4},
  {"nome": "Chumbo", "simbolo": "Pb", "numero": 82, "peso": 207.2},
  {"nome": "Bismuto", "simbolo": "Bi", "numero": 83, "peso": 209.0},
  {"nome": "Polônio", "simbolo": "Po", "numero": 84, "peso": 209.0},
  {"nome": "Astato", "simbolo": "At", "numero": 85, "peso": 210.0},
  {"nome": "Radônio", "simbolo": "Rn", "numero": 86, "peso": 222.0},
  {"nome": "Frâncio", "simbolo": "Fr", "numero": 87, "peso": 223.0},
  {"nome": "Rádio", "simbolo": "Ra", "numero": 88, "peso": 226.0},
  {"nome": "Actínio", "simbolo": "Ac", "numero": 89, "peso": 227.0},
  {"nome": "Tório", "simbolo": "Th", "numero": 90, "peso": 232.0},
  {"nome": "Protactínio", "simbolo": "Pa", "numero": 91, "peso": 231.0},
  {"nome": "Urânio", "simbolo": "U", "numero": 92, "peso": 238.0},
  {"nome": "Netúnio", "simbolo": "Np", "numero": 93, "peso": 237.0},
  {"nome": "Plutônio", "simbolo": "Pu", "numero": 94, "peso": 244.0},
  {"nome": "Amerício", "simbolo": "Am", "numero": 95, "peso": 243.0},
  {"nome": "Cúrio", "simbolo": "Cm", "numero": 96, "peso": 247.0},
  {"nome": "Berquélio", "simbolo": "Bk", "numero": 97, "peso": 247.0},
  {"nome": "Califórnio", "simbolo": "Cf", "numero": 98, "peso": 251.0},
  {"nome": "Einstênio", "simbolo": "Es", "numero": 99, "peso": 252.0},
  {"nome": "Férmio", "simbolo": "Fm", "numero": 100, "peso": 257.0},
  {"nome": "Mendelévio", "simbolo": "Md", "numero": 101, "peso": 258.0},
  {"nome": "Nobélio", "simbolo": "No", "numero": 102, "peso": 259.0},
  {"nome": "Laurêncio", "simbolo": "Lr", "numero": 103, "peso": 262.0},
  {"nome": "Rutherfórdio", "simbolo": "Rf", "numero": 104, "peso": 267.0},
  {"nome": "Dúbnio", "simbolo": "Db", "numero": 105, "peso": 270.0},
  {"nome": "Seabórgio", "simbolo": "Sg", "numero": 106, "peso": 271.0},
  {"nome": "Bóhrio", "simbolo": "Bh", "numero": 107, "peso": 270.0},
  {"nome": "Hássio", "simbolo": "Hs", "numero": 108, "peso": 277.0},
  {"nome": "Meitnério", "simbolo": "Mt", "numero": 109, "peso": 278.0},
  {"nome": "Darmstádtio", "simbolo": "Ds", "numero": 110, "peso": 281.0},
  {"nome": "Roentgênio", "simbolo": "Rg", "numero": 111, "peso": 282.0},
  {"nome": "Copernício", "simbolo": "Cn", "numero": 112, "peso": 285.0},
  {"nome": "Nipônio", "simbolo": "Nh", "numero": 113, "peso": 286.0},
  {"nome": "Fleróvio", "simbolo": "Fl", "numero": 114, "peso": 289.0},
  {"nome": "Moscóvio", "simbolo": "Mc", "numero": 115, "peso": 290.0},
  {"nome": "Livermório", "simbolo": "Lv", "numero": 116, "peso": 293.0},
  {"nome": "Tennesso", "simbolo": "Ts", "numero": 117, "peso": 294.0},
  {"nome": "Oganésson", "simbolo": "Og", "numero": 118, "peso": 294.0},
];
  void criarElemento(String nome, String simbolo, int numero, double peso) {
    setState(() {
      elementos.add({
        "nome": nome,
        "simbolo": simbolo,
        "numero": numero,
        "peso": peso,
      });
    });
  }
  // 2. Função para alternar o tema
  void tema() {
    setState(() {
      escu = !escu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atom_C',
      // 3. Define os dois temas e qual usar baseado na variável
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: escu ? ThemeMode.dark : ThemeMode.light,

      // 4. Passamos a função de mudar tema para a HomePage
      home: _HomePage(onThemeToggle: tema),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({required this.onThemeToggle});
  final VoidCallback onThemeToggle; // Adicione esta linha
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _indiceAtual = 0;
  bool tutol = false;
  @override
  Widget build(BuildContext context) {
    final double alturaTela = MediaQuery.of(context).size.height;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> _paginas = [
      Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white.withOpacity(0.05),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: isDark ? Colors.white : Colors.black,
                        //border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1),
                        size: 30,
                      ),
                      onPressed: () async {
                        final int? selectedValue = await showMenu<int>(
                          context: context,
                          position: const RelativeRect.fromLTRB(0, 400, 0, 0),
                          color: isDark
                              ? const Color.fromARGB(255, 30, 19, 37)
                              : const Color.fromARGB(255, 230, 255, 231),

                          items: [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Tutorial"),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Modo escuro"),
                            ),
                            const PopupMenuItem(value: 3, child: Text("Sair")),
                          ],
                        );

                        // Verifica se o usuário não fechou o menu clicando fora (nulo)
                        if (selectedValue != null) {
                          setState(() {
                            // Executa a lógica baseada no valor
                            switch (selectedValue) {
                              case 1:
                                setState(() {
                                  tutol = !tutol;
                                });
                                break;
                              case 2:
                                widget.onThemeToggle();
                                break;
                              case 3:
                                break;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinha o texto à esquerda, junto com o botão
                      children: [
                        // 1. O SEU BOTÃO (Lixeira)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                        ),

                        // 2. O TUTORIAL (Só aparece se tutol for true)
                        if (tutol)
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                            ), // Dá um espaço entre o botão e o texto
                            padding: const EdgeInsets.all(15),
                            width:
                                280, // Define uma largura para o texto não atravessar a tela
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.9)
                                  : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "• Para fundir elementos arraste os para cima de outro\n"
                              "• somente o hidrogênio tem estoque infinito\n"
                              "• os outros elementos podem ser guardados na gaveta acima do hidrogênio\n"
                              "• os elementos ja desbloqueados aparecerão em baixo do hidrogênio",
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white
                                    : Colors
                                          .black, // Inverte a cor para dar leitura
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            height: alturaTela,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color.fromARGB(255, 30, 19, 37)
                  : const Color.fromARGB(255, 230, 255, 231),
              border: Border(left: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      color: isDark ? Colors.white : Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "H",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Hidrigênio", style: TextStyle(fontSize: 7)),
                      Text("1.008", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const Center(child: Text("Enciclopédia Completa")),
      const Center(child: Text("Status do Progresso")),
    ];

    return Scaffold(
      body: SafeArea(child: Stack(children: [_paginas[_indiceAtual]])),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
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
}
