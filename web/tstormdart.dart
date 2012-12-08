library tstormdart;
import 'dart:html';
import 'game.dart';
import 'gamepiece.dart';

void main() {
  Game g = new Game();
  window.requestAnimationFrame(g.gameFrame);
}