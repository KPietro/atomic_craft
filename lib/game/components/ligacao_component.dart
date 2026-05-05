import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../atom_game.dart';
import 'atomo_component.dart';

class LigacaoComponent extends Component with HasGameRef<AtomCGame> {
  final AtomoComponent atomoA;
  final AtomoComponent atomoB;
  final int tipoLigacao; // 1 (Simples), 2 (Dupla) ou 3 (Tripla)

  LigacaoComponent(this.atomoA, this.atomoB, this.tipoLigacao) {
    // Colocamos prioridade -1 para a linha ser desenhada ATRÁS dos átomos
    priority = -1;
  }

  @override
  void render(Canvas canvas) {
    // Define a cor da linha baseado no modo escuro/claro do jogo
    final paint = Paint()
      ..color = gameRef.isDark ? Colors.white70 : Colors.black87
      ..strokeWidth =
          3.0 // Espessura do traço
      ..style = PaintingStyle.stroke;

    final p1 = atomoA.position;
    final p2 = atomoB.position;

    // Se for ligação SIMPLES (-)
    if (tipoLigacao == 1) {
      canvas.drawLine(p1.toOffset(), p2.toOffset(), paint);
    }
    // Se for ligação DUPLA (=) ou TRIPLA (≡)
    else {
      // Usamos um pouquinho de geometria para afastar as linhas paralelamente
      final delta = p2 - p1;
      final perpendicular = Vector2(-delta.y, delta.x).normalized() * 6.0;

      if (tipoLigacao == 2) {
        canvas.drawLine(
          (p1 + perpendicular).toOffset(),
          (p2 + perpendicular).toOffset(),
          paint,
        );
        canvas.drawLine(
          (p1 - perpendicular).toOffset(),
          (p2 - perpendicular).toOffset(),
          paint,
        );
      } else if (tipoLigacao == 3) {
        // A tripla tem a linha central e duas afastadas
        canvas.drawLine(p1.toOffset(), p2.toOffset(), paint);
        canvas.drawLine(
          (p1 + perpendicular * 1.5).toOffset(),
          (p2 + perpendicular * 1.5).toOffset(),
          paint,
        );
        canvas.drawLine(
          (p1 - perpendicular * 1.5).toOffset(),
          (p2 - perpendicular * 1.5).toOffset(),
          paint,
        );
      }
    }
  }
}
