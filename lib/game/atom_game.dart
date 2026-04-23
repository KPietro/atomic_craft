import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/elementos_data.dart';
import 'components/atomo_component.dart';
import 'components/lixeira_component.dart';

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
