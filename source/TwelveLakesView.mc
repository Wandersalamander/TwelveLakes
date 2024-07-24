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
import Toybox.Position;

class TwelveLakesView extends WatchUi.View {

    function initialize() {
        System.println("TwelveLakesView.initialize");
        View.initialize();

        makeRequest(false, false);

    }

    function tryUpdateCurrentPosition() as Void {
        System.println("TwelveLakesView.tryUpdateCurrentPosition");
        var previousLake = getCurrentLake();
        var newPos = getPosition();
        var newLake = getClosesLake(newPos);
        if (newPos != null and newLake != null){
            setCurrentPosition(newPos);
            setCurrentLake(newLake);
            if (previousLake != null && previousLake.equals(newLake)){

            }
            else{
                makeRequestProx(true);
            }
        }
    }

    function notifyFullUpdate() as Void{
        System.println("TwelveLakesView.notifyFavUpdate");
        makeRequest(true, true);
    }


    function onLayout(dc){
        System.println("TwelveLakesView.onLayout");
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }


    // Update the view
    function onUpdate(dc as Dc) as Void {
        tryUpdateCurrentPosition();
        var currentLake  = getCurrentLake() ;
        var currentPosition  = getCurrentPosition() ;
        var currentTemperature  = getCurrentTemperature() ;
        var currentDistance  = getCurrentDistance() ;
        var favouriteLake  = getFavouriteLake() ;
        var favouritePosition  = getFavouritePosition() ;
        var favouriteTemperature  = getFavouriteTemperature() ;
        var favouriteTemperatureArray  = getFavouriteTemperatureArray() ;
        var favouriteTimeArray  = getFavouriteTimeArray() ;
        System.println(Lang.format("$1$ $2$ $3$ $4$ $5$ $6$ $7$ $8$ $9$", [
            currentLake,
            currentPosition,
            currentTemperature,
            currentDistance,
            favouriteLake,
            favouritePosition,
            favouriteTemperature,
            favouriteTemperatureArray,
            favouriteTimeArray,
        ]));
        System.println("TwelveLakesView.onUpdate");
        View.onUpdate(dc);
        var offsetX = 0.0 * dc.getWidth();
        var offsetY = (0.5+0.3/2) * dc.getHeight();
        var spanX = 0.75 * dc.getWidth();
        var spanY = 0.3 * dc.getHeight();
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        if (favouriteTemperature != null){
            dc.drawText(dc.getWidth() / 2.0, 0.1*dc.getHeight(), Graphics.FONT_MEDIUM, Lang.format("$1$°C", [favouriteTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (favouriteLake != null){
            dc.drawText(dc.getWidth() / 2.0, 0.2*dc.getHeight(), Graphics.FONT_MEDIUM, Lang.format("$1$$2$", [favouriteLake.substring(0,1).toUpper(), favouriteLake.substring(1, favouriteLake.length())]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }

        var text;
        if (currentDistance != null){
            if (currentDistance >= 1000){
                text = Lang.format("Closest lake ($1$km away)", [(currentDistance/1000.0).format("%d")]);
            }else{
                text = Lang.format("Closest lake ($1$m away)", [(currentDistance).format("%d")]);
            }
        }else{
            text = Lang.format("Closest lake", []);
        }
        dc.drawText(dc.getWidth()/2, 0.800*dc.getHeight(), Graphics.FONT_AUX1, text, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        if (currentLake != null){
            dc.drawText(dc.getWidth()/2, 0.875*dc.getHeight(), Graphics.FONT_AUX1, Lang.format("$1$$2$", [currentLake.substring(0,1).toUpper(), currentLake.substring(1, currentLake.length())]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (currentTemperature != null){
            dc.drawText(dc.getWidth()/2, 0.950*dc.getHeight(), Graphics.FONT_AUX1, Lang.format("$1$°C", [currentTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        if (favouriteTimeArray != null){
            var widthT = spanX / favouriteTimeArray.size();

            var hhmm;
            var dd;
            var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var todayString = today.day.format("%02d");
            for (var i = 0; i < (favouriteTimeArray as Array<String>).size(); i++) {
                dd = (favouriteTimeArray as Array<String>)[i].substring(6, 8) as String;
                hhmm = (favouriteTimeArray as Array<String>)[i].substring(8, 8+4) as String;
                if (hhmm.equals( "1200")){
                    if (dd.equals(todayString)){
                        dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, Lang.format("$1$", ["Today"]), Graphics.TEXT_JUSTIFY_CENTER);
                    }else{
                        if ((i < (favouriteTimeArray as Array<String>).size()-1)){
                            dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, Lang.format("$1$.", [dd]), Graphics.TEXT_JUSTIFY_CENTER);
                        }
                    }
                }
                if (hhmm.equals("0000")){
                    dc.drawLine(offsetX+i * widthT, offsetY, offsetX+i * widthT, offsetY-spanY);
                }
            }

        }
        if (favouriteTemperatureArray != null){

            var width = spanX / (favouriteTemperatureArray.size());
            var tempMean = mean(favouriteTemperatureArray);
            var tempMin = tempMean - span(favouriteTemperatureArray) / 2.0;
            var tempMax = tempMean + span(favouriteTemperatureArray) / 2.0;
            var tempSpan = tempMax - tempMin;
            System.println("output");
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
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawRectangle(offsetX, offsetY-spanY, spanX, spanY);

       }
    }
    public function makeRequest(forceFav as Boolean, forceProx as Boolean) as Void {
        System.println("TwelveLakesView.makeRequest");
        makeRequestFav(forceFav);
        makeRequestProx(forceProx);

    }
    public function makeRequestFav(forceFav as Boolean) as Void {
        System.println("TwelveLakesView.makeRequestFav");
        var favouriteLake  = getFavouriteLake() ;
        var favouritePosition  = getFavouritePosition() ;
        
        
        var skipUpdateBelowSeconds  = new Time.Duration(60*60);     // 60 min    
        var readyForUpdateFav = true;
        var lastUpdateFav = getLastUpdateFav();
        if (lastUpdateFav != null){
            readyForUpdateFav = Time.now().greaterThan(lastUpdateFav.add(skipUpdateBelowSeconds));
        }
        if (forceFav){
            readyForUpdateFav = true;
        }

        

        if ((favouriteLake != null) && (favouritePosition != null) && readyForUpdateFav){
            var options = {
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
                :headers => {
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
                }
            };
            var oneDay  = new Time.Duration(1*24*60*60);
            var twoDays = new Time.Duration(2*24*60*60);

            var inTwoDays    = Time.now().add(twoDays)     as Time.Moment;  // Moment + Duration => Moment 
            var beforeOneDay = Time.now().subtract(oneDay) as Time.Moment;  // Moment - Duration => Moment 

            var myRequestFav = alplakesApiString(
                favouriteLake,
                 beforeOneDay,
                  inTwoDays,
                  favouritePosition
            );
            System.println(myRequestFav);
            Communications.makeWebRequest(
                myRequestFav,
                null,
                options,
                method(:onReceiveFav)
            );
        }
    }

    public function makeRequestProx(forceProx as Boolean) as Void {
        System.println("TwelveLakesView.makeRequestProx");
        var skipUpdateBelowSeconds2    = new Time.Duration(15*60);     // 60 min    
        var readyForUpdateProx = true;
        var lastUpdateProx = getLastUpdateProx();
        if (lastUpdateProx != null){
            readyForUpdateProx = Time.now().greaterThan(lastUpdateProx.add(skipUpdateBelowSeconds2));
        }
        if (getCurrentTemperature() == null){
            readyForUpdateProx = true;   
        }
        if (forceProx){
            readyForUpdateProx = true;   
        }
        
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };
        var today = Time.now();

        var currentLake = getCurrentLake();
        var currentPosition = getCurrentPosition();
        System.println(currentLake);
        System.println(currentPosition);
        if ((currentLake != null) && (currentPosition != null) && readyForUpdateProx){
            var myRequestProx = alplakesApiString(currentLake,today,today,currentPosition);
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
            System.println(data);
            if (data instanceof Dictionary){
                var helper = processReceivedData(data); // lake, favouriteTimeArray, favouriteTemperatureArray
                var favouriteTimeArray = helper[1];
                var favouriteTemperatureArray = helper[2];
                if ((favouriteTimeArray != null) && (favouriteTemperatureArray != null)){
                    setFavouriteTimeArray(favouriteTimeArray);

                    setFavouriteTemperatureArray(favouriteTemperatureArray);

                    setFavouriteTemperature(favouriteTemperatureArray[(favouriteTemperatureArray.size()/3).toNumber()]);

                    setLastUpdateFav();

                    requestUpdate();
                }
            }
        } else {
            System.print("Failed to load\nError: " + responseCode.toString());

        }
    }
    public function onReceiveProx(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("TwelveLakesView.onReceiveProx");
        System.println(responseCode);;
        if ((responseCode == 200) and (data instanceof Dictionary)) {
            System.println(data);
            var helper = processReceivedData(data); // lake, favouriteTimeArray, favouriteTemperatureArray, currentDistance
            var __favouriteTemperatureArray = helper[2];
            var currentDistance = helper[3];
            var currentTemperature = null;
            if (__favouriteTemperatureArray != null){
                currentTemperature = __favouriteTemperatureArray[0];
                setCurrentTemperature(currentTemperature);
                if (currentDistance != null){
                    setCurrentDistance(currentDistance);
                }

                setLastUpdateProx();
                requestUpdate();
            }

        } else {
            System.print("Failed to load\nError: " + responseCode.toString());
        }
    }

}
