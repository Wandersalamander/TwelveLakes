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
    // Closest Lake
    public var currentLake as String or Null = null;
    public var currentPosition as [Double,Double] or Null = null;
    public var currentTemperature as Float or Null = null;
    public var currentDistance as Float or Null= null;

    // Favourite lake
    public var favouriteLake as String or Null= null;
    public var favouritePosition as Array<Double> or Null= null;
    public var favouriteTemperature as Float or Null = null;
    public var favouriteTemperatureArray as Array<Float> or Null = null;
    public var favouriteTimeArray as Array<String> or Null= null;
    

    var lastUpdateFav as Time.Moment or Null = null;
    var lastUpdateProx as Time.Moment or Null = null;

    function initialize() {
        System.println("TwelveLakesView.initialize");
        View.initialize();

        lastUpdateFav = getViewLastUpdateFav();
        lastUpdateProx = getViewLastUpdateProx();

        updateFavourites();
        updateCurrent();

        favouriteTemperatureArray = getFavouriteTemperatureArray();
        favouriteTimeArray = getFavouriteTimeArray();
        favouriteTemperature = getFavouriteTemperature();
        
        currentTemperature = getCurrentTemperature();
        currentDistance = getCurrentDistance();


        makeRequest(false, false);

    }
    function updateCurrent() as Void{
        self.currentPosition = getPosition();
        if (currentPosition != null){
            self.currentLake = getClosesLake(currentPosition);
        }
    }

    function notifyFullUpdate() as Void{
        System.println("TwelveLakesView.notifyFavUpdate");
        updateFavourites();
        updateCurrent();
        makeRequest(true, true);
    }

    function updateFavourites() as Void{
        System.println("TwelveLakesView.updateFavourites");
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

    function onLayout(dc){
        System.println("TwelveLakesView.onLayout");
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }


    // Update the view
    function onUpdate(dc as Dc) as Void {
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
        System.println("TwelveLakesView.onUpdate headline");
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        if ((favouriteLake != null) && (favouriteTemperature != null)){
            dc.drawText(dc.getWidth()/2, 0.1*dc.getHeight(), Graphics.FONT_MEDIUM, Lang.format("$1$°C", [favouriteTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, 0.2*dc.getHeight(), Graphics.FONT_MEDIUM, Lang.format("$1$$2$", [favouriteLake.substring(0,1).toUpper(), favouriteLake.substring(1, favouriteLake.length())]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        System.println("TwelveLakesView.onUpdate current");

        if (currentLake != null && currentTemperature != null){
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
            dc.drawText(dc.getWidth()/2, 0.825*dc.getHeight(), Graphics.FONT_AUX1, text, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);

            dc.drawText(dc.getWidth()/2, 0.9*dc.getHeight(), Graphics.FONT_AUX1, Lang.format("$1$$2$: $3$°C", [currentLake.substring(0,1).toUpper(), currentLake.substring(1, currentLake.length()), currentTemperature.format("%.1f")]), Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
        }
        System.println("TwelveLakesView.onUpdate favourite");
        
        if (favouriteTimeArray != null){
            var widthT = spanX / (favouriteTimeArray.size());

            var hhmm;
            var dd;
            var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var todayString = today.day.format("%02d");

            for (var i = 0; i < (favouriteTimeArray.size()); i++) {
                dd = favouriteTimeArray[i].substring(6, 8);
                hhmm = favouriteTimeArray[i].substring(8, 8+4);
                if (hhmm.equals( "1200")){
                    if (dd.equals(todayString)){
                        dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, Lang.format("$1$", ["Today"]), Graphics.TEXT_JUSTIFY_CENTER);
                    }else{
                        if ((i < favouriteTimeArray.size()-1)){
                            dc.drawText(offsetX+i * widthT, offsetY-spanY, Graphics.FONT_AUX2, Lang.format("$1$.", [dd]), Graphics.TEXT_JUSTIFY_CENTER);
                        }
                    }
                }
                if (hhmm.equals("0000")){
                    dc.drawLine(offsetX+i * widthT, offsetY, offsetX+i * widthT, offsetY-spanY);
                }
            }

        }
        System.println("TwelveLakesView.onUpdate faArray");
        System.println(favouriteTemperatureArray);
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
       System.println("Done!");
    }
    public function makeRequest(forceFav as Boolean, forceProx as Boolean) as Void {
        System.println("TwelveLakesView.makeRequest");
        makeRequestFav(forceFav);
        makeRequestProx(forceProx);

    }
    public function makeRequestFav(forceFav as Boolean) as Void {
        System.println("TwelveLakesView.makeRequestFav");
        var skipUpdateBelowSeconds  = new Time.Duration(60*60);     // 60 min    
        var readyForUpdateFav = true;
        if (lastUpdateFav != null){
            readyForUpdateFav = Time.now().greaterThan(lastUpdateFav.add(skipUpdateBelowSeconds));
        }
        if (forceFav){
            readyForUpdateFav = true;
        }
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };
        var oneDay     = new Time.Duration(1*24*60*60);
        var twoDays    = new Time.Duration(2*24*60*60);

        var inTwoDays = Time.now().add(twoDays);
        var beforeOneDay = Time.now().subtract(oneDay);

        System.println(favouriteLake);
        System.println(favouritePosition);
        if ((favouriteLake != null) && (favouritePosition != null) && readyForUpdateFav){
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
        if (lastUpdateProx != null){
            readyForUpdateProx = Time.now().greaterThan(lastUpdateProx.add(skipUpdateBelowSeconds2));
        }
        if (currentTemperature == null){
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

                    favouriteTemperature = favouriteTemperatureArray[(favouriteTemperatureArray.size()/3).toNumber()]; // idx=9 is assumend. better to check with timeArray, but lets skip array operations here
                    setFavouriteTemperature(favouriteTemperature);

                    setViewLastUpdateFav();
                }
            }
        } else {
            System.print("Failed to load\nError: " + responseCode.toString());
            favouriteTemperature = null;

        }
        requestUpdate();
    }
    public function onReceiveProx(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("TwelveLakesView.onReceiveProx");
        System.println(responseCode);;
        if (responseCode == 200) {
            System.println(data);
            var helper = processReceivedData(data); // lake, favouriteTimeArray, favouriteTemperatureArray
            var favouriteTemperatureArray = helper[2];
            if (favouriteTemperatureArray != null){
                currentTemperature = favouriteTemperatureArray[0];
                setCurrentTemperature(currentTemperature);

                currentDistance = helper[3]; // km?
                setCurrentDistance(currentDistance);

                setViewLastUpdateProx();
            }

        } else {
            System.print("Failed to load\nError: " + responseCode.toString());
            currentTemperature = null;
        }
        requestUpdate();
    }

}
