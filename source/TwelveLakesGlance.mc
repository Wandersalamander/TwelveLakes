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
    var response_info = "init";
    var lake = "init";
    var temperature = null;
    var lastUpdate = null;
;
	
    function initialize(lakeName, position) {
      GlanceView.initialize();
      lake = lakeName;
      temperature = Storage.getValue("glanceTemperature");
      lastUpdate = Storage.getValue("glanceLastUpdate");
      if (lastUpdate != null){
        lastUpdate = new Time.Moment(lastUpdate);
      }
      makeRequest(lakeName, position);
      

    }

    function onUpdate(dc) {
      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
      if (lake != null){
        dc.drawText(0, 0.2*dc.getHeight() , Graphics.FONT_GLANCE,
          Lang.format("$1$$2$", [lake.substring(0,1).toUpper(), lake.substring(1, lake.length())]),
          Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
        );
      }
      if (temperature != null){
        dc.drawText(0, 0.8*dc.getHeight(), Graphics.FONT_GLANCE, 
          Lang.format("$1$°C", [temperature.format("%.1f")]),
          Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
      );
      }
      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_DK_GREEN);
      dc.drawLine(0, dc.getHeight()/2, dc.getWidth(), dc.getHeight()/2);

      if (temperature != null){
        var height = dc.getHeight() * 0.1;
        var width = (temperature + 10) / 60 * dc.getWidth();
        dc.setColor(getColor(temperature), Graphics.COLOR_DK_GREEN);
        dc.fillRectangle(0, dc.getHeight()/2.0-height/2.0, width, height);
      }
    }

    //! Make the web request
    public function makeRequest(lakeName, position) as Void {
        System.println("Executing\nRequest");
        if ((lakeName != null) && (position != null)){
          var readyForUpdate = true;
          if (lastUpdate!=null){
              var fivteenMin    = new Time.Duration(15*60);
              readyForUpdate = Time.now().greaterThan(lastUpdate.add(fivteenMin));
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
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$$2$$3$$4$$5$",
            [
                today.year.format("%04d"),
                today.month.format("%02d"),
                today.day.format("%02d"),
                today.hour.format("%02d"),
                today.min.format("%02d"),
            ]
        );
        var myRequest = Lang.format(
          "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
           [lakeName,dateString,dateString,position[0],position[1]]);
        System.println(myRequest);
        Communications.makeWebRequest(
            myRequest,
            null,
            options,
            method(:onReceive)
        );
        }
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println(responseCode);
        if (responseCode == 200) {
            System.println(data);
            temperature = data["temperature"]["data"][0];
            Storage.setValue("glanceTemperature", temperature);
            Storage.setValue("glanceLastUpdate", Time.now().value());

            response_info = "Sucessful";
        } else {
            response_info = "Failed to load\nError: " + responseCode.toString();
        }
        requestUpdate();

    }
}