library options;
import 'dart:html';

void muteClicked(MouseEvent e) {
  AudioElement a = document.querySelector("#soundtrack");
  CheckboxInputElement c = document.querySelector("#mute");
  if (a.muted != c.checked) {
    muteSet(c.checked);
  }
}

void muteToggle() {
  AudioElement a = document.querySelector("#soundtrack");
  muteSet(!a.muted);  
}

void muteSet(bool mute) {
  AudioElement a = document.querySelector("#soundtrack");
  CheckboxInputElement c = document.querySelector("#mute");
  a.muted = c.checked = mute;
  if (mute) {
    if(!window.location.hash.contains("mute")) {
      window.location.hash += "mute";
    }
  }
  else {
    if(window.location.hash.contains("mute")) {
      window.location.hash = window.location.hash.replaceFirst("mute", "");
    }
  }
}

void restart ([MouseEvent e]) {
  // TODO: more elegant
  window.location.href = window.location.href;
}

void initOptions() {
  AudioElement a = document.querySelector("#soundtrack");
  CheckboxInputElement c = document.querySelector("#mute");
  c.checked = a.muted = window.location.hash.contains("mute");
  c.onClick.listen(muteClicked);
  
  ButtonElement b = document.querySelector("#restart");
  b.onClick.listen(restart);
}