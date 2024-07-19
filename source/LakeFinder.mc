using Toybox.Position;
import Toybox.Activity;
import Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

class MyLakeFinder {
    public const LAKES_3D as Array<String> = [
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

    private const POS_LAKES_3D as Dictionary<String, Array<[Float, Float]>>  = {
        // todo add severlal positions for big lakes
        "greifensee"=>[[47.366451, 8.661569],[47.348855, 8.681962],[47.332733, 8.695314]],
        "biel"=>[[47.082150, 7.173328],[47.050762, 7.108699],[47.126966, 7.225429], [47.083034, 7.169811]],
        "zurich"=>[[47.357742, 8.544124],[47.334269, 8.555672],[47.303737, 8.575304],[47.264961, 8.623228],[47.241838, 8.679235],[47.221450, 8.779703],[47.213999, 8.893450]],
        "geneva"=>[[46.223493, 6.165242],[46.418201, 6.854272],[46.450675, 6.699447],[46.363259, 6.258533],[46.420521, 6.430186],[46.449129, 6.683741],[46.494994, 6.614583],[46.476510, 6.467590]],
        "joux" =>[[ 46.621416, 6.254661],[46.653726, 6.315576],],
        "murten"=>[[ 46.940983, 7.070132],[46.923139, 7.094629],[46.913658, 7.048493],[46.949623, 7.121167],],
        "lugano" =>[[ 45.967778, 8.865629],[ 45.918147, 8.905443],[ 45.972503, 8.963707],[ 45.998817, 8.957395],[ 46.018714, 9.092858],],
        "ageri"=>[[ 47.134035, 8.599621],[47.112922, 8.631875]],
        "caldonazzo"=>[[ 46.011799, 11.251420],[46.032410, 11.238409]],
        "garda"=>[[ 45.486024, 10.663888],[45.496916, 10.559013],[45.862599, 10.850332],[45.682131, 10.703035],],
        "hallwil"=>[[ 47.264358, 8.221390],[47.303882, 8.209737]],
        "stmoritz" =>[[46.491765, 9.839358],[46.494720, 9.851632]],
    };

    
    function getClosesLake(position_lat_long as [Double, Double] or Null) as String or Null {
        var minDistVal = 666;
        var minDistIdx = null;

        if (position_lat_long != null){
            for( var i = 0; i < LAKES_3D.size(); i++ ) {

                var yolo = POS_LAKES_3D[LAKES_3D[i]];
                for( var j = 0; j < yolo.size(); j++ ) {
                    var lakePos = yolo[j];
                    
                    var dx = lakePos[0] - position_lat_long[0];
                    var dy = lakePos[1] - position_lat_long[1];

                    var distance = Math.sqrt(dx * dx + dy * dy);

                    if (distance < minDistVal){
                        minDistVal = distance;
                        minDistIdx = i;
                    }
                }
            }
            return LAKES_3D[minDistIdx];

        }
        return null;
    }

    function getLakeByGPS(){
        var position_lat_long = getPosition();
        return getClosesLake(position_lat_long);

    }
    
}

function getPosition() as [Double, Double] or Null{
        var myPos = null;
        var info = Position.getInfo();

        if (info != null){
            var position = info.position;
            if (position != null){
                myPos = position.toDegrees();
                }
            }
        return myPos;
    }

function asAlplakeString(time as Time.Moment) as String{
    var gregorianInfo = Gregorian.info(time, Time.FORMAT_SHORT);;
    var result = Lang.format(
        "$1$$2$$3$$4$$5$",
        [
            gregorianInfo.year.format("%04d"),
            gregorianInfo.month.format("%02d"),
            gregorianInfo.day.format("%02d"),
            gregorianInfo.hour.format("%02d"),
            gregorianInfo.min.format("%02d"),
        ]
    );
    return result;
}

function alplakesApiString3DLake(
    lake as String,
    start as Time.Moment,
    stop as Time.Moment ,
    position as [Double,Double] or Array<Double>
    ) as String{
    return Lang.format(
            "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
            [lake,
            asAlplakeString(start),
            asAlplakeString(stop),
            position[0],
            position[1]]
            );
    
}

function alplakesApiString1DLake(
    lake as String,
    start as Time.Moment,
    stop as Time.Moment
    ) as String{
    return Lang.format(
            "https://alplakes-api.eawag.ch/simulations/1d/point/simstrat/$1$/T/$2$/$3$/1",
            [lake,
            asAlplakeString(start),
            asAlplakeString(stop)
            ]
            );
    
}