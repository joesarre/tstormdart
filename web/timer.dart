library timer;

class Timer {
  bool enabled = false;
  int max, count;
  
  Timer(max) {
    this.max = max;
  }
  
  void tick()
  {
    if (enabled)
    {
      count++;
      if (count > max) count = 0;
    }
  }

  void disable()
  {
    enabled = false;
  }

  void enable()
  {
    count = 0;
    enabled = true;
  }

  bool elapsed()
  {
    return ((count == max) && enabled);
  }
  
}
