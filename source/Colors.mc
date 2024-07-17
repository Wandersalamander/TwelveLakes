import Toybox.Graphics;
import Toybox.Lang;

(:glance)
function getColor(temperature as Float or Null) as Lang.Number or Graphics.ColorValue{
    var color = Graphics.COLOR_DK_BLUE;
    if (temperature != null){
        if (temperature < 10){
            color = Graphics.COLOR_DK_BLUE;
        }
        if (temperature >= 10 && temperature < 15){
            color = Graphics.COLOR_BLUE;
        }
        if (temperature >= 15 && temperature < 18){
            color = 0x00FFFF;
        }
        if (temperature >= 18 && temperature < 21){
            color = Graphics.COLOR_GREEN;
        }
        if (temperature >= 21 && temperature < 24){
            color = Graphics.COLOR_YELLOW;
        }
        if (temperature >= 24){
            color = Graphics.COLOR_ORANGE;
        }
    }
    return color;
}