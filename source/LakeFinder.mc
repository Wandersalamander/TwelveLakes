import Toybox.Position;
import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;
import Toybox.System;
using Toybox.WatchUi;


(:glance)
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


(:glance)
const POS_LAKES as Dictionary<String, Array<[Float, Float]>>  = {
    "ageri" => [[47.1363, 8.5961]],
    "baldegg" => [[47.2, 8.2685]],
    "hallwil" => [[47.3179, 8.2073]],
    "biel" => [[47.0873, 7.2042], [47.0407, 7.1048], [47.0903, 7.1572]],
    "upperconstance" => [[47.656557, 9.202452],[47.696989, 9.201297],[47.804525, 9.059257],[47.768446, 9.126235],[47.731176, 9.198987], [47.615031, 9.384969], [47.532398, 9.590743]],
    "lowerconstance" => [[47.674478, 9.106814],[47.703336, 9.074968],[47.728333, 9.014134],[47.684374, 9.017808]],
    "brienz" => [[46.7555, 8.0211], [46.689, 7.9015]],
    "thun" => [[46.7027, 7.7296], [46.6722, 7.8302], [46.6707, 7.7148], [46.7301, 7.6289], [46.7027, 7.7296]],
    "geneva" => [[46.5045, 6.6426], [46.4991, 6.6938], [46.4864, 6.7308], [46.4741, 6.7748], [46.469, 6.8131], [46.4601, 6.8355], [46.4466, 6.8601], [46.439, 6.8896], [46.4288, 6.9175], [46.4047, 6.9275], [46.3959, 6.9087], [46.3949, 6.8816], [46.394, 6.8577], [46.3877, 6.8394], [46.3946, 6.8042], [46.3984, 6.7712], [46.4055, 6.7348], [46.4075, 6.6851], [46.4065, 6.6497], [46.4039, 6.6153], [46.3994, 6.5714], [46.4005, 6.529], [46.3982, 6.4917], [46.3747, 6.473], [46.3606, 6.4329], [46.3504, 6.4031], [46.3423, 6.3786], [46.3527, 6.3573], [46.37, 6.3421], [46.3686, 6.3156], [46.3593, 6.2918], [46.3364, 6.2693], [46.3128, 6.2539], [46.2909, 6.2366], [46.2653, 6.2075], [46.243, 6.194], [46.2085, 6.1632], [46.2135, 6.1535], [46.2395, 6.1517], [46.2632, 6.1654], [46.2825, 6.1679], [46.3035, 6.1812], [46.3367, 6.2048], [46.3559, 6.2161], [46.3785, 6.2409], [46.3925, 6.2639], [46.4016, 6.2827], [46.4235, 6.2964], [46.4378, 6.3156], [46.4545, 6.3373], [46.4644, 6.3785], [46.463, 6.4099], [46.4786, 6.455], [46.4907, 6.4786], [46.5048, 6.4969], [46.5158, 6.5117], [46.5078, 6.5458], [46.5156, 6.5763], [46.5123, 6.6075], [46.5061, 6.6282]],
    "greifensee" => [[47.3727, 8.6654]],
    "gruyere" => [[46.7172, 7.1127]],
    "klontalersee" => [[47.0275, 8.9949]],
    "joux" => [[46.6216, 6.2674]],
    "maggiore" => [[46.1717, 8.8461], [46.1569, 8.8623], [46.1426, 8.8366], [46.1051, 8.7562], [46.0492, 8.7317], [45.992, 8.7185], [45.9403, 8.6501], [45.8824, 8.5995], [45.8343, 8.6228], [45.8, 8.581], [45.7587, 8.5832], [45.7265, 8.6183], [45.7395, 8.579], [45.8018, 8.5421], [45.8612, 8.5692], [45.9234, 8.4931], [45.9299, 8.5403], [45.9489, 8.6061], [46.0258, 8.7033], [46.1079, 8.7022], [46.152, 8.7714], [46.1791, 8.8322]],
    "zurich" => [[47.2226, 8.8162], [47.2251, 8.9285], [47.2053, 8.8777], [47.1966, 8.8167], [47.2014, 8.7218], [47.2708, 8.589], [47.3401, 8.5661], [47.2532, 8.6879], [47.2269, 8.8118]],
    "lucernekreuztrichterandvitznauerbecken" => [[47.052699, 8.313514], [46.980173, 8.331606], [47.079325, 8.434602], [47.020000, 8.383365], [47.000981, 8.467959], [47.006403, 8.431383],],
    "lucerneurnersee" => [[46.989291, 8.596413],[46.901475, 8.608428],[46.947210, 8.603658]],
    "lucernegersauerandtreibbecken" => [ [46.987001, 8.436507], [46.994112, 8.467782],  [46.991460, 8.590052], [46.981335, 8.547470] ],
    "lungern" => [[46.7864, 8.1556]],
    "murten" => [[46.9573, 7.1159], [46.911, 7.0398], [46.9573, 7.1159]],
    "neuchatel" => [[47.0088, 6.9848], [47.0021, 7.0211], [46.9786, 7.0393], [46.9563, 7.0128], [46.9336, 6.9716], [46.9103, 6.9289], [46.8903, 6.8968], [46.8595, 6.8541], [46.8403, 6.8172], [46.8076, 6.7656], [46.8044, 6.7141], [46.7851, 6.6522], [46.8124, 6.6548], [46.8303, 6.6907], [46.8551, 6.7349], [46.8905, 6.7735], [46.9152, 6.8054], [46.9321, 6.8399], [46.9464, 6.8718], [46.9753, 6.8875], [46.9923, 6.9392], [47.0063, 6.975]],
    "pfaffikon" => [[47.3491, 8.7902]],
    "sempach" => [[47.1712, 8.1269]],
    "sarnen" => [[46.8896, 8.2416]],
    "alpnachersee" => [[46.981, 8.3337]],
    "lugano" => [[45.9517, 8.9579], [45.9552, 8.8871], [45.9297, 8.9021], [46.0231, 9.0797]],
    "walensee" => [[47.1337, 9.1704], [47.1141, 9.2502]],
    "zug" => [[47.1816, 8.4787], [47.1002, 8.5107], [47.1151, 8.4744], [47.1819, 8.4782]],
    "sihlsee" => [[47.1501, 8.7852]],
    "poschiavo" => [[46.2922, 10.0902]],
    "sils" => [[46.4255, 9.7433]],
    "silvaplana" => [[46.4585, 9.802]],
    "stmoritz" => [[46.4968, 9.8474]],
    "champfer" => [[46.4607, 9.8011]],
    "lauerz" => [[47.0444, 8.5908]],
    "rotsee" => [[47.0753, 8.3263]],
    "turlersee" => [[47.2645, 8.5102]],
    "amsoldingersee" => [[46.7269, 7.5753]],
    "moossee" => [[47.0246, 7.4744]],
    "mauensee" => [[47.1747, 8.0799]],
    "oeschinensee" => [[46.4978, 7.715]],
    "soppensee" => [[47.0922, 8.0804]],
    "inkwilersee" => [[47.1992, 7.6618]],
    "huttwilersee" => [[47.6142, 8.834]],
    "cadagno" => [[46.5517, 8.7147]],
    "husemersee" => [[47.6216, 8.7021]],
    "huttnersee" => [[47.1833, 8.669]],
    "lutzelsee" => [[47.259, 8.768]],
    "mettmenhaslisee" => [[47.4745, 8.4905]],
    "egelsee" => [[47.2577, 8.8165]],
    "untererchatzensee" => [[47.4312, 8.4857]],
    "seeweidsee" => [[47.2568, 8.7451]],
    "burgaschisee" => [[47.1707, 7.6655]],
    "burgseeli" => [[46.698, 7.8836]],
    "dittligsee" => [[46.7557, 7.531]],
    "gerzensee" => [[46.8345, 7.5489]],
    "lobsigensee" => [[47.0307, 7.2971]],
    "chlimoossee" => [[47.0264, 7.4683]],
    "uebeschisee" => [[46.7346, 7.5619]],
    "bret" => [[46.507, 6.769]],
    "brenet" => [[46.6673, 6.3169]],
    "chavonnes" => [[46.3327, 7.0836]],
    "bretaye" => [[46.3267, 7.0705]],
    "lioson" => [[46.3875, 7.1281]],
    "tome" => [[46.3634, 8.6886]],
    "barone" => [[46.4023, 8.7499]],
    "superiore" => [[46.4765, 8.5829]],
    "sassolo" => [[46.4762, 8.5909]],
    "geistsee" => [[46.7616, 7.5345]],
    "lenkerseeli" => [[46.449, 7.4419]],
    "stockseewli" => [[46.6001, 8.3242]],
    "oberesbanzlauiseeli" => [[46.6929, 8.285]],
    "barchetsee" => [[47.6152, 8.7527]],
    "bichelsee" => [[47.4569, 8.8969]],
    "hasenseeost" => [[47.607, 8.8296]],
    "hasenseewest" => [[47.6083, 8.8261]],
    "hauptwilerweiher" => [[47.4796, 9.2546]],
    "hugiweiher" => [[47.5713, 8.857]],
    "obererbommerweiher" => [[47.6174, 9.1534]],
    "marwilermoos" => [[47.5387, 9.0728]],
    "nussbommersee" => [[47.6154, 8.8107]],
    "vagoweiher" => [[47.5855, 9.0279]],
    "wilemersee" => [[47.5997, 8.7984]],
    "wistererweiher" => [[47.5819, 9.0538]],
    "garda" => [[45.4426, 10.6961], [45.4539, 10.6588], [45.4626, 10.623], [45.4964, 10.6085], [45.4791, 10.6078], [45.4623, 10.5658], [45.4834, 10.5396], [45.5012, 10.5116], [45.5311, 10.5588], [45.5654, 10.5693], [45.566, 10.552], [45.5901, 10.5732], [45.597, 10.5231], [45.613, 10.5516], [45.6337, 10.5993], [45.6546, 10.6328], [45.6882, 10.6645], [45.7169, 10.7056], [45.7472, 10.7454], [45.7675, 10.7611], [45.7986, 10.7829], [45.826, 10.8158], [45.8609, 10.8324], [45.8784, 10.8559], [45.8617, 10.8755], [45.8312, 10.859], [45.8048, 10.8429], [45.7786, 10.8158], [45.7488, 10.7978], [45.7189, 10.7753], [45.683, 10.7458], [45.6483, 10.7165], [45.6097, 10.6852], [45.573, 10.6713], [45.5635, 10.7115], [45.5235, 10.7272], [45.4803, 10.7198], [45.4483, 10.6949]],
    "caldonazzo" => [[46.0379, 11.2403]],
};

(:glance)
function readableLakeName(lake as String or Null) as String {
    // generated code because monkey c does not allow getting the resource by string..
    if (lake == null){
        return "No lake";
    }
    switch (lake){
        case "ageri":
            return WatchUi.loadResource(Rez.Strings.ageri) as String;
        case "baldegg":
            return WatchUi.loadResource(Rez.Strings.baldegg) as String;
        case "hallwil":
            return WatchUi.loadResource(Rez.Strings.hallwil) as String;
        case "biel":
            return WatchUi.loadResource(Rez.Strings.biel) as String;
        case "upperconstance":
            return WatchUi.loadResource(Rez.Strings.upperconstance) as String;
        case "lowerconstance":
            return WatchUi.loadResource(Rez.Strings.lowerconstance) as String;
        case "brienz":
            return WatchUi.loadResource(Rez.Strings.brienz) as String;
        case "thun":
            return WatchUi.loadResource(Rez.Strings.thun) as String;
        case "geneva":
            return WatchUi.loadResource(Rez.Strings.geneva) as String;
        case "greifensee":
            return WatchUi.loadResource(Rez.Strings.greifensee) as String;
        case "gruyere":
            return WatchUi.loadResource(Rez.Strings.gruyere) as String;
        case "klontalersee":
            return WatchUi.loadResource(Rez.Strings.klontalersee) as String;
        case "joux":
            return WatchUi.loadResource(Rez.Strings.joux) as String;
        case "maggiore":
            return WatchUi.loadResource(Rez.Strings.maggiore) as String;
        case "zurich":
            return WatchUi.loadResource(Rez.Strings.zurich) as String;
        case "lucernekreuztrichterandvitznauerbecken":
            return WatchUi.loadResource(Rez.Strings.lucernekreuztrichterandvitznauerbecken) as String;
        case "lucerneurnersee":
            return WatchUi.loadResource(Rez.Strings.lucerneurnersee) as String;
        case "lucernegersauerandtreibbecken":
            return WatchUi.loadResource(Rez.Strings.lucernegersauerandtreibbecken) as String;
        case "lungern":
            return WatchUi.loadResource(Rez.Strings.lungern) as String;
        case "murten":
            return WatchUi.loadResource(Rez.Strings.murten) as String;
        case "neuchatel":
            return WatchUi.loadResource(Rez.Strings.neuchatel) as String;
        case "pfaffikon":
            return WatchUi.loadResource(Rez.Strings.pfaffikon) as String;
        case "sempach":
            return WatchUi.loadResource(Rez.Strings.sempach) as String;
        case "sarnen":
            return WatchUi.loadResource(Rez.Strings.sarnen) as String;
        case "alpnachersee":
            return WatchUi.loadResource(Rez.Strings.alpnachersee) as String;
        case "lugano":
            return WatchUi.loadResource(Rez.Strings.lugano) as String;
        case "walensee":
            return WatchUi.loadResource(Rez.Strings.walensee) as String;
        case "zug":
            return WatchUi.loadResource(Rez.Strings.zug) as String;
        case "sihlsee":
            return WatchUi.loadResource(Rez.Strings.sihlsee) as String;
        case "poschiavo":
            return WatchUi.loadResource(Rez.Strings.poschiavo) as String;
        case "sils":
            return WatchUi.loadResource(Rez.Strings.sils) as String;
        case "silvaplana":
            return WatchUi.loadResource(Rez.Strings.silvaplana) as String;
        case "stmoritz":
            return WatchUi.loadResource(Rez.Strings.stmoritz) as String;
        case "champfer":
            return WatchUi.loadResource(Rez.Strings.champfer) as String;
        case "lauerz":
            return WatchUi.loadResource(Rez.Strings.lauerz) as String;
        case "rotsee":
            return WatchUi.loadResource(Rez.Strings.rotsee) as String;
        case "turlersee":
            return WatchUi.loadResource(Rez.Strings.turlersee) as String;
        case "amsoldingersee":
            return WatchUi.loadResource(Rez.Strings.amsoldingersee) as String;
        case "moossee":
            return WatchUi.loadResource(Rez.Strings.moossee) as String;
        case "mauensee":
            return WatchUi.loadResource(Rez.Strings.mauensee) as String;
        case "oeschinensee":
            return WatchUi.loadResource(Rez.Strings.oeschinensee) as String;
        case "soppensee":
            return WatchUi.loadResource(Rez.Strings.soppensee) as String;
        case "inkwilersee":
            return WatchUi.loadResource(Rez.Strings.inkwilersee) as String;
        case "huttwilersee":
            return WatchUi.loadResource(Rez.Strings.huttwilersee) as String;
        case "cadagno":
            return WatchUi.loadResource(Rez.Strings.cadagno) as String;
        case "husemersee":
            return WatchUi.loadResource(Rez.Strings.husemersee) as String;
        case "huttnersee":
            return WatchUi.loadResource(Rez.Strings.huttnersee) as String;
        case "lutzelsee":
            return WatchUi.loadResource(Rez.Strings.lutzelsee) as String;
        case "mettmenhaslisee":
            return WatchUi.loadResource(Rez.Strings.mettmenhaslisee) as String;
        case "egelsee":
            return WatchUi.loadResource(Rez.Strings.egelsee) as String;
        case "untererchatzensee":
            return WatchUi.loadResource(Rez.Strings.untererchatzensee) as String;
        case "seeweidsee":
            return WatchUi.loadResource(Rez.Strings.seeweidsee) as String;
        case "burgaschisee":
            return WatchUi.loadResource(Rez.Strings.burgaschisee) as String;
        case "burgseeli":
            return WatchUi.loadResource(Rez.Strings.burgseeli) as String;
        case "dittligsee":
            return WatchUi.loadResource(Rez.Strings.dittligsee) as String;
        case "gerzensee":
            return WatchUi.loadResource(Rez.Strings.gerzensee) as String;
        case "lobsigensee":
            return WatchUi.loadResource(Rez.Strings.lobsigensee) as String;
        case "chlimoossee":
            return WatchUi.loadResource(Rez.Strings.chlimoossee) as String;
        case "uebeschisee":
            return WatchUi.loadResource(Rez.Strings.uebeschisee) as String;
        case "bret":
            return WatchUi.loadResource(Rez.Strings.bret) as String;
        case "brenet":
            return WatchUi.loadResource(Rez.Strings.brenet) as String;
        case "chavonnes":
            return WatchUi.loadResource(Rez.Strings.chavonnes) as String;
        case "bretaye":
            return WatchUi.loadResource(Rez.Strings.bretaye) as String;
        case "lioson":
            return WatchUi.loadResource(Rez.Strings.lioson) as String;
        case "tome":
            return WatchUi.loadResource(Rez.Strings.tome) as String;
        case "barone":
            return WatchUi.loadResource(Rez.Strings.barone) as String;
        case "superiore":
            return WatchUi.loadResource(Rez.Strings.superiore) as String;
        case "sassolo":
            return WatchUi.loadResource(Rez.Strings.sassolo) as String;
        case "geistsee":
            return WatchUi.loadResource(Rez.Strings.geistsee) as String;
        case "lenkerseeli":
            return WatchUi.loadResource(Rez.Strings.lenkerseeli) as String;
        case "stockseewli":
            return WatchUi.loadResource(Rez.Strings.stockseewli) as String;
        case "oberesbanzlauiseeli":
            return WatchUi.loadResource(Rez.Strings.oberesbanzlauiseeli) as String;
        case "barchetsee":
            return WatchUi.loadResource(Rez.Strings.barchetsee) as String;
        case "bichelsee":
            return WatchUi.loadResource(Rez.Strings.bichelsee) as String;
        case "hasenseeost":
            return WatchUi.loadResource(Rez.Strings.hasenseeost) as String;
        case "hasenseewest":
            return WatchUi.loadResource(Rez.Strings.hasenseewest) as String;
        case "hauptwilerweiher":
            return WatchUi.loadResource(Rez.Strings.hauptwilerweiher) as String;
        case "hugiweiher":
            return WatchUi.loadResource(Rez.Strings.hugiweiher) as String;
        case "obererbommerweiher":
            return WatchUi.loadResource(Rez.Strings.obererbommerweiher) as String;
        case "marwilermoos":
            return WatchUi.loadResource(Rez.Strings.marwilermoos) as String;
        case "nussbommersee":
            return WatchUi.loadResource(Rez.Strings.nussbommersee) as String;
        case "vagoweiher":
            return WatchUi.loadResource(Rez.Strings.vagoweiher) as String;
        case "wilemersee":
            return WatchUi.loadResource(Rez.Strings.wilemersee) as String;
        case "wistererweiher":
            return WatchUi.loadResource(Rez.Strings.wistererweiher) as String;
        case "garda":
            return WatchUi.loadResource(Rez.Strings.garda) as String;
        case "caldonazzo":
            return WatchUi.loadResource(Rez.Strings.caldonazzo) as String;
    }
    return "No lake";
    
}
(:glance)
function lakeType(lake as String) as String{
    System.println("lakeType");
    for (var i = 0; i < LAKES_3D.size(); i++ ) {
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
            if (lakePosArr != null){
                for (var j = 0; j < lakePosArr.size(); j++ ) {
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
        }
        return minDistName;

    }
    return null;
}

function getLakeByGPS() as String or Null {
    System.println("getLakeByGPS");
    var position_lat_long = getPosition();
    return getClosesLake(position_lat_long);

}


function getPosition() as [Double, Double] or Null{
    System.println("getPosition");
    var info = Position.getInfo();

    // if (info != null){
        if (info.accuracy >= Position.QUALITY_USABLE){
            var position = info.position;
            if (position != null){
                return position.toDegrees();
            }
        }
    return null;
}

(:glance)
function asAlplakeString(time as Time.Moment) as String{
    System.println("asAlplakeString");
    var twoHours = new Time.Duration(2*60*60); // from +2 to UTC
    var gregorianInfo = Gregorian.info(
        time.subtract(twoHours) as Time.Moment,
        Time.FORMAT_SHORT
    );
    var result = 
        gregorianInfo.year.format("%04d") +
        (gregorianInfo.month as Number).format("%02d") + // Number because of Time.FORMAT_SHORT
        gregorianInfo.day.format("%02d") +
        gregorianInfo.hour.format("%02d") +
        gregorianInfo.min.format("%02d")
    ;

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
            asAlplakeString(start.subtract(oneFiveHour) as Time.Moment), // increase timespan
            asAlplakeString(stop.add(oneFiveHour) as Time.Moment) // increase timespan
            ]
            );
    
}

(:glance)
function processReceivedData(data as Dictionary) as [String, Array<String>, Array<Float>, Float] or [String, Array<String>, Array<Float>, Null] or [Null, Null, Null, Null]{
    System.println("processReceivedData");
    var lake;
    if (data.hasKey("lake")){
        lake = data["lake"];

    }else{
        lake = null;
    }


    if (lake == null){
        return [null, null, null, null];
    }else{
        var helper;
        if ((lakeType(lake as String)).equals("1D")){
            helper = processReceivedData1D(data);
        }else{
            helper = processReceivedData3D(data);
        }
        var favouriteTemperatureArray = helper[2];

        if ((favouriteTemperatureArray != null) && (favouriteTemperatureArray.size() > 0)){
            return helper;
            }
        else{
            return [null, null, null, null];
        }
    }
}

(:glance)
function processReceivedData3D(data as Dictionary) as [String, Array<String>, Array<Float>, Float] or [Null, Null, Null, Null]{
    System.println("processReceivedData3D");
    var fail = [null, null, null, null];
    var dataTemperature = data["temperature"];
    if (dataTemperature instanceof Dictionary){
        var favouriteTemperatureArray = dataTemperature["data"] as Array<Float>;
        var lake = data["lake"] as String;
        var distane = data["distance"] as Float or Double or Number;
        var favouriteTimeArray = data["time"]  as Array<String>; // YYYYmmddhhmm
        return [lake, favouriteTimeArray, favouriteTemperatureArray, distane.toFloat()];
    }else{
        return fail;
    }

}

(:glance)
function processReceivedData1D(data as Dictionary) as [String, Array<String>, Array<Float>, Null]  or [Null, Null, Null, Null]{
    System.println("processReceivedData1D");
    var favouriteTemperatureArray = data["T"]  as Array<Float>;
    var favouriteTimeArray = data["time"] as Array<String>; // YYYY-mm-ddThh:mm:ss+00:00
    var lake = data["lake"] as String;

    // overwrite string with format YYYYmmddhhmm
    var s;
    for( var i = 0; i < favouriteTimeArray.size(); i++ ) {
        s = favouriteTimeArray[i];
        if (s.length() >= 16){

            var options = {
                :year   => (s.substring(0, 4) as String).toNumber() as Number,
                :month  => (s.substring(5, 7) as String).toNumber() as Number,
                :day    => (s.substring(8, 10) as String).toNumber() as Number,
                :hour   => (s.substring(11, 13) as String).toNumber() as Number,
                :minute => (s.substring(14, 16) as String).toNumber() as Number
            };

            var momentTmp = Gregorian.moment(options);
            var twoHours     = new Time.Duration(2*60*60); // from +2 to UTC

            favouriteTimeArray[i] = asAlplakeString(momentTmp.add(twoHours));
        }else{
            return  [null, null, null, null];
        }
    }

    return [lake, favouriteTimeArray, favouriteTemperatureArray, null];
}