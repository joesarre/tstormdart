library graphics;

const List<String> COLORS = const [
                                        "00ff00", "00ffff",
                                        "ff00ff", "ffff00",
                                        "c9c9c9", "ff0000",
                                        "b6b4b5"
];

String image(int id, [int frame]) {
  if (frame != null) {
    return "images/ball-${COLORS[id]}-spr-${frame}.png";
  }
  else {   
    return "images/ball-${COLORS[id]}-spr.png";
  }
}

