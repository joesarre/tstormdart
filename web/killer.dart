library killer;
import 'gamepiece.dart';
import 'tstormdart.dart';
import 'game.dart';
import 'dart:math';

class Killer extends GamePiece{
  static Random rng = new Random();
  Killer(Game game) 
      : super(game, 5)
  { 
    dx = dy = 0.0;
  }

  void move()
  {
    //max_cos is the cos of the angle between the killer's
    //line of movement and the most in-view player
    double max_cos = -1.0;
    if ((dx != 0) && (dy != 0))
    {
      for (int i = 0; i < game.players.length; i++)
      {
        double dispx = game.players[i].x - x;
        double dispy = game.players[i].y - y;
        if ((dispx != 0) && (dispy != 0) && !game.players[i].dead)
        {
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
    if (max_cos >= 0.85)
    {
      dx *= 1.05;
      dy *= 1.05;
    }
    else
    {
      dx *= 0.95;
      dy *= 0.95;
    }
    dx += (rng.nextDouble() - 0.5) * 0.00125;
    dy += (rng.nextDouble() - 0.5) * 0.00125;

    if (dx > 0.0125) dx = 0.0125;
    if (dy > 0.0125) dy = 0.0125;
    if (dx < -0.0125) dx = -0.0125;
    if (dy < -0.0125) dy = -0.0125;
    super.move();
  }
  
}
