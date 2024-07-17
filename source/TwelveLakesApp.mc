import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Activity;

class TwelveLakesApp extends Application.AppBase {
    var favouriteLake as String = "geneva";
    var favouritePosition as [Float, Float]= [46.210417, 6.154484];


    function initialize() {
        AppBase.initialize();

    }
    function getGlanceView() {
        return [ new WidgetGlanceView(favouriteLake,favouritePosition) ];
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new TwelveLakesView(favouriteLake,favouritePosition);        
        return [view];
    }

}

function getApp() as TwelveLakesApp {
    return Application.getApp() as TwelveLakesApp;
}