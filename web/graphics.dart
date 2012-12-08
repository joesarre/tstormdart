class ViewPort
{
    int left, top, right, bottom;
} //right and bottom are in the viewport, so right - left = width - 1.
// a single pixel viewport will have right = left, top = bottom
int screen_x(ViewPort vp, double x) {
  return (vp.left + (x * (vp.right - vp.left))).toInt();
}
int screen_y(ViewPort vp, double y) {
  return (vp.top + (y * (vp.bottom - vp.top))).toInt();
}

//Scaling here isn't very smart - it scales in all directions based
// on the correct left-right scaling
double screen_scale(ViewPort vp, double r) {
  return r * (vp.right - vp.left); 
}

const List<String> PNGS = const [
                                        "images/ball-d9d9d9.png", "images/ball-009a49.png",
                                        "images/ball-13acfa.png", "images/ball-265897.png",
                                        "images/ball-b6b4b5.png", "images/ball-c0000b.png",
                                        "images/ball-c9c9c9.png"
];

String color(int id) {
  return PNGS[id];
}

