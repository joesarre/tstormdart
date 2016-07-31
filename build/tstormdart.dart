library tstormdart;
import 'dart:html';
import 'game.dart';
import 'options.dart';

void main() {
  initOptions();
  Game g = new Game();
  document.querySelector("#loading").style.display = "none";
  window.requestAnimationFrame(g.animate);
}