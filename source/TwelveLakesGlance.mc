using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;

(:glance)
class WidgetGlanceView extends Ui.GlanceView {
    var response_info as String = "init";
    public var favouriteLake as String or Null= null;
    public var favouritePosition as Array<Double> or Null= null;
    var temperature as Float or Null = null;
    var lastUpdate as Time.Moment or Null = null;

    function initialize() {
        GlanceView.initialize();
        updateFavourites();
        temperature = getFavouriteTemperature();
        lastUpdate = getGlanceLastUpdate();
        if ((favouriteLake != null) && (favouritePosition != null)){
            makeRequest(favouriteLake, favouritePosition);
        }
    }

    function updateFavourites() as Void{
        var pos = getFavouritePosition();
        var name = getFavouriteLake();
        if (pos != null && name != null){
            self.favouritePosition = [pos[0].toDouble(), pos[1].toDouble()];
            self.favouriteLake = name;
        }
        else{
            // todo toast 
            self.favouriteLake = "geneva";
            self.favouritePosition = [46.210417.toDouble(), 6.154484.toDouble()];
        }
    }


    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            0,
            0.2*dc.getHeight(),
            Graphics.FONT_GLANCE,
            Lang.format("LAKE TEMPERATURE", []),
            Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
        );
        drawColorBar(dc);
        if ((temperature != null) && (favouriteLake != null)){
            dc.drawText(
                0,
                0.8*dc.getHeight(), 
                Graphics.FONT_GLANCE, 
                Lang.format("$1$$2$ $3$°C", [favouriteLake.substring(0, 1).toUpper(), favouriteLake.substring(1, favouriteLake.length()), temperature.format("%.1f")]),
                Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
            );
        }
    }

    //! Make the web request
    public function makeRequest(lakeName as String, position as [Double,Double] or Array<Double>) as Void {
        System.println("Executing\nRequest");
        if ((lakeName != null) && (position != null)){
            var readyForUpdate = true;
        if (lastUpdate != null){
            var skipUpdateBelowSeconds = new Time.Duration(60 * 60); // 60 min
            readyForUpdate = Time.now().greaterThan(lastUpdate.add(skipUpdateBelowSeconds));
        }
        if (readyForUpdate == false){
            return;
        }
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };
        var today = Time.now();

        var myRequest = alplakesApiString(lakeName, today, today, position);
        System.println(myRequest);
        Communications.makeWebRequest(
            myRequest,
            null,
            options,
            method(:onReceive)
        );
        }
    }

    function drawColorBar(dc as Gfx.Dc) as Void{
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var totalWidth = dc.getWidth();
        var barWidth = totalWidth / 6.0;
        var delta = 1.0;
        var height = dc.getHeight() * 0.1;
        var heightHighlight = dc.getHeight() * 0.15;
        var heightMarker = dc.getHeight() * 0.25;
        var widthMarker = barWidth / 8.0;
        var center = dc.getHeight() / 2.0;

        var colorTmp;
        // draw in background
        for (var i = 0; i < 6; i++) {
            colorTmp = getColorByIdx(i);
            dc.setColor(colorTmp, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(i*barWidth+(delta), dc.getHeight()/2.0-height/2.0, barWidth-(2*delta), height);
        }

        if (temperature != null){

            var colorHighlight = getColor(temperature);
            // draw in foreground
            for (var i = 0; i < 6; i++) {
                colorTmp = getColorByIdx(i);
                dc.setColor(colorTmp, Graphics.COLOR_TRANSPARENT);
                if (colorTmp == colorHighlight){
                    dc.fillRectangle(
                        i * barWidth + (delta),
                        dc.getHeight() / 2.0 - heightHighlight / 2.0,
                        barWidth - (2 * delta),
                        heightHighlight
                    );
                }
            }
        // draw temperature marker
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle((getColorPos(temperature)*dc.getWidth())-(delta), center-(heightMarker/2.0), (widthMarker+2*delta), heightMarker);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(getColorPos(temperature)*dc.getWidth(), center-heightMarker/2, widthMarker, heightMarker);
        }
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println(responseCode);
        if (responseCode == 200) {
            System.println(data);
            if (data instanceof Dictionary){
                var helper = processReceivedData(data); // lake, favouriteTimeArray, favouriteTemperatureArray
                var favouriteTemperatureArray = helper[2];
                if (favouriteTemperatureArray != null){
                    temperature = favouriteTemperatureArray[0];
                }else{
                    temperature = null;
                }
                Storage.setValue("favouriteTemperature", temperature);
                Storage.setValue("glanceLastUpdate", Time.now().value());
                }
            response_info = "Sucessful";
        } else {
            response_info = "Failed to load\nError: " + responseCode.toString();
        }
        requestUpdate();
    }
}