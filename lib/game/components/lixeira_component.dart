import 'package:flame/components.dart';

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
