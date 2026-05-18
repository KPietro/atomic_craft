import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../atom_game.dart';
import 'atomo_component.dart';

class LigacaoComponent extends Component with HasGameRef<AtomCGame> {
  final AtomoComponent atomoA;
  final AtomoComponent atomoB;
  final int tipoLigacao;

  LigacaoComponent(this.atomoA, this.atomoB, this.tipoLigacao) {
    priority = -1; // Mantém a linha atrás dos átomos
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = gameRef.isDark ? Colors.white70 : Colors.black87
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final centerA = atomoA.position;
    final centerB = atomoB.position;

    final delta = centerB - centerA;
    final distance = delta.length;

    // Se estiverem muito perto, não desenha para evitar bugs visuais
    if (distance < 50) return;

    final direction = delta.normalized();

    // AQUI ESTÁ O SEGREDO DO ESPAÇO VAZIO:
    // A linha vai começar e terminar 35 pixels longe do centro geométrico
    final p1 = centerA + (direction * 35.0);
    final p2 = centerB - (direction * 35.0);

    // Perpendicular para separar as linhas duplas e triplas
    final perpendicular = Vector2(-direction.y, direction.x) * 6.0;

    if (tipoLigacao == 1) {
      canvas.drawLine(p1.toOffset(), p2.toOffset(), paint);
    } else if (tipoLigacao == 2) {
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
