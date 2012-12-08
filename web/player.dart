library player;
import 'gamepiece.dart';
import 'game.dart';

class Player extends GamePiece {
  int leftKey, upKey, rightKey, downKey;

  int score;
  bool dead;
  
  static const double max_speed = 0.0125;
  static const double accel_amount = 0.0015;

  Player(Game game, int color)
      : super (game, color)
  {
    dead = false;
    score = 0;
  }

  void setKeys(
      leftKey,
      upKey,
      rightKey,
      downKey
  )
  {
    this.leftKey = leftKey;
    this.upKey = upKey;
    this.rightKey = rightKey;
    this.downKey = downKey;
    
    this.game.keyStates[this.leftKey] = false;
    this.game.keyStates[this.upKey] = false;
    this.game.keyStates[this.rightKey] = false;
    this.game.keyStates[this.downKey] = false;
  }

  void move()
  {
    if (!dead)
    {
      if (this.game.keyStates[leftKey]) dx -= accel_amount;
      if (this.game.keyStates[rightKey]) dx += accel_amount;
      if (this.game.keyStates[upKey]) dy -= accel_amount;
      if (this.game.keyStates[downKey]) dy += accel_amount;

      if (dx > max_speed) dx = max_speed;
      if (dy > max_speed) dy = max_speed;
      if (dx < -max_speed) dx = -max_speed;
      if (dy < -max_speed) dy = -max_speed;
      super.move();
    }
  }
}
