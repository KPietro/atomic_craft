import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../atom_game.dart';
import '../../data/elementos_data.dart'; // Importante para ler as regras químicas!

// --- COMPONENTE DO ÁTOMO ---
class AtomoComponent extends PositionComponent
    with DragCallbacks, TapCallbacks, HasGameRef<AtomCGame> {
  final Map<String, dynamic> dados;
  final double s = 100.0;
  bool selecionado = false;

  AtomoComponent(this.dados)
    : super(size: Vector2.all(100.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: s / 4, position: size / 2, anchor: Anchor.center));
  }

  @override
  void render(Canvas canvas) {
    final bool dark = gameRef.isDark;
    final Color textColor = dark ? Colors.white : Colors.black;

    // --- VISUAL ETAPA 1 (Caixa Quadrada) ---
    if (gameRef.etapaAtual == 1) {
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

      TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ).render(
        canvas,
        "${dados['numero'] ?? ''}",
        Vector2(6, 4),
        anchor: Anchor.topLeft,
      );

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
    // --- VISUAL ETAPA 2 (Mini Bolha) ---
    else {
      final double raioBolha = 25.0;
      final centro = Vector2(size.x / 2, size.y / 2);

      // --- MÁGICA DA VALÊNCIA (ATUALIZADA COM AS EXCEÇÕES) ---
      int ligacoesFeitas = gameRef.contarLigacoesAtuais(this);
      bool condicaoCumprida = true;

      var regra = regrasQuimicas[dados['numero']];
      if (regra != null) {
        List<int> estaveis = regra['estaveis'] as List<int>;
        // Só fica satisfeito (cinza/laranja) se o número de ligações atuais estiver na lista de estáveis
        condicaoCumprida = estaveis.contains(ligacoesFeitas);
      } else {
        // Elementos sem regras estritas (metais, etc) nunca ficam vermelhos para não bugar
        condicaoCumprida = true;
      }

      final paintBgBolha = Paint()
        ..color = condicaoCumprida
            ? (dark
                  ? const Color.fromARGB(255, 60, 60, 60)
                  : const Color.fromARGB(255, 240, 240, 240))
            : Colors.redAccent.withOpacity(dark ? 0.5 : 0.3);

      final paintBorderBolha = Paint()
        ..color = condicaoCumprida
            ? (dark ? Colors.orangeAccent : Colors.blueGrey)
            : Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(centro.toOffset(), raioBolha, paintBgBolha);
      canvas.drawCircle(centro.toOffset(), raioBolha, paintBorderBolha);

      TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ).render(canvas, dados['simbolo'], centro, anchor: Anchor.center);
    }

    // --- DESENHA A SELEÇÃO VERMELHA/VERDE DA FERRAMENTA ---
    if (selecionado) {
      final paintSelecao = Paint()
        ..color = gameRef.modoFerramenta == 1
            ? Colors.redAccent
            : Colors.greenAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;

      if (gameRef.etapaAtual == 1) {
        canvas.drawRect(
          Rect.fromLTWH(-2, -2, size.x + 4, size.y + 4),
          paintSelecao,
        );
      } else {
        canvas.drawCircle(
          Vector2(size.x / 2, size.y / 2).toOffset(),
          28.0,
          paintSelecao,
        );
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (gameRef.modoFerramenta != 0) {
      selecionado = !selecionado;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (gameRef.modoFerramenta == 0) position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (gameRef.modoFerramenta == 0) gameRef.verificarInteracao(this);
  }

  bool collidingWith(AtomoComponent outro) {
    return toAbsoluteRect().overlaps(outro.toAbsoluteRect());
  }
}
