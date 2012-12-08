library game;
import 'dart:html';
import 'gamepiece.dart';
import 'player.dart';
import 'killer.dart';
import 'timer.dart';

/////////////////////////////////////////////
//constants
/////////////////////////////////////////////
const int maxKillers = 50;
const int killerPeriod = 60;


class Scores {
  List<int> scores;
}



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


class Game {
  Map<int, bool> keyStates;

  Element root;
  List<GamePiece> gamePieces;
  List<Player> players;
  List<Killer> killers;
  Timer killerTimer;
  
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
    players[0].setKeys(KEY_a,KEY_w,KEY_d,KEY_s);
    players[0].setPosition(0.49875,0.49875);

    //player 2
    players.add(new Player(this, 1));
    players[1].setKeys(KEY_j,KEY_i,KEY_l,KEY_k);
    players[1].setPosition(0.49875,0.5125);

    //player 3
    players.add(new Player(this, 2));
    players[2].setKeys(KEY_LEFT,KEY_UP,KEY_RIGHT,KEY_DOWN);
    players[2].setPosition(0.5125,0.5125);

    //player 4
    players.add(new Player(this, 3));
    players[3].setKeys(KEY_KP4,KEY_KP8,KEY_KP6,KEY_KP5);
    players[3].setPosition(0.5125,0.49875);

    //killer timer
    killerTimer = new Timer(killerPeriod);
    killerTimer.enable();
  }
  
  void keyDown(KeyboardEvent event) {
    keyStates[event.keyCode] = true;
  }

  void keyUp(KeyboardEvent event) {
    keyStates[event.keyCode] = false;
  }
  
  void move()
  {
    for (int i = 0; i < killers.length; i ++)
    {
      killers[i].move();
    }
    for (int i = 0; i < players.length; i ++)
    {
      players[i].move();
    }
  }

  void draw()
  {
    //draw players
    for (int i = 0; i < players.length; i ++)
    {
      if (!players[i].dead)
        players[i].draw();
    }

      /*
    //draw killers
    for (int i = 0; i < killers.size(); i ++)
    {
      killers[i].draw();
    }

    //game border
    border(view_port,color(6));

    //draw scores
    for (int i = 0; i < players.size(); i++)
    {
      Graphics::Color color;

      //Draw score
      if (players[i].is_dead())
        color = players[i].get_color();
      else
        color = Graphics::color(6);
      draw_number(scores_view_port,0.5,float(i+1)/float(players.size()+1),players[i].get_score(),color);
    }

    //scores border
    border(scores_view_port,color(6));

    SDL_Flip(screen_surface);

    //redraw background
    clear();*/
  }


  
  void gameFrame(highResTimer) {
    move(); //move all the pieces

    /*spawn_killer();

    //increment scores
    for (int i = 0; i < players.size(); i ++)
    {
      if (!players[i].is_dead())
      {
        players[i].increment_score();
      }
    }

    collisions(); //detect collisions
    */
    
    draw();
  
    /*
    all_dead = true;
    for (int i = 0; i < players.size(); i++)
    {
      all_dead = all_dead && players[i].is_dead();
    }

    if (all_dead)
    {
      Scores scores;
      for (int i = 0; i < players.size(); i++)
        scores.scores[i]=players[i].get_score();   

      Sound::stop_soundtrack();
      return scores; 
    }

    SDL_framerateDelay(&fps_manager);*/
    window.requestAnimationFrame(this.gameFrame);
  }
}
