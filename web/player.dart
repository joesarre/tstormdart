library player;
import 'gamepiece.dart';
import 'game.dart';

class Player extends GamePiece {
  int leftKey, upKey, rightKey, downKey;

  int score;
  bool dead;
  
  static const double accelAmount = 1.65; // measured in distance/s^2

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

  void move(double time)
  {
    if (!dead)
    {
      double forceX = 0.0, forceY = 0.0;
      if (this.game.keyStates[leftKey]) forceX = -accelAmount;
      if (this.game.keyStates[rightKey]) forceX = accelAmount;
      if (this.game.keyStates[upKey]) forceY = -accelAmount;
      if (this.game.keyStates[downKey]) forceY = accelAmount;
      applyForce(forceX, forceY, time - lastMovedTime);
      if (dx > GamePiece.maxSpeed) dx = GamePiece.maxSpeed;
      if (dy > GamePiece.maxSpeed) dy = GamePiece.maxSpeed;
      if (dx < -GamePiece.maxSpeed) dx = -GamePiece.maxSpeed;
      if (dy < -GamePiece.maxSpeed) dy = -GamePiece.maxSpeed;
      super.move(time);
    }
  }
  
  void kill()
  {
    dead = true;
    elem.remove();
  }
  
  void incrementScore()
  {
    score += 1;
  }
}
