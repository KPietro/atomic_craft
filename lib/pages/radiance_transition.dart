import 'package:flutter/material.dart';

class RadianceTransition extends StatefulWidget {
  final Widget proximaTela;
  const RadianceTransition({super.key, required this.proximaTela});

  @override
  State<RadianceTransition> createState() => _RadianceTransitionState();
}

class _RadianceTransitionState extends State<RadianceTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _brilhoAbsoluto;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Duração do clarão
    );

    _brilhoAbsoluto = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInExpo));

    // Inicia o clarão e muda de tela quando acabar
    _controller.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              widget.proximaTela,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Fundo branco expandindo
              Opacity(
                opacity: _brilhoAbsoluto.value,
                child: Container(color: Colors.white),
              ),
              // O Texto Épico
              Opacity(
                opacity: _brilhoAbsoluto.value > 0.5
                    ? 1.0
                    : (_brilhoAbsoluto.value * 2),
                child: Text(
                  "ETAPA 2",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                    color: _brilhoAbsoluto.value > 0.8
                        ? Colors.black
                        : Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.yellowAccent,
                        blurRadius: 20 * _brilhoAbsoluto.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
