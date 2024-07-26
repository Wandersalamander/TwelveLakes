import Toybox.Graphics;
import Toybox.Lang;

(:glance)
function getColor(temperature as Float?) as Lang.Number or Graphics.ColorValue {
  var color = Graphics.COLOR_DK_GRAY;
  if (temperature != null) {
    if (temperature < 10) {
      color = Graphics.COLOR_DK_BLUE;
    }
    if (temperature >= 10 && temperature < 15) {
      color = Graphics.COLOR_BLUE;
    }
    if (temperature >= 15 && temperature < 18) {
      color = 0x00ffff;
    }
    if (temperature >= 18 && temperature < 21) {
      color = Graphics.COLOR_GREEN;
    }
    if (temperature >= 21 && temperature < 24) {
      color = Graphics.COLOR_YELLOW;
    }
    if (temperature >= 24) {
      color = Graphics.COLOR_ORANGE;
    }
  }
  return color;
}

(:glance)
function getColorPos(temperature as Float?) as Float {
  var pos = 0.0;

  // see getColor
  // interval width = 3;
  // min = 10, max = 24
  // so use 10-3; 24+3 as limits
  if (temperature != null) {
    pos = (temperature - 7.0) / 20.0;

    // handle values far out of bounds
    if (pos < 0.0) {
      pos = 0.0;
    }
    if (pos > 1.0) {
      pos = 1.0;
    }
  }
  return pos;
}

(:glance)
function getColorByIdx(idx as Number) as Lang.Number or Graphics.ColorValue {
  var color = Graphics.COLOR_DK_GRAY;
  if (idx == 0) {
    color = getColor(9.0);
  }
  if (idx == 1) {
    color = getColor(10.0);
  }
  if (idx == 2) {
    color = getColor(15.0);
  }
  if (idx == 3) {
    color = getColor(18.0);
  }
  if (idx == 4) {
    color = getColor(21.0);
  }
  if (idx == 5) {
    color = getColor(24.0);
  }
  return color;
}
