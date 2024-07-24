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
function setLastUpdateProx() as Void{
    Storage.setValue("lastUpdateProx", Time.now().value() as Number);
}
function setLastUpdateFav() as Void{
    Storage.setValue("lastUpdateFav", Time.now().value() as Number);
}

function setCurrentTemperature(currentTemperature as Float) as Void{
    Storage.setValue("currentTemperature", currentTemperature);
}
function setCurrentDistance(currentDistance as Float) as Void{
    Storage.setValue("currentDistance", currentDistance);
}


// Getters
(:glance)
function getFavouritePosition() as [Double, Double] {
    var myDefault = [46.287075.toDouble(), 6.169610.toDouble()];
    var ret =  Storage.getValue("favouritePosition") as [Double, Double] or Null;
    if (ret == null){
        return myDefault;
    }else{
        return ret;
    }
}

(:glance)
function getFavouriteLake() as String {
    var myDefault = "geneva";
    var ret =  Storage.getValue("favouriteLake");
    if (ret == null){
        return myDefault;
    }else{
        return (ret as String);
    }
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
function getLastUpdateProx() as Time.Moment or Null{
    return _getLastUpdate("lastUpdateProx");
}
(:glance)
function getLastUpdateFav() as Time.Moment or Null{
    return _getLastUpdate("lastUpdateFav");

}

function getCurrentTemperature()  as Float or Null{
    return Storage.getValue("currentTemperature")  as Float or Null;
}
function getCurrentDistance()  as Float or Null{
    return Storage.getValue("currentDistance")  as Float or Null;
}



function getCurrentLake()  as String or Null{
    return Storage.getValue("currentLake") as String or Null;

}
function getCurrentPosition()  as [Double, Double] or Null{
    return Storage.getValue("currentPosition") as [Double, Double] or Null;

}


function setCurrentLake(lake as String) as Void{
    Storage.setValue("currentLake", lake);

}
function setCurrentPosition(position as [Double, Double]) as Void {
    Storage.setValue("currentPosition", position);
}