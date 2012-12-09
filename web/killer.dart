library killer;
import 'gamepiece.dart';
import 'tstormdart.dart';
import 'game.dart';
import 'graphics.dart';
import 'dart:math';

class Killer extends GamePiece{
  
  static Random rng = new Random();
  
  static const double randomAmount = 1.40; // measured in distance/s^2 - random variation is between -0.5*randomAmount and 0.5*randomAmount
  
  static const double pounceAmount = 5.0; // measured in percent/s
  static const double slowAmount = 0.2; // measured in percent/s
  
  int frame = 0; // 0 - 6
  int previousFrame = 0; // 0 - 6
  
  Killer(Game game) 
      : super(game, 5)
  { 
    dx = dy = 0.0;
  }

  void move(double time)
  {
    double frameTime = time - lastMovedTime;
    //max_cos is the cos of the angle between the killer's
    //line of movement and the most in-view player
    double max_cos = -1.0;
    double closestPlayer = 1.0;
    if ((dx != 0) && (dy != 0))
    {
      for (int i = 0; i < game.players.length; i++)
      {
        double dispx = game.players[i].x - x;
        double dispy = game.players[i].y - y;
        if ((dispx != 0) && (dispy != 0) && (!game.players[i].dead || game.players[i].dying))
        {
          closestPlayer = min(max(dispx*dispx, dispy*dispy), closestPlayer);
          //cos is the cos of the angle between the killer's
          //line of movement and the player
          double cos = 
              ((dx * dispx) + (dy * dispy)) / 
              sqrt(
                  (dx * dx + dy * dy) * 
                  (dispx * dispx + dispy * dispy)
              );
          if (cos > max_cos) max_cos = cos;
        }
      }
    }
    
    frame = 6 - max(min((closestPlayer * 100.0).toInt(), 6), 0);
    if (frame > previousFrame + 1) {
      frame = previousFrame + 1;
    }    
    if (frame < previousFrame - 1) {
      frame = previousFrame - 1;
    }
    previousFrame = frame;
    
    if (max_cos >= 0.85)
    {
      // facing a player - POUNCE!
      applyForceMultiplier(pounceAmount, frameTime);
    }
    else
    {
      // not facing a player - slow down
      applyForceMultiplier(slowAmount, frameTime);
    }
    double forceX = (rng.nextDouble() - 0.5) * randomAmount;
    double forceY = (rng.nextDouble() - 0.5) * randomAmount;
    applyForce(forceX, forceY, frameTime);

    if (dx > GamePiece.maxSpeed) dx = GamePiece.maxSpeed;
    if (dy > GamePiece.maxSpeed) dy = GamePiece.maxSpeed;
    if (dx < -GamePiece.maxSpeed) dx = -GamePiece.maxSpeed;
    if (dy < -GamePiece.maxSpeed) dy = -GamePiece.maxSpeed;
    super.move(time);
  }

  void draw(double time){
    elem.src = image(color, frame);
    super.draw(time);
  }
}
