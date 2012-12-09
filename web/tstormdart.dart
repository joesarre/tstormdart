library tstormdart;
import 'dart:html';
import 'game.dart';
import 'gamepiece.dart';

void main() {
  Game g = new Game();
  document.query("#loading").style.display = "none";
  window.requestAnimationFrame(g.animate);
}