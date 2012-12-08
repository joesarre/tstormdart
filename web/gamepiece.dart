library gamepiece;
import "dart:html";
import "game.dart";

class GamePiece {
  ImageElement elem;
  double x, y;
  double dx, dy;
  int color;
  Game game;
  static const radius = 0.00625;

  static const List<String> PNGS = const [
      "images/ball-d9d9d9.png", "images/ball-009a49.png",
      "images/ball-13acfa.png", "images/ball-265897.png",
      "images/ball-b6b4b5.png", "images/ball-c0000b.png",
      "images/ball-c9c9c9.png"
  ];
  
  GamePiece(Game game, int color) {
    this.game = game; 
    this.color = color;
    print(color);
    
    elem = new ImageElement();
    elem.src = GamePiece.PNGS[color];
    this.game.root.nodes.add(elem);
    makeAbsolute(elem);
    setElementSize(elem, radius, radius);
    this.x = this.y = this.dx = this.dy = 0.0;
    draw();
  }
  
  void draw() {
    setElementPosition(elem, x, y);
  }
  
  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }
  
  void setColor(int color) {
    this.color = color;
  }
  
  void move()
  {
    x += dx;
    y += dy;
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
    if (y < 0.0) y = 1.0;
  }
}
