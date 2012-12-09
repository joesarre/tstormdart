library gamepiece;
import "dart:html";
import "game.dart";
import "graphics.dart";
import "dart:math";

class GamePiece {
  ImageElement elem;
  double x, y;
  double dx, dy; // measured in distance per second
  
  double lastDrawnTime = 0.0;
  double lastDrawnX = 0.0;
  double lastDrawnY = 0.0;
  
  double lastMovedTime = 0.0;
  
  int color;
  Game game;
  bool moved = false;
  static const radius = 0.00625; // measured in distance units (screen percent)
  
  static const double maxSpeed = 0.42; // measured in distance/s

  GamePiece(Game game, int color) {
    this.game = game; 
    this.color = color;
    
    elem = new ImageElement();
    elem.src = image(color);
    this.game.root.nodes.add(elem);
    makeAbsolute(elem);
    setElementSize(elem, radius, radius);
    this.x = this.y = this.dx = this.dy = 0.0;
  }
  
  void applyForce(double distancePerSecondSqX, double distancePerSecondSqY, milliseconds) {
    dx += distancePerSecondSqX * milliseconds / 1000.0;
    dy += distancePerSecondSqY * milliseconds / 1000.0;
  }
  
  void applyForceMultiplier(double percentPerSecond, double milliseconds) {
    dx *= pow(percentPerSecond, milliseconds / 1000.0);
    dy *= pow(percentPerSecond, milliseconds / 1000.0);
  }
  
  void draw(time) {
    double calcLDX, calcLDY, calcLDT;
    if (moved) {
      calcLDX = x;
      calcLDY = y;
      calcLDT = lastMovedTime;
    }
    else{
      calcLDX = lastDrawnX;
      calcLDY = lastDrawnY;
      calcLDT = lastDrawnTime;
    }
    double drawX = calcLDX + (dx * (time - calcLDT) / 1000.0);
    double drawY = calcLDY + (dy * (time - calcLDT) / 1000.0);
    setElementPosition(elem, drawX, drawY);
    
    /*print("drawn ${drawX}, ${drawY} at ${time}");
    print("animation velocity ${(drawX - lastDrawnX) * 1000.0 / (time - lastDrawnTime)},${(drawY - lastDrawnY) * 1000.0 / (time - lastDrawnTime)} between ${lastDrawnTime} and ${time}");
    print("object velocity ${dx}, ${dy}");*/
    
    /*if ((drawX - lastDrawnX) * 1000.0 / (time - lastDrawnTime) < maxSpeed * 0.99 || (drawY - lastDrawnY) * 1000.0 / (time - lastDrawnTime) < maxSpeed * 0.99) {
      throw new Exception("animation faster than max speed");
    }*/
    
    lastDrawnTime = time;
    lastDrawnX = drawX;
    lastDrawnY = drawY;
  }
  
  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
    lastDrawnX = x;
    lastDrawnY = y;
  }
  
  void setColor(int color) {
    this.color = color;
  }
  
  void move(double time)
  {
    double lastX = x;
    double lastY = y;
    x += dx * (time - lastMovedTime) / 1000.0;
    y += dy * (time - lastMovedTime) / 1000.0;
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
    if (y < 0.0) y = 1.0;
    /*print("moved at ${time} to ${x},${y}");
    print("movement velocity ${(x - lastX) * 1000.0 / (time - lastMovedTime)},${(y - lastY) * 1000.0 / (time - lastMovedTime)} between ${lastMovedTime} and ${time}");
    print("object velocity ${dx}, ${dy}");*/
    
    lastMovedTime = time;
    
    moved = true;
  }
}
