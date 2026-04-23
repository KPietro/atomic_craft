import 'package:flutter/material.dart';
import 'data/elementos_data.dart';
import 'pages/home_page.dart';

// --- APP ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chama a função que carrega os seus dois JSONs (elementos e moleculas)
  await carregarDados();

  runApp(const MyApp());
}

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

      // Passando a HomePage sem o underline
      home: HomePage(onThemeToggle: toggleTema),
      debugShowCheckedModeBanner: false,
    );
  }
}
