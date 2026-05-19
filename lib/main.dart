import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';
import 'data/elementos_data.dart'; // Importação do arquivo de dados para carregar o JSON

void main() async {
  // Garante que o Flutter e os plugins nativos (como o Firebase) estejam prontos antes de iniciar
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações do google-services.json
  await Firebase.initializeApp();

  // Carrega os elementos usando o nome exato da função do seu elementos_data.dart!
  await carregarDados();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  // Função para alternar o tema do app entre Claro e Escuro
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atomic Craft',
      // Alterna dinamicamente as cores de acordo com o estado do tema
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(onThemeToggle: toggleTheme),
    );
  }
}
