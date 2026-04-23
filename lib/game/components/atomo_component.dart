import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../atom_game.dart';

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
