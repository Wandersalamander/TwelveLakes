using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application.Storage;
import Toybox.Position;

enum
{
    GPS,
    UPDATE_ALL,
    CREDITS
}


class MyActionMenuDelegate extends WatchUi.ActionMenuDelegate {
    var view as TwelveLakesView;

    function initialize(view as TwelveLakesView) {
        System.println("MyActionMenuDelegate.initialize");
        ActionMenuDelegate.initialize();
        // Start aquiring GPS position, so that on button press the GPS-quality might be okay alread
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        self.view = view;
    }
    function onBack() as Void{
        System.println("MyActionMenuDelegate.onBack");
        // disable GPS
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }


    function onSelect(item as WatchUi.ActionMenuItem) as Void{
        System.println("MyActionMenuDelegate.onSelect");
        if (item has :getId){
            var Id = item.getId();
            if (Id != null){
                switch (Id){
                    case GPS:
                        var position_lat_long = getPosition();
                        var newFavouriteLake = getClosesLake(position_lat_long);
                        if (position_lat_long != null and newFavouriteLake != null){
                            setFavouritePosition(position_lat_long);
                            setFavouriteLake(newFavouriteLake);
                            WatchUi.showToast(readableLakeName(newFavouriteLake), null);
                            self.view.notifyFullUpdate();
                        }else{
                            WatchUi.showToast("GPS quality too low", null);
                        }
                        break; // mandatory, otherwise next case also executed
                    case CREDITS:
                        WatchUi.showToast("Thanks Alplakes.ch", null);
                        break; // mandatory, otherwise next case also executed
                    case UPDATE_ALL:
                        self.view.notifyFullUpdate();
                        break; // mandatory, otherwise next case also executed
                }
            }
        // disable GPS
        }
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }
    public function onPosition(info as Info) as Void {
        System.println("MyActionMenuDelegate.onPosition");
        System.println("info.accuracy");
        System.println(info.accuracy);
    }
}

class MyBehaviorDelegate extends WatchUi.BehaviorDelegate {
    var view as TwelveLakesView;
    function initialize(view as TwelveLakesView){
        System.println("MyBehaviorDelegate.initialize");
        BehaviorDelegate.initialize();
        self.view = view;
    }

    function onSelect(){
        System.println("MyBehaviorDelegate.onSelect");
        var options = {:theme => WatchUi.ACTION_MENU_THEME_LIGHT};
        var myMenu = new ActionMenu(options);
        var item1 = new ActionMenuItem({:label => "GPS as Fav."}, GPS);
        var item2 = new ActionMenuItem({:label => "Reload"}, UPDATE_ALL);
        var item3 = new ActionMenuItem({:label => "Credits"}, CREDITS);
        myMenu.addItem(item1);
        myMenu.addItem(item2);
        myMenu.addItem(item3);
        var delegate = new MyActionMenuDelegate(self.view);
        showActionMenu(myMenu, delegate);
        return false; // allow InputDelegate function to be called
    }
}

