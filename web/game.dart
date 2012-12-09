library game;
import 'dart:html';
import 'gamepiece.dart';
import 'player.dart';
import 'killer.dart';
import 'timer.dart';
import 'graphics.dart';

/////////////////////////////////////////////
//constants
/////////////////////////////////////////////
const int maxKillers = 50;
const int killerPeriod = 60;

// TODO: should this live here?
void makeAbsolute(Element elem) {
  elem.style.position = 'absolute';
}

void setElementPosition(Element elem, double x, double y) {
  x *= 100.0;
  y *= 100.0;
  elem.style.left = "${x}%";
  elem.style.top = "${y}%";
}

void setElementSize(Element elem, double x, double y) {
  x *= 100.0;
  y *= 100.0;
  elem.style.width = "${x}%";
  elem.style.height = "${y}%";
}

const int KEY_a = 65;
const int KEY_w = 87;
const int KEY_d = 68;
const int KEY_s = 83;

const int KEY_j = 74;
const int KEY_i = 73;
const int KEY_l = 76;
const int KEY_k = 75;

const int KEY_LEFT = 37;
const int KEY_UP = 38;
const int KEY_RIGHT = 39;
const int KEY_DOWN = 40;

const int KEY_KP4 = 100;
const int KEY_KP8 = 104;
const int KEY_KP6 = 102;
const int KEY_KP5 = 101;

const int KEY_ENTER = 13;

class AudioControl {
  double fadeStartTime;
  static const double fadeLength = 2000.0;
  bool fading = false;
  AudioElement elem;
  
  AudioControl() {
    elem = document.query("audio");
  }
  
  void playAudio() {
    elem.play();
  }
  
  void stopAudio(double time) {
    if (!fading) {
      fading = true;
      fadeStartTime = time;
    }
  }
  
  void frame(double time) {
    if (fading) {
      var volume = (fadeLength > (time - fadeStartTime)) ? (1.0 - (1.0 * (time - fadeStartTime) / fadeLength)) : 0.0;
      elem.volume = volume;
    }
  }
}

class Game {
  Map<int, bool> keyStates;

  Element root;
  List<GamePiece> gamePieces;
  List<Player> players;
  List<Killer> killers;
  Timer killerTimer;
  AudioControl audioControl = new AudioControl();
  
  Game() {
    root = document.query("div#game");
    print("initialising game");
    
    window.on.keyDown.add(keyDown);
    window.on.keyUp.add(keyUp);

    var gameDiv = query("div#game");
  
    players = new List<Player>();
    
    killers = new List<Killer>();
    
    keyStates = new Map<int, bool>();
    
    //player 1
    players.add(new Player(this, 0));
    players[0].setKeys(KEY_LEFT,KEY_UP,KEY_RIGHT,KEY_DOWN);
    players[0].setPosition(0.49875,0.49875);

    /*
    //player 2
    players.add(new Player(this, 1));
    players[1].setKeys(KEY_j,KEY_i,KEY_l,KEY_k);
    players[1].setPosition(0.49875,0.5125);

    //player 3
    players.add(new Player(this, 2));
    players[2].setKeys(KEY_a,KEY_w,KEY_d,KEY_s);
    players[2].setPosition(0.5125,0.5125);

    //player 4
    players.add(new Player(this, 3));
    players[3].setKeys(KEY_KP4,KEY_KP8,KEY_KP6,KEY_KP5);
    players[3].setPosition(0.5125,0.49875);
    */
    
    //killer timer
    killerTimer = new Timer(killerPeriod);
    killerTimer.enable();
    
    audioControl.playAudio();
  }
  
  void keyDown(KeyboardEvent event) {
    //print(event.keyCode);
    keyStates[event.keyCode] = true;
  }

  void keyUp(KeyboardEvent event) {
    keyStates[event.keyCode] = false;
  }
  
  void move(double time)
  {
    for (int i = 0; i < killers.length; i ++)
    {
      killers[i].move(time);
    }
    for (int i = 0; i < players.length; i ++)
    {
      players[i].move(time);
    }
  }

  void draw(time)
  {
    //draw players
    for (int i = 0; i < players.length; i ++)
    {
      players[i].draw(time);
    }


    //draw killers
    for (int i = 0; i < killers.length; i ++)
    {
      killers[i].draw(time);
    }
    
    //draw scores
    for (int i = 0; i < players.length; i++)
    {
      var color;
      //Draw score
      if (players[i].dead)
        color = players[i].color;
      else
        color = 6;
      SpanElement s = document.query("div#player${i}_score>span.score");
      s.text = players[i].score.toString();
      s.style.color = "#".concat(COLORS[color]);
    }
  }

  void spawnKiller()
  {
    killerTimer.tick();

    if (killerTimer.elapsed())
    {
      if (killers.length > maxKillers)
      {
        killerTimer.disable();
      }
      else
      {
        killers.add(new Killer(this));
      };
    }
  }
  
  void collisions(double time)
  {
    for (int i = 0; i < killers.length; i ++)
    {
      double killer_x = killers[i].x; //functionally does not help, but might optimise
      double killer_y = killers[i].y; //functionally does not help, but might optimise
      for (int j = 0; j < players.length; j ++)
      {
        if (!players[j].dead)
        {
          double x_dist = players[j].x - killer_x;
          if (x_dist > GamePiece.standardRadius) //functionally does not help, but might optimise
            continue;
          double y_dist = players[j].y - killer_y;
          if (y_dist > GamePiece.standardRadius) //functionally does not help, but might optimise
            continue;
          double sq_dist = (x_dist * x_dist) + (y_dist * y_dist);
          if (sq_dist <= 4 * GamePiece.standardRadius * GamePiece.standardRadius)
          {
            print ("player ".concat(j.toString()).concat(" has died with score ").concat(players[j].score.toString()).concat(" at position (").concat(players[j].x.toString()).concat(",").concat(players[j].y.toString()).concat(")"));
            players[j].kill(killers[i], time);
          }
        }
      }
    }
  }
  
  void gameFrame(double time) {
    move(time); //move all the pieces

    spawnKiller();

    //increment scores
    for (int i = 0; i < players.length; i ++)
    {
      if (!players[i].dead)
      {
        players[i].incrementScore(time);
      }
    }
    
    collisions(time);
    
    bool allDead = true;
    for (int i = 0; i < players.length; i++)
    {
      allDead = allDead && players[i].dead;
    }

    if (allDead)
    {
      audioControl.stopAudio(time);
    }
    
    audioControl.frame(time);
  }
  
  void animate(time) {
    //print(time);
    gameFrame(time);
    draw(time);
    window.requestAnimationFrame(animate);
  }
}
