using Toybox.Position;
import Toybox.Activity;
class MyLakeFinder {
    public var available_lakes = [
        "geneva",
        "garda",
        "zurich",
        "lugano",
        "biel",
        "murten",
        "hallwil",
        "joux",
        "greifensee",
        "ageri",
        "stmoritz",
        "caldonazzo"
    ];

    private var lakePositions = {
        // todo add severlal positions for big lakes
        "greifensee"=> [47.350895, 8.678143],
        "biel"=>[47.082150, 7.173328],
        "zurich"=>[47.239060, 8.691928],
        "geneva"=>[46.437598, 6.480346],
        "joux" => [46.639361, 6.288662],
        "murten"=> [46.930861, 7.082575],
        "lugano" => [45.991355, 8.975736],
        "ageri"=> [47.122585, 8.620448],
        "caldonazzo"=> [46.018954, 11.242902],
        "garda"=> [45.649841, 10.672036],
        "hallwil"=> [47.282686, 8.212938],
        "stmoritz" =>[46.494658, 9.844898],
    };

    function getPosition(){
        var myPos = null;
        var info = Position.getInfo();

        if (info != null){
            var position = info.position;
            if (position != null){
                myPos = position.toDegrees();
                }
            }
        System.println("myPos");
        System.println(myPos);
        return myPos;
    }
    function getClosesLake(position_lat_long){
        var minDistVal = 666;
        var minDistIdx = null;

        if (position_lat_long != null){
            for( var i = 0; i < available_lakes.size(); i++ ) {

                var lakePos = lakePositions[available_lakes[i]];

                var dx = lakePos[0] - position_lat_long[0];
                var dy = lakePos[1] - position_lat_long[1];

                var distance = Math.sqrt(dx * dx + dy * dy);

                if (distance < minDistVal){
                    minDistVal = distance;
                    minDistIdx = i;
                }
            }
            return available_lakes[minDistIdx];

        }
        return null;
    }

    function getLakeByGPS(){
        var position_lat_long = getPosition();
        return getClosesLake(position_lat_long);

    }
    
}