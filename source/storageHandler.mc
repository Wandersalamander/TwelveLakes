import Toybox.Lang;
import Toybox.Time;
import Toybox.Application.Storage;
import Toybox.Application;
(:glance)
function setFavouritePosition(position_lat_long as [Double, Double]) as Void{
    Storage.setValue("favouritePosition", position_lat_long);
}

function setFavouriteLake(newFavouriteLake as String) as Void{
    Storage.setValue("favouriteLake", newFavouriteLake);
}
(:glance)
function setFavouriteTemperature(temperature as Float) as Void{
    Storage.setValue("favouriteTemperature", temperature);
}
function setFavouriteTemperatureArray(favouriteTemperatureArray as Array<Float>) as Void{
    Storage.setValue("favouriteTemperatureArray", favouriteTemperatureArray as Application.PropertyValueType);
}
function setFavouriteTimeArray(favouriteTimeArray as Array<String>) as Void{
    Storage.setValue("favouriteTimeArray", favouriteTimeArray as Application.PropertyValueType);
}


(:glance)
function setGlanceLastUpdate() as Void{
    
    Storage.setValue("glanceLastUpdate", Time.now().value() as Number);
}
function setViewLastUpdateProx() as Void{
    Storage.setValue("viewLastUpdateProx", Time.now().value() as Number);
}
function setViewLastUpdateFav() as Void{
    Storage.setValue("viewLastUpdateFav", Time.now().value() as Number);
}

function setCurrentTemperature(currentTemperature as Float) as Void{
    Storage.setValue("currentTemperature", currentTemperature);
}
function setCurrentDistance(currentDistance as Float) as Void{
    Storage.setValue("currentDistance", currentDistance);
}


// Getters
(:glance)
function getFavouritePosition() as [Double, Double] or Null {
    return Storage.getValue("favouritePosition")  as [Double, Double] or Null;
}
(:glance)
function getFavouriteLake() as String  or Null{
    return Storage.getValue("favouriteLake") as String  or Null;
}
(:glance)
function getFavouriteTemperature() as Float or Null{
    return Storage.getValue("favouriteTemperature") as Float or Null;
}
function getFavouriteTemperatureArray() as Array<Float> or Null{
    return Storage.getValue("favouriteTemperatureArray") as Array<Float> or Null;
}
function getFavouriteTimeArray() as Array<String> or Null{
    return Storage.getValue("favouriteTimeArray") as Array<String> or Null;
}

(:glance)
function _getLastUpdate(name as String)  as Time.Moment or Null{
    if (Storage.getValue(name) != null){
        return new Time.Moment(Storage.getValue(name) as Number);
    }else{
            return null;
    }
}
(:glance)
function getGlanceLastUpdate() as Time.Moment or Null{
        return _getLastUpdate("glanceLastUpdate");
}
function getViewLastUpdateProx() as Time.Moment or Null{
    return _getLastUpdate("viewLastUpdateProx");
}
function getViewLastUpdateFav() as Time.Moment or Null{
    return _getLastUpdate("viewLastUpdateFav");

}

function getCurrentTemperature()  as Float or Null{
    return Storage.getValue("currentTemperature")  as Float or Null;
}
function getCurrentDistance()  as Float or Null{
    return Storage.getValue("currentDistance")  as Float or Null;
}
