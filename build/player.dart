library player;
import 'gamepiece.dart';
import 'game.dart';

class Player extends GamePiece {
  int leftKey, upKey, rightKey, downKey;

  int score = 0;
  bool dead = false;
  
  static const double accelAmount = 1.65; // measured in distance/s^2
  
  // death sequence
  GamePiece killedBy;
  bool dying = false;
  double deadTime;
  static const int deathMilliseconds = 1000;
  
  Player(Game game, int color)
      : super (game, color, 1);
  
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
    
    if (dying) {
      if ((time - deadTime) > deathMilliseconds) {
        dying = false;
      }
      else {
        this.dx = this.killedBy.dx;
        this.dy = this.killedBy.dy;
        
        applyForce((this.killedBy.x - this.x) * 200.0, (this.killedBy.y - this.y) * 200.0, time - lastMovedTime);
        
        print("matching killer location: ${x}, ${y}.  dead: ${dead}");
        super.move(time);
      }
    }
  }
  
  void kill(GamePiece killer, double time)
  {
    killedBy = killer;
    deadTime = time;
    dead = true;
    dying = true;
  }
  
  void draw(double time) {
    for (var elem in elems)
    {
      if (dead && dying) {
        radius = GamePiece.standardRadius * (deathMilliseconds + deadTime - time) / deathMilliseconds;
        setElementSize(elem, 2.0 * radius, 2.0 * radius);
      }
      
      if (dead && !dying) {
        elem.style.display = "none";
      }
      
      if (!dead || dying) {
        super.draw(time);
      }
    }
  }
  
  void incrementScore(double time)
  {
    score = (time * 0.03).toInt(); // TODO: handle start delays better
  }
}
