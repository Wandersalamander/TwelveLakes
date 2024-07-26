import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Activity;
using Toybox.Application.Storage;

class TwelveLakesApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  function getGlanceView() {
    return [new WidgetGlanceView()];
  }

  // Return the initial view of your application here
  function getInitialView() as [Views] or [Views, InputDelegates] {
    var view = new TwelveLakesView();
    var delegate = new MyBehaviorDelegate(view);
    return [view, delegate];
  }
}

function getApp() as TwelveLakesApp {
  return Application.getApp() as TwelveLakesApp;
}
