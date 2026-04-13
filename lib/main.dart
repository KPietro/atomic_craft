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
  {
    "nome": "Hidrogênio",
    "simbolo": "H",
    "numero": 1,
    "peso": 1.008,
    "caracteristicas":
        "É o elemento mais abundante do universo. Em condições normais, é um gás incolor, inodoro e altamente inflamável.",
    "historia":
        "Descoberto por Henry Cavendish em 1766, que o chamou de 'ar inflamável'. O nome 'hidrogênio' veio de Antoine Lavoisier, significando 'gerador de água'.",
    "moleculas_principais": "H2O (Água), CH4 (Metano), NH3 (Amônia).",
  },
  {
    "nome": "Hélio",
    "simbolo": "He",
    "numero": 2,
    "peso": 4.0026,
    "caracteristicas":
        "Gás nobre incolor, inodoro e inerte. É o segundo elemento mais leve e abundante no universo, conhecido por ter o menor ponto de ebulição de todos os elementos.",
    "historia":
        "Descoberto de forma independente pelos astrônomos Pierre Janssen e Norman Lockyer em 1868, ao observarem o espectro solar durante um eclipse. A palavra vem do grego 'helios', que significa Sol.",
    "moleculas_principais":
        "Não forma moléculas na natureza, sendo monoatômico (He).",
  },
  {
    "nome": "Lítio",
    "simbolo": "Li",
    "numero": 3,
    "peso": 6.94,
    "caracteristicas":
        "Metal alcalino macio e prateado. É o metal mais leve e o elemento sólido menos denso em condições normais. É altamente reativo e inflamável.",
    "historia":
        "Descoberto em 1817 por Johan August Arfwedson durante a análise do mineral petalita. O nome deriva do grego 'lithos', que significa pedra.",
    "moleculas_principais":
        "Li2CO3 (Carbonato de lítio), LiCoO2 (Óxido de lítio-cobalto, usado em baterias).",
  },
  {
    "nome": "Berílio",
    "simbolo": "Be",
    "numero": 4,
    "peso": 9.0122,
    "caracteristicas":
        "Metal alcalinoterroso cinza-aço, forte, leve e quebradiço. Seus compostos são altamente tóxicos e ele é muito transparente aos raios-X.",
    "historia":
        "Descoberto por Louis-Nicolas Vauquelin em 1798 como um óxido em berilos e esmeraldas. Foi isolado em 1828 de forma independente por Wöhler e Bussy.",
    "moleculas_principais":
        "BeO (Óxido de berílio), Be3Al2(SiO3)6 (Berilo/Esmeralda).",
  },
  {
    "nome": "Boro",
    "simbolo": "B",
    "numero": 5,
    "peso": 10.81,
    "caracteristicas":
        "Metaloide quebradiço e escuro em sua forma cristalina, ou um pó marrom na forma amorfa. É um excelente absorvedor de nêutrons.",
    "historia":
        "Isolado pela primeira vez em 1808 pelos químicos franceses Joseph-Louis Gay-Lussac e Louis-Jacques Thénard, e independentemente por Humphry Davy.",
    "moleculas_principais": "H3BO3 (Ácido bórico), Na2B4O7·10H2O (Bórax).",
  },
  {
    "nome": "Carbono",
    "simbolo": "C",
    "numero": 6,
    "peso": 12.011,
    "caracteristicas":
        "Não-metal tetravalente que existe em várias formas alotrópicas (grafite, diamante, fulerenos). É a base de toda a vida conhecida na Terra.",
    "historia":
        "Conhecido desde a antiguidade clássica através da fuligem, carvão e diamantes. Antoine Lavoisier o listou como um elemento em 1789.",
    "moleculas_principais":
        "CO2 (Dióxido de carbono), C6H12O6 (Glicose), CH4 (Metano).",
  },
  {
    "nome": "Nitrogênio",
    "simbolo": "N",
    "numero": 7,
    "peso": 14.007,
    "caracteristicas":
        "Gás incolor e inodoro que compõe cerca de 78% da atmosfera terrestre. É vital para aminoácidos e ácidos nucleicos.",
    "historia":
        "Descoberto pelo médico e químico escocês Daniel Rutherford em 1772, que o chamou de 'ar nocivo' ou 'ar flogisticado'.",
    "moleculas_principais":
        "N2 (Gás nitrogênio), NH3 (Amônia), HNO3 (Ácido nítrico).",
  },
  {
    "nome": "Oxigênio",
    "simbolo": "O",
    "numero": 8,
    "peso": 15.999,
    "caracteristicas":
        "Gás altamente reativo, incolor e inodoro. É essencial para a respiração celular da maioria dos seres vivos e para os processos de combustão.",
    "historia":
        "Descoberto independentemente por Carl Wilhelm Scheele em 1773 e Joseph Priestley em 1774. Lavoisier cunhou o nome 'oxigênio' (gerador de ácido).",
    "moleculas_principais": "O2 (Gás oxigênio), O3 (Ozônio), H2O (Água).",
  },
  {
    "nome": "Flúor",
    "simbolo": "F",
    "numero": 9,
    "peso": 18.998,
    "caracteristicas":
        "Halogênio extremamente reativo, venenoso e o elemento mais eletronegativo da tabela periódica. É um gás amarelo pálido.",
    "historia":
        "O mineral fluorita era usado desde 1529, mas o flúor puro só foi isolado com sucesso e segurança em 1886 por Henri Moissan, que ganhou o Nobel pela façanha.",
    "moleculas_principais":
        "HF (Fluoreto de hidrogênio), NaF (Fluoreto de sódio), PTFE (Teflon).",
  },
  {
    "nome": "Neônio",
    "simbolo": "Ne",
    "numero": 10,
    "peso": 20.180,
    "caracteristicas":
        "Gás nobre inerte e incolor. Quando submetido a uma descarga elétrica em tubos de vácuo, emite um brilho vermelho-alaranjado muito distinto.",
    "historia":
        "Descoberto em 1898 pelos químicos britânicos William Ramsay e Morris Travers, após isolarem o criptônio, através da destilação fracionada do ar líquido.",
    "moleculas_principais":
        "Não forma compostos químicos estáveis na natureza (Ne).",
  },
  {
    "nome": "Sódio",
    "simbolo": "Na",
    "numero": 11,
    "peso": 22.990,
    "caracteristicas":
        "Metal alcalino macio, prateado e altamente reativo. Oxida-se rapidamente no ar e reage de forma violenta (e explosiva) com a água.",
    "historia":
        "Isolado pela primeira vez em 1807 por Humphry Davy através da eletrólise da soda cáustica (hidróxido de sódio).",
    "moleculas_principais":
        "NaCl (Cloreto de sódio/Sal de cozinha), NaHCO3 (Bicarbonato de sódio).",
  },
  {
    "nome": "Magnésio",
    "simbolo": "Mg",
    "numero": 12,
    "peso": 24.305,
    "caracteristicas":
        "Metal alcalinoterroso cinza-prateado, brilhante e razoavelmente forte. Queima com uma luz branca extremamente brilhante.",
    "historia":
        "Reconhecido como elemento em 1755 por Joseph Black e isolado por Humphry Davy em 1808.",
    "moleculas_principais":
        "MgO (Óxido de magnésio), MgSO4 (Sulfato de magnésio).",
  },
  {
    "nome": "Alumínio",
    "simbolo": "Al",
    "numero": 13,
    "peso": 26.982,
    "caracteristicas":
        "Metal prateado, macio, não magnético e muito leve. Excelente condutor e altamente resistente à corrosão devido a uma camada fina de óxido.",
    "historia":
        "Hans Christian Ørsted foi o primeiro a isolar o alumínio impuro em 1825. Friedrich Wöhler o obteve em forma pura em 1827.",
    "moleculas_principais":
        "Al2O3 (Óxido de alumínio/Alumina), KAl(SO4)2 (Alúmen).",
  },
  {
    "nome": "Silício",
    "simbolo": "Si",
    "numero": 14,
    "peso": 28.085,
    "caracteristicas":
        "Metaloide duro, quebradiço e cristalino com brilho azul-acizentado. É um semicondutor crucial para a eletrônica moderna e a computação.",
    "historia":
        "Jöns Jacob Berzelius é creditado por preparar o primeiro silício amorfo puro em 1824 e dar a ele seu nome.",
    "moleculas_principais":
        "SiO2 (Dióxido de silício/Areia/Quartzo), SiC (Carbeto de silício).",
  },
  {
    "nome": "Fósforo",
    "simbolo": "P",
    "numero": 15,
    "peso": 30.974,
    "caracteristicas":
        "Não-metal multiforme (alótropos branco, vermelho, preto). O fósforo branco brilha no escuro (fosforescência) e queima espontaneamente no ar.",
    "historia":
        "Descoberto em 1669 por Hennig Brand, que destilou urina humana em busca da Pedra Filosofal e encontrou uma substância que brilhava.",
    "moleculas_principais":
        "H3PO4 (Ácido fosfórico), Ca3(PO4)2 (Fosfato de cálcio).",
  },
  {
    "nome": "Enxofre",
    "simbolo": "S",
    "numero": 16,
    "peso": 32.06,
    "caracteristicas":
        "Não-metal abundante, insípido e inodoro em sua forma pura. Geralmente se apresenta como cristais amarelos. Quando queimado, gera um cheiro sufocante.",
    "historia":
        "Conhecido desde a antiguidade (referido na Bíblia como 'pedra-pomes'). Lavoisier o reconheceu formalmente como um elemento químico em 1777.",
    "moleculas_principais":
        "H2SO4 (Ácido sulfúrico), SO2 (Dióxido de enxofre), H2S (Gás sulfídrico).",
  },
  {
    "nome": "Cloro",
    "simbolo": "Cl",
    "numero": 17,
    "peso": 35.45,
    "caracteristicas":
        "Halogênio na forma de gás amarelo-esverdeado à temperatura ambiente. É extremamente reativo, tóxico e usado amplamente como desinfetante.",
    "historia":
        "Descoberto por Carl Wilhelm Scheele em 1774, mas foi Humphry Davy em 1810 quem insistiu que era um elemento puro, nomeando-o a partir da palavra grega para 'verde pálido'.",
    "moleculas_principais":
        "NaCl (Cloreto de sódio), HCl (Ácido clorídrico), ClO2 (Dióxido de cloro).",
  },
  {
    "nome": "Argônio",
    "simbolo": "Ar",
    "numero": 18,
    "peso": 39.95,
    "caracteristicas":
        "Gás nobre incolor, inodoro e o terceiro gás mais abundante na atmosfera da Terra. Quimicamente inativo em quase todas as condições.",
    "historia":
        "Descoberto em 1894 por Lord Rayleigh e Sir William Ramsay a partir de amostras de ar limpo, onde notaram a presença de um gás não reativo residual.",
    "moleculas_principais":
        "Raramente forma compostos; o fluoridrato de argônio (HArF) foi sintetizado a temperaturas extremamente baixas.",
  },
  {
    "nome": "Potássio",
    "simbolo": "K",
    "numero": 19,
    "peso": 39.10,
    "caracteristicas":
        "Metal alcalino macio e prateado, altamente reativo. Oxida rapidamente no ar e reage de forma muito violenta com a água. É um mineral essencial para o corpo humano.",
    "historia":
        "Isolado pela primeira vez em 1807 por Humphry Davy a partir da potassa cáustica (hidróxido de potássio), sendo o primeiro metal a ser isolado por eletrólise.",
    "moleculas_principais":
        "KCl (Cloreto de potássio), KOH (Hidróxido de potássio), KNO3 (Nitrato de potássio).",
  },
  {
    "nome": "Cálcio",
    "simbolo": "Ca",
    "numero": 20,
    "peso": 40.08,
    "caracteristicas":
        "Metal alcalinoterroso reativo, cinza e de dureza moderada. É o quinto elemento mais abundante na crosta terrestre e fundamental para a formação de ossos e dentes.",
    "historia":
        "Compostos de cálcio já eram usados pelos romanos no século I. O metal puro foi isolado em 1808 por Humphry Davy através da eletrólise de uma mistura de cal e óxido de mercúrio.",
    "moleculas_principais":
        "CaCO3 (Carbonato de cálcio), CaO (Óxido de cálcio), CaSO4 (Sulfato de cálcio/Gesso).",
  },
  {
    "nome": "Escândio",
    "simbolo": "Sc",
    "numero": 21,
    "peso": 44.96,
    "caracteristicas":
        "Metal de transição macio, prateado e leve. Costuma ser classificado junto aos elementos de terras raras.",
    "historia":
        "Previsto por Dmitri Mendeleev como 'eka-boro', foi descoberto em 1879 por Lars Fredrik Nilson ao estudar os minerais euxenita e gadolinita na Escandinávia.",
    "moleculas_principais":
        "Sc2O3 (Óxido de escândio), ScCl3 (Cloreto de escândio).",
  },
  {
    "nome": "Titânio",
    "simbolo": "Ti",
    "numero": 22,
    "peso": 47.87,
    "caracteristicas":
        "Metal de transição lustroso e prateado. Possui baixa densidade, alta resistência mecânica e é altamente resistente à corrosão, inclusive à água do mar e cloro.",
    "historia":
        "Descoberto na Cornualha em 1791 por William Gregor. Recebeu seu nome de Martin Heinrich Klaproth em homenagem aos Titãs da mitologia grega.",
    "moleculas_principais":
        "TiO2 (Dióxido de titânio), TiCl4 (Tetracloreto de titânio).",
  },
  {
    "nome": "Vanádio",
    "simbolo": "V",
    "numero": 23,
    "peso": 50.94,
    "caracteristicas":
        "Metal de transição duro, maleável e cinza-prateado. Raramente encontrado livre na natureza, sendo muito utilizado para criar ligas de aço de alta resistência.",
    "historia":
        "Descoberto no México por Andrés Manuel del Río em 1801, e redescoberto em 1830 por Nils Gabriel Sefström, que o nomeou em homenagem à deusa nórdica Vanadis.",
    "moleculas_principais": "V2O5 (Pentóxido de vanádio).",
  },
  {
    "nome": "Cromo",
    "simbolo": "Cr",
    "numero": 24,
    "peso": 52.00,
    "caracteristicas":
        "Metal de transição cinza-aço, lustroso, duro e quebradiço. Aceita um alto polimento e resiste bastante a manchas e oxidação.",
    "historia":
        "Descoberto pelo químico francês Louis Nicolas Vauquelin em 1797 no mineral crocoíta. O nome vem da palavra grega 'chroma' (cor), devido aos seus compostos coloridos.",
    "moleculas_principais":
        "Cr2O3 (Óxido de cromo III), K2Cr2O7 (Dicromato de potássio).",
  },
  {
    "nome": "Manganês",
    "simbolo": "Mn",
    "numero": 25,
    "peso": 54.94,
    "caracteristicas":
        "Metal de transição duro, quebradiço e cinza-prateado. Fundamental na fabricação de aços inoxidáveis e ligas de alumínio.",
    "historia":
        "Reconhecido como elemento por Carl Wilhelm Scheele e isolado no mesmo ano (1774) por Johan Gottlieb Gahn, reduzindo o dióxido de manganês com carbono.",
    "moleculas_principais":
        "MnO2 (Dióxido de manganês), KMnO4 (Permanganato de potássio).",
  },
  {
    "nome": "Ferro",
    "simbolo": "Fe",
    "numero": 26,
    "peso": 55.85,
    "caracteristicas":
        "Metal de transição maleável, magnético e de cor prateada. É o elemento mais comum na Terra em massa, formando a maior parte do núcleo do planeta.",
    "historia":
        "O uso do ferro marca um período crucial da história humana (Idade do Ferro), começando por volta de 1200 a.C. As primeiras ligas usadas eram derivadas de meteoritos.",
    "moleculas_principais":
        "Fe2O3 (Óxido de ferro III/Ferrugem), Fe3O4 (Magnetita), FeSO4 (Sulfato de ferro).",
  },
  {
    "nome": "Cobalto",
    "simbolo": "Co",
    "numero": 27,
    "peso": 58.93,
    "caracteristicas":
        "Metal de transição magnético, lustroso e cinza. Historicamente cobiçado para pigmentos azuis, hoje é crucial para baterias de íon-lítio.",
    "historia":
        "Os antigos egípcios já usavam seus compostos como pigmento. O metal foi isolado e reconhecido como elemento pelo químico sueco Georg Brandt por volta de 1735.",
    "moleculas_principais":
        "CoO (Óxido de cobalto), LiCoO2 (Óxido de lítio-cobalto), Vitamina B12.",
  },
  {
    "nome": "Níquel",
    "simbolo": "Ni",
    "numero": 28,
    "peso": 58.69,
    "caracteristicas":
        "Metal de transição branco-prateado com um leve tom dourado. É duro, dúctil e resistente à corrosão, muito usado em cunhagem de moedas e ligas magnéticas.",
    "historia":
        "Isolado em 1751 pelo sueco Axel Fredrik Cronstedt em um mineral chamado 'kupfernickel' (falso cobre), que mineiros culpavam por duendes (Nickel) por não render cobre.",
    "moleculas_principais": "NiO (Óxido de níquel), NiCl2 (Cloreto de níquel).",
  },
  {
    "nome": "Cobre",
    "simbolo": "Cu",
    "numero": 29,
    "peso": 63.55,
    "caracteristicas":
        "Metal de transição avermelhado, macio, maleável e com altíssima condutividade térmica e elétrica. Forma pátina verde quando exposto ao ar por muito tempo.",
    "historia":
        "Um dos primeiros metais usados pela humanidade, com artefatos datando de 8000 a.C. A Era do Bronze surgiu da liga de cobre com estanho.",
    "moleculas_principais":
        "CuSO4 (Sulfato de cobre), CuO (Óxido de cobre II).",
  },
  {
    "nome": "Zinco",
    "simbolo": "Zn",
    "numero": 30,
    "peso": 65.38,
    "caracteristicas":
        "Metal prateado a cinza-azulado, levemente quebradiço à temperatura ambiente. Sua principal aplicação é a galvanização para evitar ferrugem em ferro e aço.",
    "historia":
        "Ligas de zinco (como o latão) são conhecidas há milênios. Foi redescoberto no ocidente como um metal puro e nomeado por Andreas Sigismund Marggraf em 1746.",
    "moleculas_principais":
        "ZnO (Óxido de zinco), ZnS (Sulfeto de zinco), ZnSO4 (Sulfato de zinco).",
  },
  {
    "nome": "Gálio",
    "simbolo": "Ga",
    "numero": 31,
    "peso": 69.72,
    "caracteristicas":
        "Metal macio e prateado que, curiosamente, possui um ponto de fusão tão baixo (29,76 °C) que pode derreter na palma da sua mão.",
    "historia":
        "Sua existência e propriedades foram previstas por Dmitri Mendeleev ('eka-alumínio'). Foi descoberto em 1875 pelo francês Paul-Émile Lecoq de Boisbaudran.",
    "moleculas_principais": "GaAs (Arsenieto de gálio - usado na eletrônica).",
  },
  {
    "nome": "Germânio",
    "simbolo": "Ge",
    "numero": 32,
    "peso": 72.63,
    "caracteristicas":
        "Metaloide lustroso, duro e cinza-branco. É um semicondutor brilhante que foi essencial para a construção dos primeiros transistores.",
    "historia":
        "Também previsto por Mendeleev ('eka-silício'), foi isolado pelo químico alemão Clemens Winkler em 1886 a partir do mineral argirodita.",
    "moleculas_principais": "GeO2 (Dióxido de germânio).",
  },
  {
    "nome": "Arsênio",
    "simbolo": "As",
    "numero": 33,
    "peso": 74.92,
    "caracteristicas":
        "Metaloide notório por sua toxicidade. Em sua forma mais comum, é cinza metálico, cristalino e quebradiço.",
    "historia":
        "Compostos de arsênio eram conhecidos desde a antiguidade clássica. O isolamento do elemento é frequentemente creditado ao alquimista Alberto Magno em 1250.",
    "moleculas_principais":
        "As2O3 (Trióxido de arsênio - veneno clássico), GaAs (Arsenieto de gálio).",
  },
  {
    "nome": "Selênio",
    "simbolo": "Se",
    "numero": 34,
    "peso": 78.97,
    "caracteristicas":
        "Não metal com várias formas alotrópicas. Possui uma propriedade fotocondutora notável: conduz eletricidade muito melhor quando exposto à luz do que na escuridão.",
    "historia":
        "Descoberto em 1817 pelos químicos suecos Jöns Jacob Berzelius e Johan Gottlieb Gahn, após notar um resíduo avermelhado na produção de ácido sulfúrico.",
    "moleculas_principais":
        "H2Se (Seleneto de hidrogênio), SeO2 (Dióxido de selênio).",
  },
  {
    "nome": "Bromo",
    "simbolo": "Br",
    "numero": 35,
    "peso": 79.90,
    "caracteristicas":
        "O único elemento não metálico que é líquido à temperatura ambiente. É um líquido vermelho-acastanhado escuro de cheiro forte que evapora formando um gás tóxico.",
    "historia":
        "Descoberto de forma independente por dois químicos em 1825 e 1826: o francês Antoine Jérôme Balard e o alemão Carl Jacob Löwig.",
    "moleculas_principais":
        "NaBr (Brometo de sódio), AgBr (Brometo de prata - usado em fotografias antigas).",
  },
  {
    "nome": "Criptônio",
    "simbolo": "Kr",
    "numero": 36,
    "peso": 83.80,
    "caracteristicas":
        "Gás nobre incolor, inodoro e insípido. Ocorre em quantidades vestigiais na atmosfera da Terra e é usado em iluminação de alta potência, como flashes fotográficos.",
    "historia":
        "Descoberto em 1898 pelo químico escocês William Ramsay e o químico inglês Morris Travers nos resíduos do ar líquido evaporado.",
    "moleculas_principais":
        "Quase totalmente inerte, mas pode formar KrF2 (Difluoreto de criptônio) sob condições extremas.",
  },
  {
    "nome": "Rubídio",
    "simbolo": "Rb",
    "numero": 37,
    "peso": 85.47,
    "caracteristicas":
        "Metal alcalino muito macio e prateado. É altamente reativo, entra em combustão espontânea em contato com o ar e reage violentamente com a água.",
    "historia":
        "Descoberto em 1861 por Robert Bunsen e Gustav Kirchhoff utilizando a recém-inventada técnica da espectroscopia de chama. O nome vem do latim 'rubidius' (vermelho escuro).",
    "moleculas_principais":
        "RbCl (Cloreto de rubídio), Rb2O (Óxido de rubídio).",
  },
  {
    "nome": "Estrôncio",
    "simbolo": "Sr",
    "numero": 38,
    "peso": 87.62,
    "caracteristicas":
        "Metal alcalinoterroso amarelado, macio e altamente reativo. É mais conhecido por produzir uma chama de coloração vermelho brilhante quando queimado, sendo usado em fogos de artifício.",
    "historia":
        "Reconhecido como novo elemento pelo irlandês Adair Crawford em 1790. Foi isolado apenas em 1808 por Humphry Davy via eletrólise.",
    "moleculas_principais":
        "SrCO3 (Carbonato de estrôncio), Sr(NO3)2 (Nitrato de estrôncio).",
  },
  {
    "nome": "Ítrio",
    "simbolo": "Y",
    "numero": 39,
    "peso": 88.91,
    "caracteristicas":
        "Metal de transição prateado e macio. Costuma ser classificado junto aos elementos terras-raras e é usado para melhorar a liga de outros metais e em telas de LED.",
    "historia":
        "Identificado no mineral gadolinita, descoberto na vila sueca de Ytterby (que deu nome ao elemento) em 1794 pelo químico Johan Gadolin.",
    "moleculas_principais":
        "Y2O3 (Óxido de ítrio), YAG (Granada de ítrio-alumínio).",
  },
  {
    "nome": "Zircônio",
    "simbolo": "Zr",
    "numero": 40,
    "peso": 91.22,
    "caracteristicas":
        "Metal de transição lustroso, cinza-branco e muito forte. É extremamente resistente à corrosão e ao calor, sendo usado em reatores nucleares e implantes dentários.",
    "historia":
        "Klaproth descobriu o óxido de zircônio na pedra zircão em 1789. O metal foi isolado de forma impura por Jöns Jacob Berzelius em 1824.",
    "moleculas_principais":
        "ZrO2 (Dióxido de zircônio/Zircônia), ZrSiO4 (Zircão).",
  },
  {
    "nome": "Nióbio",
    "simbolo": "Nb",
    "numero": 41,
    "peso": 92.91,
    "caracteristicas":
        "Metal de transição macio, cinza e cristalino. É um excelente supercondutor em baixas temperaturas e é amplamente utilizado em ligas de aço para torná-las mais fortes.",
    "historia":
        "Descoberto em 1801 pelo químico inglês Charles Hatchett (que o chamou de colúmbio). O nome oficial, homenageando Níobe da mitologia grega, foi adotado muito depois.",
    "moleculas_principais": "Nb2O5 (Pentóxido de nióbio).",
  },
  {
    "nome": "Molibdênio",
    "simbolo": "Mo",
    "numero": 42,
    "peso": 95.95,
    "caracteristicas":
        "Metal de transição cinza e muito duro. Tem um dos pontos de fusão mais altos de todos os elementos, sendo ideal para ligas resistentes a calor extremo.",
    "historia":
        "Diferenciado do chumbo e grafite por Carl Wilhelm Scheele em 1778, e isolado por Peter Jacob Hjelm em 1781.",
    "moleculas_principais":
        "MoS2 (Dissulfeto de molibdênio - usado como lubrificante sólido).",
  },
  {
    "nome": "Tecnécio",
    "simbolo": "Tc",
    "numero": 43,
    "peso": 98.00,
    "caracteristicas":
        "O elemento mais leve cujos isótopos são todos radioativos. Apresenta cor cinza prateada e tem papel vital em diagnósticos médicos por imagem.",
    "historia":
        "Foi o primeiro elemento predominantemente produzido artificialmente (daí o nome, do grego 'technetos'). Foi sintetizado em 1937 por Carlo Perrier e Emilio Segrè.",
    "moleculas_principais": "NaTcO4 (Pertecnetato de sódio).",
  },
  {
    "nome": "Rutênio",
    "simbolo": "Ru",
    "numero": 44,
    "peso": 101.10,
    "caracteristicas":
        "Metal de transição pertencente ao grupo da platina. É duro, prateado e não oxida a temperaturas ambiente. Usado para endurecer ligas de platina e paládio.",
    "historia":
        "Descoberto pelo cientista russo Karl Ernst Claus em 1844, que o nomeou com a palavra latina 'Ruthenia', que significa Rússia.",
    "moleculas_principais": "RuO4 (Tetróxido de rutênio).",
  },
  {
    "nome": "Ródio",
    "simbolo": "Rh",
    "numero": 45,
    "peso": 102.91,
    "caracteristicas":
        "Um dos metais preciosos mais raros e valiosos do mundo. Prateado, duro e altamente refletor, usado primariamente em catalisadores automotivos e joalheria.",
    "historia":
        "Descoberto em 1803 pelo químico inglês William Hyde Wollaston logo após ter descoberto o paládio, nos minérios de platina brutos.",
    "moleculas_principais": "RhCl3 (Cloreto de ródio III).",
  },
  {
    "nome": "Paládio",
    "simbolo": "Pd",
    "numero": 46,
    "peso": 106.42,
    "caracteristicas":
        "Metal do grupo da platina, branco e prateado. Possui a característica notável de conseguir absorver até 900 vezes seu próprio volume em gás hidrogênio.",
    "historia":
        "Descoberto em 1803 por William Hyde Wollaston, que o nomeou em homenagem ao recém-descoberto asteroide Pallas.",
    "moleculas_principais": "PdCl2 (Cloreto de paládio II).",
  },
  {
    "nome": "Prata",
    "simbolo": "Ag",
    "numero": 47,
    "peso": 107.87,
    "caracteristicas":
        "Metal de transição macio, brilhante e conhecido desde a antiguidade. Apresenta a maior condutividade elétrica, térmica e refletividade de qualquer metal.",
    "historia":
        "Usada como moeda e joias muito antes de termos registros históricos escritos, sendo encontrada em forma elementar em várias partes do mundo.",
    "moleculas_principais":
        "AgNO3 (Nitrato de prata), AgCl (Cloreto de prata).",
  },
  {
    "nome": "Cádmio",
    "simbolo": "Cd",
    "numero": 48,
    "peso": 112.41,
    "caracteristicas":
        "Metal de transição macio, prateado-azulado e altamente tóxico. Por muito tempo foi componente chave em baterias recarregáveis (Ni-Cd).",
    "historia":
        "Descoberto simultaneamente em 1817 pelos alemães Friedrich Stromeyer e Karl Samuel Leberecht Hermann como uma impureza no carbonato de zinco.",
    "moleculas_principais":
        "CdS (Sulfeto de cádmio - pigmento 'amarelo de cádmio').",
  },
  {
    "nome": "Índio",
    "simbolo": "In",
    "numero": 49,
    "peso": 114.82,
    "caracteristicas":
        "Metal pós-transição muito macio, prateado e lustroso. Curiosamente, quando uma barra de índio puro é dobrada, emite um som estridente conhecido como 'grito do estanho'.",
    "historia":
        "Descoberto por espectroscopia em 1863 por Ferdinand Reich e Hieronymous Theodor Richter, notando uma brilhante linha índigo no espectro.",
    "moleculas_principais":
        "ITO (Óxido de índio-estanho - usado em telas sensíveis ao toque).",
  },
  {
    "nome": "Estanho",
    "simbolo": "Sn",
    "numero": 50,
    "peso": 118.71,
    "caracteristicas":
        "Metal pós-transição prateado e maleável que não é facilmente oxidado no ar. Historicamente, fundido com cobre para criar o bronze.",
    "historia":
        "Extraído e utilizado há milhares de anos, sendo um dos elementos fundamentais para o avanço da tecnologia humana na Era do Bronze.",
    "moleculas_principais":
        "SnO2 (Dióxido de estanho), SnCl2 (Cloreto de estanho II).",
  },
  {
    "nome": "Antimônio",
    "simbolo": "Sb",
    "numero": 51,
    "peso": 121.76,
    "caracteristicas":
        "Metaloide sólido e quebradiço de cor cinza e brilho metálico. Hoje em dia é bastante utilizado na fabricação de retardantes de chama para plásticos e tecidos.",
    "historia":
        "Seus compostos, como a estibina, são usados como cosméticos desde o Antigo Egito. Foi reconhecido como um elemento no período da alquimia.",
    "moleculas_principais":
        "Sb2S3 (Trissulfeto de antimônio), Sb2O3 (Trióxido de antimônio).",
  },
  {
    "nome": "Telúrio",
    "simbolo": "Te",
    "numero": 52,
    "peso": 127.60,
    "caracteristicas":
        "Metaloide frágil de cor prateada-branca. Frequentemente ligado ao cobre e aço inox para torná-los mais fáceis de usinar. Contato humano confere um forte odor de alho ao corpo.",
    "historia":
        "Descoberto na Transilvânia em 1782 pelo austríaco Franz-Joseph Müller von Reichenstein. Seu nome deriva do latim 'tellus' (Terra).",
    "moleculas_principais":
        "CdTe (Telureto de cádmio - usado em painéis solares).",
  },
  {
    "nome": "Iodo",
    "simbolo": "I",
    "numero": 53,
    "peso": 126.90,
    "caracteristicas":
        "Halogênio não metálico que, à temperatura ambiente, é um sólido escuro que sublima produzindo um vapor violeta belíssimo, porém tóxico. Essencial para a saúde da tireoide.",
    "historia":
        "Descoberto em 1811 por Bernard Courtois ao destruir algas marinhas para produzir salitre necessário para as Guerras Napoleônicas.",
    "moleculas_principais": "KI (Iodeto de potássio), NaI (Iodeto de sódio).",
  },
  {
    "nome": "Xenônio",
    "simbolo": "Xe",
    "numero": 54,
    "peso": 131.29,
    "caracteristicas":
        "Gás nobre denso, incolor e inodoro. É usado em faróis de carros, projetores de cinema e para gerar pulsos intensos de luz nos lasers.",
    "historia":
        "Descoberto pelo químico William Ramsay e Morris Travers em 1898 nos resíduos restantes após a evaporação do ar líquido. O nome vem do grego 'xenos', significando estranho ou estrangeiro.",
    "moleculas_principais":
        "Apesar de gás nobre, pode formar moléculas fortes como XeF4 (Tetrafluoreto de xenônio) sob pressão e condições corretas.",
  },
  {
    "nome": "Césio",
    "simbolo": "Cs",
    "numero": 55,
    "peso": 132.91,
    "caracteristicas":
        "Metal alcalino dourado-prateado, extremamente macio e o mais reativo dos metais estáveis. Derrete pouco acima da temperatura ambiente.",
    "historia":
        "Descoberto em 1860 por Robert Bunsen e Gustav Kirchhoff usando espectroscopia. Foi o primeiro elemento descoberto por esse método.",
    "moleculas_principais":
        "CsCl (Cloreto de césio). Usado nos relógios atômicos mais precisos do mundo.",
  },
  {
    "nome": "Bário",
    "simbolo": "Ba",
    "numero": 56,
    "peso": 137.33,
    "caracteristicas":
        "Metal alcalinoterroso prateado, macio e altamente reativo. Nunca é encontrado puro na natureza devido à sua rápida oxidação no ar.",
    "historia":
        "Identificado como um novo elemento em 1774 por Carl Wilhelm Scheele e isolado em 1808 por Humphry Davy.",
    "moleculas_principais":
        "BaSO4 (Sulfato de bário - usado como contraste em raios-X do trato gastrointestinal).",
  },
  {
    "nome": "Lantânio",
    "simbolo": "La",
    "numero": 57,
    "peso": 138.91,
    "caracteristicas":
        "Metal de transição (ou terra rara) macio, dúctil e prateado. É o protótipo da série dos lantanídeos.",
    "historia":
        "Descoberto em 1839 pelo químico sueco Carl Gustaf Mosander como uma impureza no nitrato de cério. O nome vem do grego 'lanthanein', que significa 'escondido'.",
    "moleculas_principais":
        "La2O3 (Óxido de lantânio - usado em lentes de câmeras de alta qualidade).",
  },
  {
    "nome": "Cério",
    "simbolo": "Ce",
    "numero": 58,
    "peso": 140.12,
    "caracteristicas":
        "O mais abundante dos elementos terras raras. Metal macio, prateado que oxida rapidamente no ar e pode se inflamar se arranhado (pirofórico).",
    "historia":
        "Descoberto em 1803 por Jöns Jacob Berzelius e Wilhelm Hisinger, e independentemente por Martin Heinrich Klaproth. Nomeado em homenagem ao asteroide Ceres.",
    "moleculas_principais":
        "CeO2 (Dióxido de cério - usado em fornos autolimpantes e polimento de vidros).",
  },
  {
    "nome": "Praseodímio",
    "simbolo": "Pr",
    "numero": 59,
    "peso": 140.91,
    "caracteristicas":
        "Metal terra rara macio e prateado. Seus sais formam belos compostos de coloração verde.",
    "historia":
        "Separado do 'didímio' em 1885 pelo químico austríaco Carl Auer von Welsbach. O nome vem do grego 'prasios' (verde) e 'didymos' (gêmeo).",
    "moleculas_principais":
        "Usado em ligas de magnésio para motores de aviões e nos vidros protetores de soldadores.",
  },
  {
    "nome": "Neodímio",
    "simbolo": "Nd",
    "numero": 60,
    "peso": 144.24,
    "caracteristicas":
        "Metal terra rara prateado que escurece rapidamente no ar. É famoso por formar os ímãs permanentes mais fortes conhecidos.",
    "historia":
        "Também separado do 'didímio' em 1885 por Carl Auer von Welsbach. Significa 'novo gêmeo'.",
    "moleculas_principais":
        "Nd2Fe14B (Ímã de neodímio-ferro-boro, usado em fones de ouvido, discos rígidos e motores elétricos).",
  },
  {
    "nome": "Promécio",
    "simbolo": "Pm",
    "numero": 61,
    "peso": 145.0,
    "caracteristicas":
        "Metal terra rara radioativo. É o único elemento cujos isótopos são todos radioativos entre os elementos com números atômicos menores que o bismuto.",
    "historia":
        "A existência foi prevista em 1902, mas só foi conclusivamente produzido e identificado em 1945 por cientistas do Projeto Manhattan.",
    "moleculas_principais":
        "Usado em tintas luminosas e baterias nucleares de longa duração para espaçonaves.",
  },
  {
    "nome": "Samário",
    "simbolo": "Sm",
    "numero": 62,
    "peso": 150.36,
    "caracteristicas":
        "Metal terra rara moderadamente duro e prateado. É notável por sua resistência à desmagnetização.",
    "historia":
        "Descoberto em 1879 por Paul-Émile Lecoq de Boisbaudran a partir do mineral samarskita (o primeiro elemento a receber o nome de uma pessoa).",
    "moleculas_principais":
        "SmCo5 (Ímã de samário-cobalto - mantém o magnetismo em altas temperaturas).",
  },
  {
    "nome": "Európio",
    "simbolo": "Eu",
    "numero": 63,
    "peso": 151.96,
    "caracteristicas":
        "O mais reativo dos elementos terras raras. Deve ser armazenado em fluido inerte para evitar oxidação rápida.",
    "historia":
        "Encontrado em 1890 por Paul-Émile Lecoq de Boisbaudran, mas o metal puro foi isolado por Eugène-Anatole Demarçay em 1901.",
    "moleculas_principais":
        "Crucial como fósforo emissor de luz vermelha e azul em telas de TV, monitores e lâmpadas fluorescentes.",
  },
  {
    "nome": "Gadolínio",
    "simbolo": "Gd",
    "numero": 64,
    "peso": 157.25,
    "caracteristicas":
        "Metal terra rara prateado. Possui propriedades magnéticas incomuns e captura nêutrons de forma muito eficiente.",
    "historia":
        "Detectado espectroscopicamente em 1880 por Jean Charles Galissard de Marignac. Nomeado em homenagem ao químico Johan Gadolin.",
    "moleculas_principais":
        "Compostos de gadolínio são amplamente usados como agentes de contraste intravenoso em exames de ressonância magnética (RM).",
  },
  {
    "nome": "Térbio",
    "simbolo": "Tb",
    "numero": 65,
    "peso": 158.93,
    "caracteristicas":
        "Metal terra rara prateado, macio e dúctil. É brilhantemente fluorescente.",
    "historia":
        "Descoberto em 1843 pelo químico sueco Carl Gustaf Mosander. É um dos quatro elementos nomeados em homenagem à vila sueca de Ytterby.",
    "moleculas_principais":
        "Usado como fósforo verde em telas, além de estabilizadores de células de combustível de óxido sólido.",
  },
  {
    "nome": "Disprósio",
    "simbolo": "Dy",
    "numero": 66,
    "peso": 162.50,
    "caracteristicas":
        "Metal terra rara com brilho prateado. É tão macio que pode ser cortado com uma faca e tem alta suscetibilidade magnética.",
    "historia":
        "Identificado em 1886 por Paul-Émile Lecoq de Boisbaudran. O nome vem do grego 'dysprositos', que significa 'difícil de obter'.",
    "moleculas_principais":
        "Usado em barras de controle de reatores nucleares e em ímãs potentes sob altas temperaturas.",
  },
  {
    "nome": "Hólmio",
    "simbolo": "Ho",
    "numero": 67,
    "peso": 164.93,
    "caracteristicas":
        "Metal terra rara macio, maleável e prateado. Possui a maior força magnética de todos os elementos naturais.",
    "historia":
        "Descoberto em 1878 por Marc Delafontaine e Jacques-Louis Soret, e independentemente no ano seguinte por Per Teodor Cleve.",
    "moleculas_principais":
        "Usado em ímãs de altíssima potência, lasers médicos e para concentrar campos magnéticos de ressonância magnética.",
  },
  {
    "nome": "Érbio",
    "simbolo": "Er",
    "numero": 68,
    "peso": 167.26,
    "caracteristicas":
        "Metal terra rara prateado, macio. Seus sais costumam ter uma coloração rosa vibrante.",
    "historia":
        "Descoberto em 1843 por Carl Gustaf Mosander em Ytterby. O metal puro só foi isolado de forma eficiente em 1934.",
    "moleculas_principais":
        "Er2O3 (Óxido de érbio). Crucial em amplificadores de fibra óptica para transmissão de dados em longas distâncias.",
  },
  {
    "nome": "Túlio",
    "simbolo": "Tm",
    "numero": 69,
    "peso": 168.93,
    "caracteristicas":
        "O segundo menos abundante dos lantanídeos (após o promécio). É um metal macio e facilmente maleável.",
    "historia":
        "Descoberto em 1879 por Per Teodor Cleve, que procurava impurezas em óxidos de outros elementos de terras raras. Nomeado em homenagem à mítica terra de Thule.",
    "moleculas_principais":
        "Túlio bombardeado em reatores é usado como uma fonte de radiação em equipamentos portáteis de raios-X.",
  },
  {
    "nome": "Itérbio",
    "simbolo": "Yb",
    "numero": 70,
    "peso": 173.05,
    "caracteristicas":
        "Metal terra rara macio e prateado. É relativamente reativo e possui três formas alotrópicas (alfa, beta e gama).",
    "historia":
        "Descoberto em 1878 por Jean Charles Galissard de Marignac. O quarto e último elemento nomeado em homenagem à vila de Ytterby.",
    "moleculas_principais":
        "Usado em relógios atômicos extremamente precisos, lasers de estado sólido e em sismógrafos.",
  },
  {
    "nome": "Lutécio",
    "simbolo": "Lu",
    "numero": 71,
    "peso": 174.97,
    "caracteristicas":
        "O mais denso e duro dos lantanídeos. É um metal branco-prateado resistente à corrosão.",
    "historia":
        "Descoberto independentemente em 1907 pelo francês Georges Urbain e o austríaco Carl Auer von Welsbach. Nomeado em homenagem a Lutécia (nome romano de Paris).",
    "moleculas_principais":
        "Usado em detectores para tomografia por emissão de pósitrons (PET scans) e catalisadores de refino de petróleo.",
  },
  {
    "nome": "Háfnio",
    "simbolo": "Hf",
    "numero": 72,
    "peso": 178.49,
    "caracteristicas":
        "Metal de transição brilhante, prateado e dúctil. É quase sempre encontrado em minérios de zircônio e é um forte absorvedor de nêutrons.",
    "historia":
        "Descoberto em 1923 por Dirk Coster e George de Hevesy em Copenhague. Seu nome vem de 'Hafnia', o nome em latim da cidade.",
    "moleculas_principais":
        "HfO2 (Óxido de háfnio - usado em microprocessadores modernos). Muito usado em barras de controle de submarinos nucleares.",
  },
  {
    "nome": "Tântalo",
    "simbolo": "Ta",
    "numero": 73,
    "peso": 180.95,
    "caracteristicas":
        "Metal de transição denso, duro e azul-acinzentado. Altamente resistente à corrosão por ácidos corporais e fluidos.",
    "historia":
        "Descoberto em 1802 por Anders Gustaf Ekeberg. O nome alude a Tântalo da mitologia grega, devido à dificuldade de dissolvê-lo em ácidos.",
    "moleculas_principais":
        "Usado primariamente em capacitores menores e eficientes para smartphones e computadores, e em implantes cirúrgicos.",
  },
  {
    "nome": "Tungstênio",
    "simbolo": "W",
    "numero": 74,
    "peso": 183.84,
    "caracteristicas":
        "Metal de transição denso, de cor cinza-aço a branco. É notório por ter o ponto de fusão mais alto de todos os metais não ligados e a maior resistência à tração.",
    "historia":
        "Isolado em 1783 pelos irmãos espanhóis Juan José e Fausto Elhuyar. O símbolo 'W' vem de seu outro nome, 'Wolfram' (Volfrâmio).",
    "moleculas_principais":
        "WC (Carbeto de tungstênio - usado em brocas e serras incrivelmente duras). Usado em filamentos de lâmpadas.",
  },
  {
    "nome": "Rênio",
    "simbolo": "Re",
    "numero": 75,
    "peso": 186.21,
    "caracteristicas":
        "Metal de transição prateado e pesado. Tem o segundo maior ponto de ebulição e o terceiro maior ponto de fusão de todos os elementos estáveis.",
    "historia":
        "O último elemento estável a ser descoberto. Encontrado em 1925 por Walter Noddack, Ida Tacke e Otto Berg. Nomeado em homenagem ao rio Reno.",
    "moleculas_principais":
        "Superligas à base de níquel com rênio são usadas nas câmaras de combustão, pás de turbinas e exaustão de motores a jato.",
  },
  {
    "nome": "Ósmio",
    "simbolo": "Os",
    "numero": 76,
    "peso": 190.23,
    "caracteristicas":
        "Metal de transição do grupo da platina, duro e azul-acinzentado. É o elemento natural mais denso do universo.",
    "historia":
        "Descoberto em 1803 por Smithson Tennant e William Hyde Wollaston num resíduo negro após dissolver platina. O nome vem do grego 'osme' (odor).",
    "moleculas_principais":
        "OsO4 (Tetróxido de ósmio - composto altamente tóxico, usado em impressões digitais forenses e microscopia eletrônica).",
  },
  {
    "nome": "Irídio",
    "simbolo": "Ir",
    "numero": 77,
    "peso": 192.22,
    "caracteristicas":
        "Metal de transição do grupo da platina, denso, duro e muito quebradiço. É o metal mais resistente à corrosão conhecido.",
    "historia":
        "Descoberto no mesmo resíduo de platina que o ósmio em 1803 por Smithson Tennant. Nomeado devido aos seus sais incrivelmente coloridos (Íris = arco-íris).",
    "moleculas_principais":
        "Sua presença numa camada global de argila é a principal evidência de que um asteroide extinguiu os dinossauros. Usado em velas de ignição.",
  },
  {
    "nome": "Platina",
    "simbolo": "Pt",
    "numero": 78,
    "peso": 195.08,
    "caracteristicas":
        "Metal de transição denso, maleável, dúctil e muito inerte. Embora seja valioso, é muito usado pela indústria química como catalisador.",
    "historia":
        "Conhecida pelos povos pré-colombianos, foi referida por europeus no século 16 como 'platina' (pequena prata), um incômodo que estragava o ouro.",
    "moleculas_principais":
        "Cisplatina (Medicamento crucial para quimioterapia contra o câncer). Muito usada em conversores catalíticos de veículos.",
  },
  {
    "nome": "Ouro",
    "simbolo": "Au",
    "numero": 79,
    "peso": 196.97,
    "caracteristicas":
        "Metal de transição amarelo brilhante, extremamente maleável e dúctil. É quase completamente inerte a ataques químicos.",
    "historia":
        "Conhecido e reverenciado desde os tempos pré-históricos em quase todas as culturas antigas devido à sua beleza e resistência ao tempo.",
    "moleculas_principais":
        "Usado predominantemente como reserva de valor, joias, e por sua excelente condutividade em conexões de eletrônica de precisão.",
  },
  {
    "nome": "Mercúrio",
    "simbolo": "Hg",
    "numero": 80,
    "peso": 200.59,
    "caracteristicas":
        "Metal de transição pesado e prateado. É o único metal puro conhecido a ser líquido em temperatura ambiente. Extremamente tóxico.",
    "historia":
        "Encontrado em tumbas egípcias que datam de 1500 a.C. Os alquimistas acreditavam que era a 'primeira matéria' da qual todos os metais eram formados.",
    "moleculas_principais":
        "HgS (Sulfeto de mercúrio/Cinábrio). Foi usado em barômetros e termômetros, mas foi amplamente abandonado por sua toxicidade.",
  },
  {
    "nome": "Tálio",
    "simbolo": "Tl",
    "numero": 81,
    "peso": 204.38,
    "caracteristicas":
        "Metal pós-transição macio e cinza que embaça rapidamente no ar. É altamente tóxico, causando perda de cabelo e danos ao sistema nervoso.",
    "historia":
        "Descoberto em 1861 por William Crookes através da espectroscopia de chama (emitia uma linha verde brilhante, 'thallos' em grego).",
    "moleculas_principais":
        "Tl2SO4 (Sulfato de tálio - outrora o veneno de rato mais popular do mundo, apelidado de 'veneno dos envenenadores').",
  },
  {
    "nome": "Chumbo",
    "simbolo": "Pb",
    "numero": 82,
    "peso": 207.2,
    "caracteristicas":
        "Metal pós-transição denso, macio, pesado e maleável com cor cinza-azulada. Apesar de útil, é uma neurotoxina severa acumulativa.",
    "historia":
        "Usado extensivamente pelos romanos para encanamentos (a palavra 'encanador/plumber' vem do latim 'plumbum').",
    "moleculas_principais":
        "Usado em baterias de carro (chumbo-ácido), blindagem contra radiação de raios-X em hospitais e munições.",
  },
  {
    "nome": "Bismuto",
    "simbolo": "Bi",
    "numero": 83,
    "peso": 208.98,
    "caracteristicas":
        "Metal pós-transição pesado, quebradiço, com tom rosado e cristalização iridescente. Ao contrário do chumbo, tem toxicidade muito baixa.",
    "historia":
        "Conhecido desde a antiguidade, mas frequentemente confundido com chumbo ou estanho até ser classificado como elemento no século XVIII.",
    "moleculas_principais":
        "Subsalicilato de bismuto (remédios estomacais). Substituto não-tóxico do chumbo em ligas de solda e encanamentos.",
  },
  {
    "nome": "Polônio",
    "simbolo": "Po",
    "numero": 84,
    "peso": 209.0,
    "caracteristicas":
        "Metaloide altamente radioativo e extremamente tóxico. Uma minúscula quantidade pode gerar calor suficiente para derreter a si mesma.",
    "historia":
        "Descoberto em 1898 por Marie e Pierre Curie, que processaram toneladas de pechblenda para isolá-lo. Foi nomeado em homenagem à Polônia.",
    "moleculas_principais":
        "Usado para eliminar estática industrial e servir como fonte de calor e nêutrons em equipamentos especializados.",
  },
  {
    "nome": "Astato",
    "simbolo": "At",
    "numero": 85,
    "peso": 210.0,
    "caracteristicas":
        "Halogênio radioativo e extremamente instável. É o elemento natural mais raro na crosta terrestre (existem menos de 30 gramas no planeta todo).",
    "historia":
        "Sintetizado pela primeira vez em 1940 por Corson, MacKenzie e Segrè na Universidade da Califórnia, bombardeando bismuto.",
    "moleculas_principais":
        "Devido à sua meia-vida curta (poucas horas), a maior parte de sua química é inferida, mas é testado para terapias de câncer direcionadas.",
  },
  {
    "nome": "Radônio",
    "simbolo": "Rn",
    "numero": 86,
    "peso": 222.0,
    "caracteristicas":
        "Gás nobre radioativo, incolor e inodoro. É gerado pelo decaimento natural do rádio e do urânio no subsolo.",
    "historia":
        "Descoberto em 1899 por Ernest Rutherford e Robert B. Owens, e Friedrich Ernst Dorn em 1900.",
    "moleculas_principais":
        "Sua exalação natural do solo pode se acumular em porões sem ventilação, sendo um grave risco à saúde respiratória.",
  },
  {
    "nome": "Frâncio",
    "simbolo": "Fr",
    "numero": 87,
    "peso": 223.0,
    "caracteristicas":
        "Metal alcalino altamente radioativo e extremamente raro. É o elemento mais instável dos primeiros 101 elementos da tabela periódica.",
    "historia":
        "Descoberto em 1939 por Marguerite Perey, uma assistente de Marie Curie no Instituto Curie em Paris. O nome é uma homenagem à França.",
    "moleculas_principais":
        "Não forma compostos duradouros devido à sua extrema instabilidade e meia-vida de apenas 22 minutos.",
  },
  {
    "nome": "Rádio",
    "simbolo": "Ra",
    "numero": 88,
    "peso": 226.0,
    "caracteristicas":
        "Metal alcalinoterroso branco-prateado, altamente radioativo. Quando exposto ao ar, escurece e, devido à forte radiação, brilha com uma fraca luz azul.",
    "historia":
        "Descoberto em 1898 por Marie Curie e Pierre Curie na pechblenda (minério de urânio). O nome vem do latim 'radius' (raio).",
    "moleculas_principais":
        "RaCl2 (Cloreto de rádio). Antigamente usado em tintas luminosas para relógios, prática abolida devido aos graves riscos à saúde.",
  },
  {
    "nome": "Actínio",
    "simbolo": "Ac",
    "numero": 89,
    "peso": 227.0,
    "caracteristicas":
        "Metal prateado brilhante, macio e altamente radioativo. É o protótipo da série dos actinídeos e brilha intensamente com uma luz azul no escuro.",
    "historia":
        "Descoberto em 1899 pelo químico francês André-Louis Debierne. O nome deriva do grego 'aktis', que significa raio ou feixe de luz.",
    "moleculas_principais":
        "Compostos de actínio são estudados para uso em terapias de radiação direcionada contra o câncer.",
  },
  {
    "nome": "Tório",
    "simbolo": "Th",
    "numero": 90,
    "peso": 232.0,
    "caracteristicas":
        "Metal actinídeo prateado que mancha lentamente no ar. É ligeiramente radioativo, mas muito abundante, sendo considerado um potencial combustível nuclear do futuro.",
    "historia":
        "Descoberto em 1828 pelo químico sueco Jöns Jacob Berzelius. O nome é uma homenagem a Thor, o deus nórdico do trovão.",
    "moleculas_principais":
        "ThO2 (Dióxido de tório - costumava ser usado em camisas de lampiões a gás devido ao seu alto ponto de fusão).",
  },
  {
    "nome": "Protactínio",
    "simbolo": "Pa",
    "numero": 91,
    "peso": 231.0,
    "caracteristicas":
        "Metal actinídeo denso, prateado e radioativo. É altamente tóxico e um dos elementos naturais mais raros e caros de se isolar.",
    "historia":
        "Identificado pela primeira vez em 1913 por Kasimir Fajans e Otto Göhring. O isótopo mais duradouro foi isolado por Lise Meitner e Otto Hahn em 1917.",
    "moleculas_principais":
        "Devido à sua escassez e toxicidade, não possui aplicações fora da pesquisa científica rigorosa.",
  },
  {
    "nome": "Urânio",
    "simbolo": "U",
    "numero": 92,
    "peso": 238.0,
    "caracteristicas":
        "Metal actinídeo denso, prateado e radioativo. É o elemento de maior peso atômico encontrado em grandes quantidades na natureza.",
    "historia":
        "Descoberto no minério de pechblenda em 1789 por Martin Heinrich Klaproth. Nomeado em homenagem ao planeta Urano.",
    "moleculas_principais":
        "U3O8 (Óxido de urânio/Yellowcake), UF6 (Hexafluoreto de urânio). Fundamental como combustível em reatores nucleares.",
  },
  {
    "nome": "Netúnio",
    "simbolo": "Np",
    "numero": 93,
    "peso": 237.0,
    "caracteristicas":
        "Metal actinídeo radioativo, prateado e reativo. É o primeiro elemento transurânico (além do urânio) na tabela periódica.",
    "historia":
        "Sintetizado pela primeira vez em 1940 por Edwin McMillan e Philip Abelson na Universidade da Califórnia. Nomeado após o planeta Netuno.",
    "moleculas_principais":
        "Sua principal função é ser um precursor na produção artificial de Plutônio-238.",
  },
  {
    "nome": "Plutônio",
    "simbolo": "Pu",
    "numero": 94,
    "peso": 244.0,
    "caracteristicas":
        "Metal actinídeo radioativo, cinza-prateado, que oxida rapidamente para uma cor amarelada opaca. Extremamente denso e fonte de imensa energia.",
    "historia":
        "Sintetizado em 1940 pela equipe de Glenn T. Seaborg bombardeando urânio com deutério. Mantido em segredo absoluto até o fim da Segunda Guerra Mundial.",
    "moleculas_principais":
        "PuO2 (Dióxido de plutônio). Usado em armas nucleares (isótopo 239) e como gerador de energia para sondas espaciais profundas (isótopo 238).",
  },
  {
    "nome": "Amerício",
    "simbolo": "Am",
    "numero": 95,
    "peso": 243.0,
    "caracteristicas":
        "Metal actinídeo sintético, radioativo e prateado. É o único elemento sintético que tem presença comum em muitas residências ao redor do mundo.",
    "historia":
        "Sintetizado em 1944 pelo grupo de Glenn T. Seaborg no Projeto Manhattan. Nomeado em homenagem ao continente das Américas.",
    "moleculas_principais":
        "AmO2 (Dióxido de amerício). Usado mundialmente em detectores de fumaça por ionização comercializados para uso doméstico.",
  },
  {
    "nome": "Cúrio",
    "simbolo": "Cm",
    "numero": 96,
    "peso": 247.0,
    "caracteristicas":
        "Metal actinídeo sintético, duro, denso e prateado. É intensamente radioativo e seus compostos podem brilhar no escuro com o próprio calor gerado.",
    "historia":
        "Sintetizado em 1944 pela equipe de Glenn T. Seaborg. O nome é uma homenagem aos pioneiros da radioatividade, Marie e Pierre Curie.",
    "moleculas_principais":
        "Usado como fonte de partículas alfa em espectrômetros de raios-X para rovers marcianos (como o Curiosity).",
  },
  {
    "nome": "Berquélio",
    "simbolo": "Bk",
    "numero": 97,
    "peso": 247.0,
    "caracteristicas":
        "Metal actinídeo sintético, prateado e altamente radioativo. É muito difícil de produzir e não tem aplicações fora da pesquisa básica.",
    "historia":
        "Sintetizado em 1949 por Stanley Thompson, Albert Ghiorso e Glenn Seaborg. Nomeado em homenagem à cidade de Berkeley, Califórnia.",
    "moleculas_principais":
        "Usado exclusivamente como material alvo em laboratórios para sintetizar elementos ainda mais pesados (como o Tennesso).",
  },
  {
    "nome": "Califórnio",
    "simbolo": "Cf",
    "numero": 98,
    "peso": 251.0,
    "caracteristicas":
        "Metal actinídeo sintético, forte emissor de nêutrons. É um dos elementos mais caros do mundo de se produzir.",
    "historia":
        "Criado em 1950 no Laboratório Nacional Lawrence Berkeley. Como o nome sugere, é uma homenagem ao estado e à Universidade da Califórnia.",
    "moleculas_principais":
        "Sua altíssima emissão de nêutrons o torna útil em medidores de umidade de poços de petróleo e no tratamento de certos cânceres cerebrais.",
  },
  {
    "nome": "Einstênio",
    "simbolo": "Es",
    "numero": 99,
    "peso": 252.0,
    "caracteristicas":
        "Metal actinídeo sintético altamente radioativo. A intensa radiação destrói a própria rede cristalina do metal, dificultando seu estudo.",
    "historia":
        "Descoberto em 1952 nos destroços da primeira explosão de uma bomba de hidrogênio (teste Ivy Mike). Nomeado em homenagem a Albert Einstein.",
    "moleculas_principais":
        "Produzido em quantidades minúsculas apenas para criar elementos mais pesados.",
  },
  {
    "nome": "Férmio",
    "simbolo": "Fm",
    "numero": 100,
    "peso": 257.0,
    "caracteristicas":
        "Metal actinídeo sintético. É o elemento mais pesado que pode ser criado bombardeando elementos mais leves com nêutrons em reatores nucleares.",
    "historia":
        "Descoberto junto com o Einstênio nos resíduos da explosão da bomba de hidrogênio Ivy Mike em 1952. Homenageia o físico Enrico Fermi.",
    "moleculas_principais":
        "Sem aplicação fora da pesquisa acadêmica de física nuclear.",
  },
  {
    "nome": "Mendelévio",
    "simbolo": "Md",
    "numero": 101,
    "peso": 258.0,
    "caracteristicas":
        "Actinídeo sintético, radioativo. O primeiro elemento a ser sintetizado literalmente 'átomo por átomo'.",
    "historia":
        "Sintetizado em 1955 por Albert Ghiorso, Glenn Seaborg e equipe. Uma justa homenagem a Dmitri Mendeleev, o pai da tabela periódica.",
    "moleculas_principais": "Pesquisa científica apenas.",
  },
  {
    "nome": "Nobélio",
    "simbolo": "No",
    "numero": 102,
    "peso": 259.0,
    "caracteristicas":
        "Actinídeo sintético, extremamente radioativo. Muito pouco se sabe sobre suas propriedades químicas físicas devido à rápida desintegração.",
    "historia":
        "A descoberta foi fortemente contestada durante a Guerra Fria entre equipes dos EUA e da URSS. O nome homenageia Alfred Nobel.",
    "moleculas_principais": "Pesquisa científica avançada.",
  },
  {
    "nome": "Laurêncio",
    "simbolo": "Lr",
    "numero": 103,
    "peso": 262.0,
    "caracteristicas":
        "Último membro da série dos actinídeos. É um metal sintético que existe apenas em frações de segundos ou minutos em laboratório.",
    "historia":
        "Sintetizado em 1961 pela equipe de Albert Ghiorso nos EUA. Nomeado em homenagem a Ernest Lawrence, inventor do ciclotron (acelerador de partículas).",
    "moleculas_principais": "Apenas pesquisa atômica.",
  },
  {
    "nome": "Rutherfórdio",
    "simbolo": "Rf",
    "numero": 104,
    "peso": 267.0,
    "caracteristicas":
        "O primeiro dos elementos superpesados pós-actinídeos (metais de transição). Altamente instável e radioativo.",
    "historia":
        "Outro elemento com descoberta contestada entre Dubna (URSS, 1964) e Berkeley (EUA, 1969). Homenageia Ernest Rutherford, o pai da física nuclear.",
    "moleculas_principais": "Não forma moléculas na natureza.",
  },
  {
    "nome": "Dúbnio",
    "simbolo": "Db",
    "numero": 105,
    "peso": 270.0,
    "caracteristicas":
        "Elemento sintético superpesado. Seu comportamento químico, nas poucas vezes que pôde ser testado, assemelha-se ao do nióbio.",
    "historia":
        "Sintetizado nos anos 60 e 70 por americanos e soviéticos. Em 1997, a IUPAC o nomeou Dúbnio, em homenagem ao Instituto de Dubna na Rússia.",
    "moleculas_principais": "Somente experimentos com átomos isolados.",
  },
  {
    "nome": "Seabórgio",
    "simbolo": "Sg",
    "numero": 106,
    "peso": 271.0,
    "caracteristicas":
        "Metal de transição sintético superpesado. É um isótopo tão efêmero que suas reações precisam ser medidas em frações de segundo.",
    "historia":
        "Criado em 1974. A decisão de nomeá-lo em homenagem ao químico Glenn T. Seaborg causou controvérsia por ele ainda estar vivo na época.",
    "moleculas_principais": "Nenhuma fora de laboratórios quânticos.",
  },
  {
    "nome": "Bóhrio",
    "simbolo": "Bh",
    "numero": 107,
    "peso": 270.0,
    "caracteristicas":
        "Elemento sintético e radioativo. Prevê-se que seja um metal denso com propriedades semelhantes às do rênio.",
    "historia":
        "Sintetizado conclusivamente em 1981 por pesquisadores do GSI Helmholtz Centre na Alemanha. O nome homenageia o físico dinamarquês Niels Bohr.",
    "moleculas_principais": "Não possui compostos estáveis.",
  },
  {
    "nome": "Hássio",
    "simbolo": "Hs",
    "numero": 108,
    "peso": 277.0,
    "caracteristicas":
        "Elemento sintético superpesado. Experimentos confirmaram que ele reage com oxigênio para formar um tetróxido muito volátil, como o ósmio.",
    "historia":
        "Sintetizado em 1984 pela mesma equipe alemã do GSI. Nomeado em homenagem a Hesse, o estado alemão onde fica o instituto.",
    "moleculas_principais":
        "HsO4 (Tetróxido de hássio - detectado em experimentos com poucos átomos).",
  },
  {
    "nome": "Meitnério",
    "simbolo": "Mt",
    "numero": 109,
    "peso": 278.0,
    "caracteristicas":
        "Metal de transição superpesado do qual praticamente só conhecemos as propriedades nucleares, devido à curtíssima duração de seus átomos.",
    "historia":
        "Sintetizado em 1982 no instituto GSI na Alemanha. É uma homenagem à física Lise Meitner, uma das descobridoras da fissão nuclear.",
    "moleculas_principais": "Apenas pesquisa.",
  },
  {
    "nome": "Darmstádtio",
    "simbolo": "Ds",
    "numero": 110,
    "peso": 281.0,
    "caracteristicas":
        "Elemento radioativo sintético. Pertence ao grupo 10, o que teoricamente o faria agir como um parente superpesado da platina.",
    "historia":
        "Criado pela primeira vez em 1994 pela equipe do GSI na Alemanha. O nome celebra a cidade de Darmstadt, sede do laboratório.",
    "moleculas_principais": "Nenhum composto conhecido.",
  },
  {
    "nome": "Roentgênio",
    "simbolo": "Rg",
    "numero": 111,
    "peso": 282.0,
    "caracteristicas":
        "Elemento superpesado incrivelmente instável. Ficaria no grupo dos metais de cunhagem (ouro, prata, cobre), mas não sobrevive tempo suficiente para formar uma moeda.",
    "historia":
        "Descoberto no GSI (Alemanha) em 1994 bombardeando bismuto com níquel. Homenageia Wilhelm Conrad Röntgen, o descobridor dos raios-X.",
    "moleculas_principais": "Inexistente fora da pesquisa básica.",
  },
  {
    "nome": "Copernício",
    "simbolo": "Cn",
    "numero": 112,
    "peso": 285.0,
    "caracteristicas":
        "Elemento sintético. Simulações indicam que, devido a efeitos relativísticos, ele seria um gás nobre volátil à temperatura ambiente, em vez de um metal líquido como o mercúrio.",
    "historia":
        "Sintetizado em 1996 no GSI, Alemanha. Em 2010 foi batizado em homenagem a Nicolau Copérnico, o astrônomo do heliocentrismo.",
    "moleculas_principais": "Nenhuma aplicação.",
  },
  {
    "nome": "Nihônio",
    "simbolo": "Nh",
    "numero": 113,
    "peso": 286.0,
    "caracteristicas":
        "Metal pós-transição superpesado e extremamente instável. Antigamente referido como Unúntrio e, em algumas listas mais antigas, por variações como Nipônio.",
    "historia":
        "Sintetizado em 2004 pelo instituto RIKEN. Foi o primeiro elemento da tabela periódica descoberto inteiramente no Japão ('Nihon' é uma maneira de dizer Japão em japonês).",
    "moleculas_principais": "Não forma compostos úteis.",
  },
  {
    "nome": "Fleróvio",
    "simbolo": "Fl",
    "numero": 114,
    "peso": 289.0,
    "caracteristicas":
        "Elemento sintético superpesado. É alvo de intensos estudos por potencialmente pertencer a uma teorizada 'ilha de estabilidade' nuclear.",
    "historia":
        "Produzido em 1998 pelo Instituto Conjunto de Pesquisa Nuclear em Dubna, Rússia. Nomeado em homenagem ao Laboratório de Reações Nucleares Flerov.",
    "moleculas_principais": "Somente pesquisa quântica.",
  },
  {
    "nome": "Moscóvio",
    "simbolo": "Mc",
    "numero": 115,
    "peso": 290.0,
    "caracteristicas":
        "Elemento superpesado radioativo. Foi muito popularizado na cultura pop por teóricos da conspiração nos anos 80 (como o mítico 'Elemento 115' de OVNIs) bem antes de ser confirmado.",
    "historia":
        "Sintetizado oficialmente em 2003 por uma parceria russo-americana em Dubna. Nomeado em homenagem à região (oblast) de Moscou.",
    "moleculas_principais":
        "Nenhuma molécula natural ou sintética útil fora do laboratório.",
  },
  {
    "nome": "Livermório",
    "simbolo": "Lv",
    "numero": 116,
    "peso": 293.0,
    "caracteristicas":
        "Elemento calcogênio superpesado (no mesmo grupo do oxigênio e polônio). É puramente criado artificialmente e tem decaimento quase imediato.",
    "historia":
        "Sintetizado de forma confirmada em 2000 por cientistas russos (Dubna) e americanos. Nomeado em homenagem ao Laboratório Nacional Lawrence Livermore.",
    "moleculas_principais": "Não participa de processos químicos estáveis.",
  },
  {
    "nome": "Tennesso",
    "simbolo": "Ts",
    "numero": 117,
    "peso": 294.0,
    "caracteristicas":
        "Elemento superpesado, altamente radioativo e instável. Acredita-se que, ao contrário dos outros gases nobres, ele possa ser um sólido em temperatura ambiente devido a efeitos relativísticos.",
    "historia":
        "Sintetizado pela primeira vez em 2010 por uma equipe liderada por pesquisadores do Laboratório Nacional Lawrence Livermore dos EUA, em colaboração com o Instituto Conjunto de Pesquisa Nuclear em Dubna, Rússia. Foi produzido bombardeando átomos de berquélio com íons de cálcio. Nomeado em homenagem ao estado americano do Tennessee, onde o laboratório Lawrence Livermore está localizado.",
    "moleculas_principais":
        "Não forma moléculas na natureza devido à sua meia-vida de frações de milissegundo.",
  },
  {
    "nome": "Oganessônio",
    "simbolo": "Og",
    "numero": 118,
    "peso": 294.0,
    "caracteristicas":
        "Elemento superpesado, altamente radioativo e instável. Acredita-se que, ao contrário dos outros gases nobres, ele possa ser um sólido em temperatura ambiente devido a efeitos relativísticos.",
    "historia":
        "Sintetizado pela primeira vez em 2002 pela equipe do Instituto Conjunto de Pesquisa Nuclear em Dubna, Rússia, em colaboração com o Laboratório Nacional Lawrence Livermore dos EUA. Foi produzido bombardeando átomos de califórnio com íons de cálcio. Nomeado em homenagem ao físico Yuri Oganessian.",
    "moleculas_principais":
        "Não forma moléculas na natureza devido à sua meia-vida de frações de milissegundo.",
  },
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

    // NOVO: Número atômico no canto superior esquerdo
    // Obs: Confirme se a chave no seu Map é 'numero' mesmo. Se for 'id' ou outra coisa, é só trocar aqui!
    TextPaint(
      style: TextStyle(
        color: textColor,
        fontSize:
            15, // Um pouco maior para manter a proporção da caixa de 100x100
        fontWeight: FontWeight.bold,
      ),
    ).render(
      canvas,
      "${dados['numero'] ?? ''}",
      Vector2(6, 4), // Coordenada X, Y para simular o "left: 4, top: 2"
      anchor: Anchor.topLeft,
    );

    // Textos centrais mantidos intactos
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
      "${dados['peso']}u",
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
      //minScale: 0.00001, // Zoom-out ideal para ver a tabela toda
      //maxScale: 1.5, // Limite de zoom-in (não tão exagerado)
      child: Container(
        padding: const EdgeInsets.all(16),
        width: (18 * (tamanhoCelula + espacamento)) + 112,
        // Aumentei o height para garantir que as últimas linhas não sejam cortadas
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
