import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// --- 1. DICIONÁRIO DE MOLÉCULAS ---
// Adicione as moléculas aqui usando o número atômico como chave
final Map<int, String> principaisMoleculas = {
  1: "H2O (Água)",
  2: "He (Gás Hélio)",
  3: "Li2CO3 (Carbonato de Lítio)",
  4: "BeO (Óxido de Berílio)",
  5: "H3BO3 (Ácido Bórico)",
  6: "CO2 (Dióxido de Carbono)",
  7: "N2 (Gás Nitrogênio)",
  8: "O2 (Gás Oxigênio)",
  9: "NaF (Fluoreto de Sódio)",
  10: "Ne (Gás Neônio)",
  11: "NaCl (Cloreto de Sódio / Sal)",
  12: "MgO (Óxido de Magnésio)",
  13: "Al2O3 (Óxido de Alumínio / Alumina)",
  14: "SiO2 (Dióxido de Silício / Areia)",
  15: "H3PO4 (Ácido Fosfórico)",
  16: "H2SO4 (Ácido Sulfúrico)",
  17: "HCl (Ácido Clorídrico)",
  18: "Ar (Gás Argônio)",
  19: "KCl (Cloreto de Potássio)",
  20: "CaCO3 (Carbonato de Cálcio / Calcário)",
  21: "Sc2O3 (Óxido de Escândio)",
  22: "TiO2 (Dióxido de Titânio)",
  23: "V2O5 (Pentóxido de Vanádio)",
  24: "Cr2O3 (Óxido de Crômio)",
  25: "MnO2 (Dióxido de Manganês)",
  26: "Fe2O3 (Óxido de Ferro III / Ferrugem)",
  27: "CoCl2 (Cloreto de Cobalto)",
  28: "NiO (Óxido de Níquel)",
  29: "CuSO4 (Sulfato de Cobre)",
  30: "ZnO (Óxido de Zinco)",
  31: "GaAs (Arsenieto de Gálio)",
  32: "GeO2 (Dióxido de Germânio)",
  33: "As2O3 (Trióxido de Arsênio)",
  34: "H2Se (Seleneto de Hidrogênio)",
  35: "NaBr (Brometo de Sódio)",
  36: "Kr (Gás Criptônio)",
  37: "RbCl (Cloreto de Rubídio)",
  38: "SrCO3 (Carbonato de Estrôncio)",
  39: "Y2O3 (Óxido de Ítrio)",
  40: "ZrO2 (Dióxido de Zircônio)",
  41: "Nb2O5 (Pentóxido de Nióbio)",
  42: "MoS2 (Dissulfeto de Molibdênio)",
  43: "NaTcO4 (Pertenetato de Sódio)",
  44: "RuO4 (Tetróxido de Rutênio)",
  45: "RhCl3 (Cloreto de Ródio)",
  46: "PdCl2 (Cloreto de Paládio)",
  47: "AgNO3 (Nitrato de Prata)",
  48: "CdS (Sulfeto de Cádmio)",
  49: "In2O3 (Óxido de Índio)",
  50: "SnO2 (Dióxido de Estanho)",
  51: "Sb2S3 (Trissulfeto de Antimônio)",
  52: "CdTe (Telureto de Cádmio)",
  53: "KI (Iodeto de Potássio)",
  54: "Xe (Gás Xenônio)",
  55: "CsCl (Cloreto de Césio)",
  56: "BaSO4 (Sulfato de Bário)",
  57: "La2O3 (Óxido de Lantânio)",
  58: "CeO2 (Dióxido de Cério)",
  59: "Pr2O3 (Óxido de Praseodímio)",
  60: "Nd2O3 (Óxido de Neodímio)",
  61: "Pm2O3 (Óxido de Promécio)",
  62: "Sm2O3 (Óxido de Samário)",
  63: "Eu2O3 (Óxido de Európio)",
  64: "Gd2O3 (Óxido de Gadolínio)",
  65: "Tb2O3 (Óxido de Térbio)",
  66: "Dy2O3 (Óxido de Disprósio)",
  67: "Ho2O3 (Óxido de Hólmio)",
  68: "Er2O3 (Óxido de Érbio)",
  69: "Tm2O3 (Óxido de Túlio)",
  70: "Yb2O3 (Óxido de Itérbio)",
  71: "Lu2O3 (Óxido de Lutécio)",
  72: "HfO2 (Dióxido de Háfnio)",
  73: "Ta2O5 (Pentóxido de Tântalo)",
  74: "WO3 (Trióxido de Tungstênio)",
  75: "KReO4 (Perrhenato de Potássio)",
  76: "OsO4 (Tetróxido de Ósmio)",
  77: "IrO2 (Dióxido de Irídio)",
  78: "PtCl2 (Cloreto de Platina)",
  79: "AuCl3 (Tricloreto de Ouro)",
  80: "HgS (Sulfeto de Mercúrio / Cinábrio)",
  81: "Tl2SO4 (Sulfato de Tálio)",
  82: "PbO (Óxido de Chumbo)",
  83: "Bi2O3 (Óxido de Bismuto)",
  84: "PoO2 (Dióxido de Polônio)",
  85: "HAt (Astateto de Hidrogênio)",
  86: "Rn (Gás Radônio)",
  87: "FrCl (Cloreto de Frâncio)",
  88: "RaCl2 (Cloreto de Rádio)",
  89: "Ac2O3 (Óxido de Actínio)",
  90: "ThO2 (Dióxido de Tório)",
  91: "Pa2O5 (Pentóxido de Protactínio)",
  92: "UO2 (Dióxido de Urânio)",
  93: "NpO2 (Dióxido de Netúnio)",
  94: "PuO2 (Dióxido de Plutônio)",
  95: "AmO2 (Dióxido de Amerício)",
  96: "Cm2O3 (Óxido de Cúrio)",
  97: "BkO2 (Dióxido de Berquélio)",
  98: "Cf2O3 (Óxido de Califórnio)",
  99: "Es2O3 (Óxido de Einstêinio)",
  100: "Fm2O3 (Óxido de Férmio)",
  101: "Md2O3 (Óxido de Mendelévio)",
  102: "NoO (Óxido de Nobélio)",
  103: "Lr2O3 (Óxido de Laurêncio)",
  104: "RfCl4 (Cloreto de Rutherfórdio)",
  105: "DbCl5 (Cloreto de Dúbnio)",
  106: "SgO3 (Óxido de Seabórgio)",
  107: "BhO3Cl (Oxicloreto de Bóhrio)",
  108: "HsO4 (Tetróxido de Hássio)",
  109: "Mt (Meitnério - Sintético)",
  110: "Ds (Darmstádio - Sintético)",
  111: "Rg (Roentgênio - Sintético)",
  112: "Cn (Copernício - Sintético)",
  113: "Nh (Nihônio - Sintético)",
  114: "Fl (Fleróvio - Sintético)",
  115: "Mc (Moscóvio - Sintético)",
  116: "Lv (Livermório - Sintético)",
  117: "Ts (Tenesso - Sintético)",
  118: "Og (Oganessônio - Sintético)",
};

// --- 2. LISTA COMPLETA ---
final List<Map<String, dynamic>> listaElementos = [
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

// --- COMPONENTE INVISÍVEL DA LIXEIRA ---
class LixeiraComponent extends PositionComponent {
  LixeiraComponent()
    : super(
        position: Vector2(
          15,
          15,
        ), // Mesma posição do widget (top: 15, left: 15)
        size: Vector2(
          60,
          60,
        ), // Um pouco maior que o ícone para facilitar acertar
      );
}

// --- MOTOR DO JOGO ---
class AtomCGame extends FlameGame with HasCollisionDetection {
  bool isDark = false;
  final Function(int) onUnlock;

  AtomCGame({required this.onUnlock});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    add(LixeiraComponent()); // Adiciona a área de exclusão
  }

  void spawnElement(int index) {
    final atomo = AtomoComponent(listaElementos[index]);
    atomo.position = size / 2;
    add(atomo);
  }

  void verificarFusao(AtomoComponent movido) {
    // 1. PRIMEIRO CHECA A LIXEIRA
    final lixeiras = children.query<LixeiraComponent>();
    if (lixeiras.isNotEmpty) {
      final rectMovido = movido.toAbsoluteRect();
      final rectLixeira = lixeiras.first.toAbsoluteRect();

      if (rectMovido.overlaps(rectLixeira)) {
        remove(movido); // Destrói o átomo
        return; // Sai da função
      }
    }

    // 2. DEPOIS CHECA A FUSÃO COM OUTROS ÁTOMOS
    final outros = children.query<AtomoComponent>();
    for (var outro in outros) {
      if (outro == movido) continue;

      if (movido.collidingWith(outro)) {
        int soma = movido.dados['numero'] + outro.dados['numero'];
        if (soma < listaElementos.length) {
          final posFinal = outro.position.clone();
          remove(movido);
          remove(outro);
          add(AtomoComponent(listaElementos[soma])..position = posFinal);
          onUnlock(soma); // Avisa o app do novo desbloqueio
          break;
        }
      }
    }
  }
}

// --- COMPONENTE DO ÁTOMO ---
class AtomoComponent extends PositionComponent
    with DragCallbacks, HasGameRef<AtomCGame> {
  final Map<String, dynamic> dados;
  final double s = 100.0;

  AtomoComponent(this.dados)
    : super(size: Vector2.all(100.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: s / 4, position: size / 2, anchor: Anchor.center));
  }

  @override
  void render(Canvas canvas) {
    final bool dark = gameRef.isDark;

    final paintBg = Paint()
      ..color = dark
          ? const Color.fromARGB(255, 102, 102, 102)
          : const Color.fromARGB(255, 255, 255, 255);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paintBg);

    final paintBorder = Paint()
      ..color = dark ? Colors.white : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paintBorder);

    final Color textColor = dark ? Colors.white : Colors.black;

    TextPaint(
      style: TextStyle(
        color: textColor,
        fontSize: 38,
        fontWeight: FontWeight.bold,
      ),
    ).render(
      canvas,
      dados['simbolo'],
      Vector2(size.x / 2, size.y * 0.38),
      anchor: Anchor.center,
    );

    TextPaint(
      style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11),
    ).render(
      canvas,
      dados['nome'],
      Vector2(size.x / 2, size.y * 0.70),
      anchor: Anchor.center,
    );

    TextPaint(style: TextStyle(color: textColor, fontSize: 13)).render(
      canvas,
      dados['peso'].toString(),
      Vector2(size.x / 2, size.y * 0.86),
      anchor: Anchor.center,
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) => position += event.localDelta;

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    gameRef.verificarFusao(this);
  }

  bool collidingWith(AtomoComponent outro) {
    return toAbsoluteRect().overlaps(outro.toAbsoluteRect());
  }
}

// --- APP ---
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool escu = false;
  void toggleTema() => setState(() => escu = !escu);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: escu ? ThemeMode.dark : ThemeMode.light,
      home: _HomePage(onThemeToggle: toggleTema),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const _HomePage({required this.onThemeToggle});
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _indiceAtual = 0;
  bool tutol = false;
  late AtomCGame game;

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
  // Calcula a posição (coluna e linha) baseada no número atômico
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
      col = n - 3;
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
      col = n - 54;
      row = 7;
    } // Lantanídeos
    else if (n >= 72 && n <= 86) {
      col = n - 69;
      row = 5;
    } else if (n >= 87 && n <= 88) {
      col = n - 87;
      row = 6;
    } else if (n >= 89 && n <= 103) {
      col = n - 86;
      row = 8;
    } // Actinídeos
    else if (n >= 104 && n <= 118) {
      col = n - 101;
      row = 6;
    }
    return [col, row];
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
            subtitle: Text("Molécula: $molecula\nPeso: ${elemento['peso']}"),
          ),
        );
      },
    );
  }

  // --- WIDGET DO STATUS (Tabela Periódica Geométrica) ---
  Widget _buildStatus() {
    // Definimos o tamanho de cada "quadradinho" do elemento
    const double tamanhoCelula = 45.0;
    const double espacamento = 2.0;

    return InteractiveViewer(
      // Permite dar zoom e arrastar a tabela pela tela
      constrained: false,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 2.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: (18 * (tamanhoCelula + espacamento)) + 32, // 18 colunas
        height:
            (9 * (tamanhoCelula + espacamento)) +
            32, // 9 linhas (7 principais + 2 separadas)
        child: Stack(
          children: List.generate(listaElementos.length - 1, (index) {
            var elemento = listaElementos[index + 1];
            int numero = elemento['numero'];
            bool desbloqueado = elementosDesbloqueados.contains(numero);

            List<int> pos = _obterPosicaoTabela(numero);
            double leftPos = pos[0] * (tamanhoCelula + espacamento);
            // Adiciona um espaço extra (margin) antes da linha 7 para separar lantanídeos/actinídeos
            double topPos =
                pos[1] * (tamanhoCelula + espacamento) +
                (pos[1] >= 7 ? 15.0 : 0.0);

            return Positioned(
              left: leftPos,
              top: topPos,
              width: tamanhoCelula,
              height: tamanhoCelula,
              child: Container(
                decoration: BoxDecoration(
                  color: desbloqueado
                      ? Colors.green.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.15),
                  border: Border.all(
                    color: desbloqueado
                        ? Colors.green[900]!
                        : Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    elemento['simbolo'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: desbloqueado ? Colors.white : Colors.black12,
                    ),
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
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              GameWidget(game: game),
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
                    if (res == 1) setState(() => tutol = !tutol);
                    if (res == 2) widget.onThemeToggle();
                  },
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                    if (tutol)
                      Container(
                        margin: const EdgeInsets.only(top: 390),
                        padding: const EdgeInsets.all(12),
                        width: 260,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black87
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          "• Para fundir elementos arraste os para cima de outro\n• somente o hidrogênio tem estoque infinito\n• os outros elementos podem ser guardados na gaveta acima do hidrogênio\n• os elementos ja desbloqueados aparecerão em baixo do hidrogênio meio transparentes e em ordem de desbloqueio",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                        "1.008",
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
      ],
    );
  }
}
