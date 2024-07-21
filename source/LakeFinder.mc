using Toybox.Position;
import Toybox.Activity;
import Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.System;

const LAKES_3D as Array<String> = [
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



const POS_LAKES as Dictionary<String, Array<[Float, Float]>>  = {
    // todo add severlal positions for big lakes
    "greifensee"=>[[47.366451, 8.661569],[47.348855, 8.681962],[47.332733, 8.695314]],
    "biel"=>[[47.082150, 7.173328],[47.050762, 7.108699],[47.126966, 7.225429], [47.083034, 7.169811]],
    "zurich"=>[[47.357742, 8.544124],[47.334269, 8.555672],[47.303737, 8.575304],[47.264961, 8.623228],[47.241838, 8.679235],[47.221450, 8.779703],[47.213999, 8.893450]],
    "geneva"=>[[46.223493, 6.165242],[46.418201, 6.854272],[46.450675, 6.699447],[46.363259, 6.258533],[46.420521, 6.430186],[46.449129, 6.683741],[46.494994, 6.614583],[46.476510, 6.467590]],
    "joux" =>[[ 46.621416, 6.254661],[46.653726, 6.315576],[46.665987, 6.325721]],
    "murten"=>[[ 46.940983, 7.070132],[46.923139, 7.094629],[46.913658, 7.048493],[46.949623, 7.121167],],
    "lugano" =>[[ 45.967778, 8.865629],[ 45.918147, 8.905443],[ 45.972503, 8.963707],[ 45.998817, 8.957395],[ 46.018714, 9.092858],],
    "ageri"=>[[ 47.134035, 8.599621],[47.112922, 8.631875]],
    "caldonazzo"=>[[ 46.011799, 11.251420],[46.032410, 11.238409]],
    "garda"=>[[ 45.486024, 10.663888],[45.496916, 10.559013],[45.862599, 10.850332],[45.682131, 10.703035],],
    "hallwil"=>[[ 47.264358, 8.221390],[47.303882, 8.209737]],
    "stmoritz" =>[[46.491765, 9.839358],[46.494720, 9.851632]],
    // 1D from here!!
    "baldegg" => [[47.211312, 8.25274],[47.185580, 8.269979],],
    "aegeri" => [[47.121528, 8.621611]],
    "upperconstance" => [[47.656557, 9.202452],[47.696989, 9.201297],[47.804525, 9.059257],[47.768446, 9.126235],[47.731176, 9.198987], [47.615031, 9.384969], [47.532398, 9.590743]],
    "lowerconstance" => [[47.674478, 9.106814],[47.703336, 9.074968],[47.728333, 9.014134],[47.684374, 9.017808]],
    "thun" => [[46.670115, 7.812370],[46.691434, 7.713322], [46.733380, 7.640492]],
    "brienz" => [[46.696096, 7.900252], [46.725393, 7.969683],  [46.747355, 8.029403]],
    "klontalersee" => [[47.025773, 8.978931]],
    "gruyere" => [[46.665462, 7.096304]],
    "lungern" => [[46.802736, 8.164041]],
    "maggiore" => [[45.749112, 8.582207],[45.816760, 8.583361],[45.865029, 8.584516],[45.921291, 8.508300],[45.946188, 8.628398],[46.020012, 8.725401],[46.140166, 8.798153]],
    "pfaffikon" => [[47.352203, 8.780084]],
    "neuchatel" => [[46.965962, 7.004414],[46.994375, 7.019112],[46.991033, 6.955420], [46.903514, 6.855800], [46.803557, 6.684321]],
    "sarnen" => [[46.856916, 8.203297], [46.883955, 8.236498]],
    "sempach" => [[47.142973, 8.155282]],
    "sihlsee" => [[47.096008, 8.802609],[47.142961, 8.776887]],
    "lucernealpnachersee" => [[46.975397, 8.332735],[46.964796, 8.312908], [46.958236, 8.293339]],
    "walensee" => [[47.132209, 9.125012], [47.123073, 9.274140]],
    "lucerneurnersee" => [[47.034203, 8.600720]],
    "poschiavo" => [[46.282356, 10.090837]],
    "sils" => [[46.427572, 9.746538],[46.412655, 9.719795]],
    "silvaplana" => [[46.442514, 9.783044], [46.455824, 9.800507], [46.465241, 9.802194]],
    "zug" => [[47.095080, 8.483480],[47.158591, 8.484424]],
    "champfer" => [[46.467205, 9.804395],[46.471182, 9.809303]],
    "lauerz" => [[47.039143, 8.588716],[47.030934, 8.611784]],
    "rotsee" => [[47.066040, 8.306272],[47.073289, 8.320863]],
    "turlersee" => [[47.268626, 8.501961]],
    "amsoldingersee" => [[46.724471, 7.576419]],
    "moossee" => [[47.021993, 7.480875]],
    "mauensee" => [[47.171505, 8.076109]],
    "soppensee" => [[47.089953, 8.080351]],
    "oeschinensee" => [[46.498237, 7.726159]],
    "cadagno" => [[46.549988, 8.711612]],
    "huttwilersee" => [[47.259528, 8.222778],[47.293457, 8.209750]],
    "inkwilersee" => [[47.198259, 7.663201]],
    "huttnersee" => [[47.183544, 8.674181]],
    "lutzelsee" => [[47.259906, 8.772678]],
    "husemersee" => [[47.621715, 8.705811]],
    "mettmenhaslisee" => [[47.474221, 8.491685]],
    //"egelsee" => [[]], // welcher?
    "untererchatzensee" => [[47.432422, 8.494582],[47.431493, 8.489733]],
    "seeweidsee" => [[47.256931, 8.745947]],
    "burgaschisee" => [[47.169438, 7.668766]],
    "burgseeli" => [[46.697066, 7.886097],],
    "dittligsee" => [[46.756244, 7.533594]],
    "gerzensee" => [[46.830608, 7.546899]],
    "lobsigensee" => [[47.030623, 7.298010]],
    "chlimoossee" => [[47.026298, 7.468908]],
    "brenet" => [[46.668656, 6.321804], [46.673471, 6.323769]],
    "uebeschisee" => [[46.733809, 7.565366]],
    "bret" => [[46.513771, 6.773233]],
    //"tome" => [[]], // welcher?
    //"superiore" => [[]],
    "barone" => [[46.401833, 8.751952]],
    "geistsee" => [[46.761296, 7.535083]],
    "sassolo" => [[46.476289, 8.593321]],
    "barchetsee" => [[47.615388, 8.753125]],
    "hasenseeost" => [[47.607596, 8.830029]],
    "bichelsee" => [[47.457450, 8.899878]],
    "hasenseewest" => [[47.608013, 8.828320]],
    "hauptwilerweiher" => [[47.479982, 9.256058]],
    "hugiweiher" => [[47.571746, 8.858747]],
    //"marwilermoos" => [[]], ??
    "obererbommerweiher" => [[47.618146, 9.155585]],
    "nussbommersee" => [[47.615727, 8.816815]],
    "vagoweiher" => [[47.585458, 9.029172]],
    //"wilemersee" => [[]], ??
    "wistererweiher" => [[47.582154, 9.054829]],
    //"lucernegersauerandtreibbecken" => [[]],
    //"lucernekreuztrichterandvitznauerbecken" => [[]],
    "lioson" => [[46.386193, 7.128668]],
    "chavonnes" => [[46.333254, 7.085433]],
    "bretaye" => [[46.326086, 7.072169]],
    "lenkerseeli" => [[46.448360, 7.443009]],
    "stockseewli" => [[46.600175, 8.324769]],
    "steinsee" => [[48.021680, 11.861834]],
    "lucerne" => [[46.984825, 8.329801],[47.050369, 8.322584],[47.079670, 8.434310],[47.011426, 8.471462],[47.025623, 8.425065],[46.991540, 8.592609],[46.982376, 8.529060],[46.904069, 8.605526],[46.945706, 8.600359]],     
        //"oberesbanzlauiseeli" => [[]],*/
};

(:glance)
function lakeType(lake as String) as String{
    System.println("lakeType");
    for(var i = 0; i < LAKES_3D.size(); i++ ) {
        if (LAKES_3D[i].equals(lake)){
            return "3D";
        }
    }
    return "1D";
}

function getClosesLake(position_lat_long as [Double, Double] or Null) as String or Null {
    System.println("getClosesLake");
    var minDistVal = 10000.toDouble();
    var minDistName = null;
    var keys = POS_LAKES.keys();

    if (position_lat_long != null){
        for(var i = 0; i < keys.size(); i++ ) {

            var lakePosArr = POS_LAKES[keys[i]];
            for(var j = 0; j < lakePosArr.size(); j++ ) {
                var lakePos = lakePosArr[j];
                
                var dx = lakePos[0] - position_lat_long[0];
                var dy = lakePos[1] - position_lat_long[1];

                var distance = Math.sqrt(dx * dx + dy * dy);

                if (distance < minDistVal){
                    minDistVal = distance;
                    minDistName = keys[i];
                }
            }
        }
        return minDistName;

    }
    return null;
}

function getLakeByGPS(){
    System.println("getLakeByGPS");
    var position_lat_long = getPosition();
    return getClosesLake(position_lat_long);

}


function getPosition() as [Double, Double] or Null{
    System.println("getPosition");
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

(:glance)
function asAlplakeString(time as Time.Moment) as String{
    System.println("asAlplakeString");
    var twoHours     = new Time.Duration(2*60*60); // from +2 to UTC

    var gregorianInfo = Gregorian.info(time.subtract(twoHours), Time.FORMAT_SHORT);;
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

(:glance)
function alplakesApiString(
    lake as String,
    start as Time.Moment,
    stop as Time.Moment ,
    position as [Double,Double] or Array<Double>
    ) as String{
    System.println("alplakesApiString");

    if (lakeType(lake).equals("1D")){
        return alplakesApiString1DLake(lake, start, stop);
    }else{
        return alplakesApiString3DLake(lake, start, stop, position);
    }
}

(:glance)
function alplakesApiString3DLake(
    lake as String,
    start as Time.Moment,
    stop as Time.Moment ,
    position as [Double,Double] or Array<Double>
    ) as String{
    System.println("alplakesApiString3DLake");

    return Lang.format(
            "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
            [lake,
            asAlplakeString(start),
            asAlplakeString(stop),
            position[0],
            position[1]]
            );
    
}

(:glance)
function alplakesApiString1DLake(
    lake as String,
    start as Time.Moment,
    stop as Time.Moment
    ) as String{
    System.println("alplakesApiString1DLake");

    var oneFiveHour = new Time.Duration(90*60);

    return Lang.format(
            "https://alplakes-api.eawag.ch/simulations/1d/point/simstrat/$1$/T/$2$/$3$/1",
            [lake,
            asAlplakeString(start.subtract(oneFiveHour)), // increase timespan
            asAlplakeString(stop.add(oneFiveHour)) // increase timespan
            ]
            );
    
}

(:glance)
function processReceivedData(data as Dictionary) as [String, Array<String>, Array<Float>, Float] or [String, Array<String>, Array<Float>, Null] or [Null, Null, Null, Null]{
    System.println("processReceivedData");
    var lake = data["lake"];
    if (lake == null){
        return [null, null, null, null];
    }else{
        var helper;
        if (lakeType(lake).equals("1D")){
            helper = processReceivedData1D(data);
        }else{
            helper = processReceivedData3D(data);
        }

        if (helper[2].size() != 0){
            return helper;
            }
        else{
            return [null, null, null, null];
        }
    }
}

(:glance)
function processReceivedData3D(data as Dictionary) as [String, Array<String>, Array<Float>, Float]{
    System.println("processReceivedData3D");
    var favouriteTimeArray = data["time"]; // YYYYmmddhhmm
    var favouriteTemperatureArray = data["temperature"]["data"];
    var lake = data["lake"];
    var distane = data["distance"];
    return [lake, favouriteTimeArray, favouriteTemperatureArray, distane];
}

(:glance)
function processReceivedData1D(data as Dictionary) as [String, Array<String>, Array<Float>, Null]{
    System.println("processReceivedData1D");
    var favouriteTemperatureArray = data["T"];
    var favouriteTimeArray = data["time"]; // YYYY-mm-ddThh:mm:ss+00:00
    var lake = data["lake"];

    // overwrite string with format YYYYmmddhhmm
    var s;
    for( var i = 0; i < favouriteTimeArray.size(); i++ ) {
        s = favouriteTimeArray[i];

        var options = {
            :year   => s.substring(0, 4).toNumber(),
            :month  => s.substring(5, 7).toNumber() ,
            :day    => s.substring(8, 10).toNumber(),
            :hour   => s.substring(11, 13).toNumber(),
            :minute => s.substring(14, 16).toNumber()
        };

        var momentTmp = Gregorian.moment(options);
        var twoHours     = new Time.Duration(2*60*60); // from +2 to UTC

        favouriteTimeArray[i] = asAlplakeString(momentTmp.add(twoHours)); 
    }

    return [lake, favouriteTimeArray, favouriteTemperatureArray, null];
}