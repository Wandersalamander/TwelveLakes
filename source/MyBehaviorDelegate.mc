using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application.Storage;

enum
{
    GPS,
    CREDITS
}

class MyActionMenuDelegate extends WatchUi.ActionMenuDelegate {
    var view as TwelveLakesView;

    function initialize(view as TwelveLakesView) {
        System.println("MyBehaviorDelegate.initialize");
        ActionMenuDelegate.initialize();
        self.view = view;
    }

    function onSelect(item as WatchUi.ActionMenuItem) as Void{
        System.println("MyBehaviorDelegate.onSelect");
        switch (item.getId()){
            case GPS:
                var position_lat_long = getPosition();
                var newFavouriteLake = getClosesLake(position_lat_long);
                Storage.setValue("favouritePosition", position_lat_long);
                Storage.setValue("favouriteLake", newFavouriteLake);
                WatchUi.showToast(newFavouriteLake, null);
                self.view.notifyFavUpdate();
                break; // mandatory, otherwise next case also executed
            case CREDITS:
                WatchUi.showToast("Thanks Alplakes.ch", null);
                break; // mandatory, otherwise next case also executed
        }
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
        var item2 = new ActionMenuItem({:label => "Credits"}, CREDITS);
        myMenu.addItem(item1);
        myMenu.addItem(item2);
        var delegate = new MyActionMenuDelegate(self.view);
        showActionMenu(myMenu, delegate);
        return false; // allow InputDelegate function to be called
    }
}

