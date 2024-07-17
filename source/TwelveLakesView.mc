import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.WatchUi as Ui;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;

class TwelveLakesView extends WatchUi.View {
    public var currentLake = null;
    public var currentPosition = null;
    public var currentTemperature = null;
    public var currentDistance = null;

    public var favouriteLake = null;
    public var favouritePosition = null;
    public var favouriteTemperature = null;

    public var favouriteTemperatureArray = null;
    public var favouriteTimeArray = null;
    

    var response_info = "init";
    var lastUpdateFav = null;
    var lastUpdateProx = null;

    function initialize(favouriteLake,favouritePosition) {
        View.initialize();

        lastUpdateFav = Storage.getValue("viewLastUpdateFav");
        lastUpdateProx = Storage.getValue("viewLastUpdateProx");
        if (lastUpdateFav != null){
            lastUpdateFav = new Time.Moment(lastUpdateFav);
        }
        if (lastUpdateProx != null){
            lastUpdateProx = new Time.Moment(lastUpdateProx);
        }
        self.favouriteLake = favouriteLake;
        self.favouritePosition = favouritePosition;
        

        var lakeFinder = new MyLakeFinder();
        self.currentPosition = lakeFinder.getPosition();
        if (currentPosition != null){
            self.currentLake = lakeFinder.getClosesLake(currentPosition);
        }

        favouriteTemperatureArray = Storage.getValue("favouriteTemperatureArray");
        favouriteTimeArray = Storage.getValue("favouriteTimeArray");

        favouriteTemperature = Storage.getValue("favouriteTemperature");
        currentTemperature = Storage.getValue("currentTemperature");
        currentDistance = Storage.getValue("currentDistance");


        makeRequest();

    }


    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        var offsetX = 0.0 * dc.getWidth();
        var offsetY = (0.5+0.3/2) * dc.getHeight();
        var spanX = 0.80 * dc.getWidth();
        var spanY = 0.3 * dc.getHeight();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        if (favouriteLake != null && favouriteTemperature != null){
            dc.drawText(dc.getWidth()/2, 0.2*dc.getHeight(), Graphics.FONT_MEDIUM, Lang.format("$1$$2$: $3$°C", [favouriteLake.substring(0,1).toUpper(), favouriteLake.substring(1, favouriteLake.length()), favouriteTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(0.5*dc.getWidth(), offsetY, Graphics.FONT_AUX1, Lang.format("$1$", ["Last 48 hours"]), Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (currentLake != null && currentTemperature != null and currentDistance != null){
            dc.drawText(dc.getWidth()/2, 0.825*dc.getHeight(), Graphics.FONT_AUX1, Lang.format("Closest lake ($1$km away)", [(currentDistance/1000.0).format("%d")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, 0.9*dc.getHeight(), Graphics.FONT_AUX1, Lang.format("$1$$2$: $3$°C", [currentLake.substring(0,1).toUpper(), currentLake.substring(1, currentLake.length()), currentTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        if (favouriteTimeArray != null){
            var widthT = spanX / (favouriteTimeArray.size());

            var hhmm = "9999";
            for (var i = 0; i < favouriteTimeArray.size(); i++) {
                hhmm = favouriteTimeArray[i].substring(8, 8+4);
                
                if (hhmm.equals( "0300")){
                    dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, "03:00", Graphics.TEXT_JUSTIFY_CENTER);
                }
                if (hhmm.equals("1500")){
                    dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, "15:00", Graphics.TEXT_JUSTIFY_CENTER);
                }
            }

        }
        if (favouriteTemperatureArray != null){


            var width = spanX / (favouriteTemperatureArray.size());
            var tempMean = mean(favouriteTemperatureArray);
            var tempMin = tempMean - span(favouriteTemperatureArray) / 2.0;
            var tempMax = tempMean + span(favouriteTemperatureArray) / 2.0;
            var tempSpan = tempMax - tempMin;
            if (tempSpan < 5.0){
                tempSpan = 5.0;
                tempMin = tempMean - tempSpan/2.0;
                tempMax = tempMean + tempSpan/2.0;
            }

            dc.drawText(offsetX+spanX+width, offsetY, Graphics.FONT_AUX1,
                Lang.format("$1$°C", [tempMin.toNumber()]), 
                Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
            );
            dc.drawText(offsetX+spanX+width, offsetY-spanY, Graphics.FONT_AUX1,
                Lang.format("$1$°C", [tempMax.toNumber()]), 
                Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT
            );
            var barHeight = 0.0;
            for (var i = 0; i < favouriteTemperatureArray.size(); i++) {
                barHeight = (favouriteTemperatureArray[i] - tempMin) / tempSpan * spanY;
                dc.setColor(getColor(favouriteTemperatureArray[i]), Graphics.COLOR_DK_GREEN);
                dc.fillRectangle(
                    offsetX+i * width, 
                    offsetY-barHeight, 
                    width+width/10, 
                    barHeight
                    );

            }
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
            dc.drawRectangle(offsetX, offsetY-spanY, spanX, spanY);

       }
    }


    public function makeRequest() as Void {
        System.println("TwelveLakesView.makeRequest");
        System.println("Executing\nRequest");;
        
        var FIVETEEN_MIN    = new Time.Duration(15*60);        
        var readyForUpdateFav = true;
        if (lastUpdateFav!=null){
            readyForUpdateFav = Time.now().greaterThan(lastUpdateFav.add(FIVETEEN_MIN));
        }
        var readyForUpdateProx = true;
        if (lastUpdateProx!=null){
            readyForUpdateProx = Time.now().greaterThan(lastUpdateProx.add(FIVETEEN_MIN));
        }
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var twoDays    = new Time.Duration(2*24*60*60);

        var beforeTwoDays = Gregorian.info(Time.now().subtract(twoDays), Time.FORMAT_SHORT);
        var dateStringStop = Lang.format(
            "$1$$2$$3$$4$$5$",
            [
                today.year.format("%04d"),
                today.month.format("%02d"),
                today.day.format("%02d"),
                today.hour.format("%02d"),
                today.min.format("%02d"),
            ]
        );
        var dateStringStart = Lang.format(
            "$1$$2$$3$$4$$5$",
            [
                beforeTwoDays.year.format("%04d"),
                beforeTwoDays.month.format("%02d"),
                beforeTwoDays.day.format("%02d"),
                beforeTwoDays.hour.format("%02d"),
                beforeTwoDays.min.format("%02d"),
            ]
        );
        
        System.println(favouriteLake);
        System.println(favouritePosition);
        if ((favouriteLake != null) && (favouritePosition != null) && readyForUpdateFav){
            var myRequestFav = Lang.format(
            "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
            [favouriteLake,dateStringStart,dateStringStop,favouritePosition[0],favouritePosition[1]]);
            System.println(myRequestFav);;
            Communications.makeWebRequest(
                myRequestFav,
                null,
                options,
                method(:onReceiveFav)
            );
        }
        System.println(currentLake);
        System.println(currentPosition);
        if ((currentLake != null) && (currentPosition != null) && readyForUpdateProx){

            var myRequestProx = Lang.format(
            "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
            [currentLake,dateStringStop,dateStringStop,currentPosition[0],currentPosition[1]]);
            System.println(myRequestProx);;
            Communications.makeWebRequest(
                myRequestProx,
                null,
                options,
                method(:onReceiveProx)
            );
        }
        }
    

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceiveFav(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("TwelveLakesView.onReceiveFav");
        System.println(responseCode);;
        if (responseCode == 200) {
            System.println(data);;
            favouriteTimeArray = data["time"]; // YYYYmmddhhmm
            Storage.setValue("favouriteTimeArray", favouriteTimeArray);
            favouriteTemperatureArray = data["temperature"]["data"];
            Storage.setValue("favouriteTemperatureArray", favouriteTemperatureArray);
            favouriteTemperature = favouriteTemperatureArray[favouriteTemperatureArray.size()-1];
            Storage.setValue("favouriteTemperature", favouriteTemperature);
            response_info = "Sucessful";
            Storage.setValue("viewLastUpdateFav", Time.now().value());

        } else {
            response_info = "Failed to load\nError: " + responseCode.toString();
            favouriteTemperature = 0;
        }
        requestUpdate();
    }
    public function onReceiveProx(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("TwelveLakesView.onReceiveProx");
        System.println(responseCode);;
        if (responseCode == 200) {
            System.println(data);;
            currentTemperature = data["temperature"]["data"][0];
            Storage.setValue("currentTemperature", currentTemperature);
            currentDistance = data["distance"]; // km?
            Storage.setValue("currentDistance", currentDistance);
            response_info = "Sucessful";
            Storage.setValue("viewLastUpdateProx", Time.now().value());

        } else {
            response_info = "Failed to load\nError: " + responseCode.toString();
            currentTemperature = 0;
        }
        requestUpdate();
    }

}
