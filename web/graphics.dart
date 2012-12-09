library graphics;

const List<String> COLORS = const [
                                        "d9d9d9", "009a49",
                                        "13acfa", "265897",
                                        "c9c9c9", "c0000b",
                                        "b6b4b5"
];

String image(int id) {
  return "images/ball-${COLORS[id]}.png";
}

