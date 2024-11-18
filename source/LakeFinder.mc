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
  "caldonazzo",
];

(:glance)
const POS_LAKES as Dictionary<String, Array<[Float, Float]> > = {
  "upperconstance" => [
    [47.656557, 9.202452],
    [47.696989, 9.201297],
    [47.804525, 9.059257],
    [47.768446, 9.126235],
    [47.731176, 9.198987],
    [47.615031, 9.384969],
    [47.532398, 9.590743],
  ],
  "lowerconstance" => [
    [47.674478, 9.106814],
    [47.703336, 9.074968],
    [47.728333, 9.014134],
    [47.684374, 9.017808],
  ],
  "lucernekreuztrichterandvitznauerbecken" => [
    [47.052699, 8.313514],
    [46.980173, 8.331606],
    [47.079325, 8.434602],
    [47.02, 8.383365],
    [47.000981, 8.467959],
    [47.006403, 8.431383],
  ],
  "lucerneurnersee" => [
    [46.989291, 8.596413],
    [46.901475, 8.608428],
    [46.94721, 8.603658],
  ],
  "lucernegersauerandtreibbecken" => [
    [46.987001, 8.436507],
    [46.994112, 8.467782],
    [46.99146, 8.590052],
    [46.981335, 8.54747],
  ],
  "ageri" => [
    [47.11215964912281, 8.632264912280702],
    [47.13018684210526, 8.600355263157894],
  ],
  "baldegg" => [
    [47.209677966101694, 8.252737288135593],
    [47.18714545454545, 8.269374545454545],
  ],
  "hallwil" => [
    [47.26020428571429, 8.224711428571428],
    [47.30284935064935, 8.20871948051948],
  ],
  "biel" => [
    [47.052538053097344, 7.1082575221238935],
    [47.09583846153846, 7.197237692307692],
  ],
  "brienz" => [
    [46.70712269503546, 7.92788085106383],
    [46.744185925925926, 8.01565037037037],
  ],
  "thun" => [
    [46.715336082474224, 7.663661340206185],
    [46.67426305418719, 7.777210837438424],
  ],
  "geneva" => [
    [46.29984516129032, 6.241835483870968],
    [46.40741714285714, 6.7126971428571425],
    [46.481858536585364, 6.460329268292683],
    [46.446126086956525, 6.871767391304348],
    [46.43632580645161, 6.3133725806451615],
    [46.351530952380955, 6.405621428571429],
    [46.50812608695652, 6.622871739130435],
    [46.261382499999996, 6.162595],
    [46.37620256410256, 6.46725641025641],
    [46.40567435897436, 6.642315384615385],
    [46.39123793103448, 6.859675862068966],
    [46.48273823529412, 6.747532352941176],
    [46.36649069767442, 6.312367441860465],
    [46.346666666666664, 6.211446666666666],
    [46.462740476190476, 6.388576190476191],
    [46.51176829268292, 6.564324390243902],
    [46.396329787234045, 6.785897872340426],
    [46.4099955882353, 6.9152852941176475],
    [46.39995666666667, 6.576793333333334],
    [46.21753148148148, 6.156690740740741],
    [46.49928571428571, 6.688721428571428],
    [46.2552511627907, 6.199867441860465],
    [46.35566956521739, 6.357778260869566],
    [46.39050847457627, 6.262252542372882],
    [46.297678125, 6.177140625],
    [46.50930204081633, 6.504312244897959],
    [46.33578378378378, 6.268191891891892],
    [46.467018604651166, 6.8172139534883724],
    [46.400412903225806, 6.516064516129032],
  ],
  "greifensee" => [
    [47.33376231884058, 8.693240579710144],
    [47.36238709677419, 8.667212903225806],
  ],
  "gruyere" => [
    [46.648660591133, 7.093696551724138],
    [46.69477361111111, 7.10333425925926],
  ],
  "klontalersee" => [
    [47.02279433962264, 8.960694339622641],
    [47.030316279069766, 8.99372558139535],
  ],
  "joux" => [
    [46.65367551020408, 6.315473469387755],
    [46.622999019607846, 6.2605627450980394],
  ],
  "maggiore" => [
    [45.734466197183096, 8.597952112676056],
    [46.100592647058825, 8.719256617647059],
    [45.964175, 8.65540925925926],
    [45.78801851851852, 8.564254320987654],
    [46.15927643312102, 8.851928662420383],
    [45.92212946428572, 8.511626785714286],
    [46.0239944, 8.722864],
    [46.144278991596636, 8.787471428571429],
    [45.84002276422764, 8.603951219512195],
    [45.9094803030303, 8.585855303030304],
  ],
  "zurich" => [
    [47.24801118881119, 8.663417482517483],
    [47.210938582677166, 8.880925984251968],
    [47.319588732394365, 8.568010563380282],
    [47.2171914893617, 8.776913829787235],
  ],
  "lungern" => [
    [46.807918, 8.168344],
    [46.79043333333333, 8.15599649122807],
  ],
  "murten" => [
    [46.92289803921569, 7.052571568627451],
    [46.94061404958678, 7.106917355371901],
  ],
  "neuchatel" => [
    [46.795896875, 6.6525765625],
    [46.88353965517241, 6.8880275862068965],
    [46.9957445945946, 6.9499],
    [46.83171052631579, 6.742090789473684],
    [46.94900638297872, 6.862751063829787],
    [46.90161212121212, 6.790162121212121],
    [46.98323214285714, 7.022924107142857],
    [46.84160166666667, 6.820876666666667],
    [46.925071875, 6.95605],
    [46.81911052631579, 6.693452631578947],
  ],
  "pfaffikon" => [
    [47.35702142857143, 8.774104761904763],
    [47.34594181818182, 8.787512727272727],
  ],
  "sempach" => [
    [47.13080579710145, 8.174986956521739],
    [47.16345348837209, 8.13003023255814],
  ],
  "sarnen" => [
    [46.856424137931036, 8.20034827586207],
    [46.87837049180328, 8.233426229508197],
  ],
  "alpnachersee" => [
    [46.957424561403506, 8.294984210526316],
    [46.97133404255319, 8.327527659574468],
  ],
  "lugano" => [
    [45.95392762645914, 8.925656809338522],
    [46.015803846153844, 9.064403846153846],
  ],
  "walensee" => [
    [47.122197435897434, 9.258533333333334],
    [47.129661363636366, 9.145244696969698],
  ],
  "zug" => [
    [47.09612464788732, 8.497245070422535],
    [47.157630857142856, 8.480476],
  ],
  "sihlsee" => [
    [47.09787291666667, 8.801692708333333],
    [47.13890545454545, 8.779442727272727],
  ],
  "poschiavo" => [
    [46.278667741935486, 10.095916129032258],
    [46.290425, 10.0867],
  ],
  "sils" => [
    [46.41262881355932, 9.721818644067797],
    [46.4269171875, 9.746378125],
  ],
  "silvaplana" => [
    [46.44177222222222, 9.781836111111112],
    [46.45234333333333, 9.799009999999999],
  ],
  "stmoritz" => [
    [46.492515789473686, 9.839894736842105],
    [46.49558260869565, 9.850643478260869],
  ],
  "champfer" => [
    [46.470753333333334, 9.809146666666667],
    [46.464603125000004, 9.802059375],
  ],
  "lauerz" => [
    [47.03179069767442, 8.61243488372093],
    [47.0386, 8.592165217391305],
  ],
  "rotsee" => [
    [47.065553333333334, 8.30466],
    [47.07223529411765, 8.319764705882353],
  ],
  "turlersee" => [
    [47.27142352941176, 8.499394117647059],
    [47.2658, 8.506870588235294],
  ],
  "amsoldingersee" => [
    [46.72275, 7.5772055555555555],
    [46.72665833333333, 7.572175],
  ],
  "moossee" => [
    [47.02109411764706, 7.48354705882353],
    [47.02364285714286, 7.476628571428571],
  ],
  "mauensee" => [
    [47.169066666666666, 8.072773333333334],
    [47.17242380952381, 8.0793],
  ],
  "oeschinensee" => [
    [46.497280952380954, 7.7316714285714285],
    [46.498844, 7.717824],
  ],
  "soppensee" => [
    [47.08827142857143, 8.082728571428571],
    [47.091833333333334, 8.0789],
  ],
  "inkwilersee" => [
    [47.19928387096774, 7.66478064516129],
    [47.197553125, 7.6615343750000005],
  ],
  "huttwilersee" => [
    [47.609508695652174, 8.844108695652174],
    [47.61333333333333, 8.834791666666666],
  ],
  "cadagno" => [
    [46.549854545454544, 8.709227272727272],
    [46.550489999999996, 8.71524],
  ],
  "husemersee" => [
    [47.621741666666665, 8.706358333333332],
    [47.62166923076923, 8.703023076923076],
  ],
  "huttnersee" => [
    [47.18336363636364, 8.677227272727272],
    [47.18310434782609, 8.671052173913044],
  ],
  "lutzelsee" => [
    [47.261227777777776, 8.775566666666666],
    [47.259211111111114, 8.769966666666667],
  ],
  "mettmenhaslisee" => [
    [47.4745, 8.492266666666668],
    [47.474, 8.490881818181819],
  ],
  "egelsee" => [
    [47.2578, 8.819673076923078],
    [47.25716666666666, 8.816558333333333],
  ],
  "untererchatzensee" => [
    [47.43195, 8.493366666666667],
    [47.43155384615385, 8.487761538461537],
  ],
  "seeweidsee" => [
    [47.25700833333333, 8.746466666666667],
    [47.256684615384614, 8.745546153846155],
  ],
  "burgaschisee" => [
    [47.16956, 7.67068],
    [47.17, 7.666418181818182],
  ],
  "burgseeli" => [
    [46.697545454545455, 7.886981818181818],
    [46.6976875, 7.88441875],
  ],
  "dittligsee" => [
    [46.75643636363636, 7.535327272727272],
    [46.75569333333333, 7.532226666666666],
  ],
  "gerzensee" => [
    [46.827694736842105, 7.5459],
    [46.83289166666667, 7.548608333333333],
  ],
  "lobsigensee" => [
    [47.03067142857143, 7.298842857142858],
    [47.03065, 7.29745],
  ],
  "chlimoossee" => [
    [47.026675, 7.46965],
    [47.0264, 7.468563636363636],
  ],
  "uebeschisee" => [
    [46.733085714285714, 7.566757142857143],
    [46.73504444444444, 7.563244444444444],
  ],
  "bret" => [
    [46.51801666666667, 6.776277777777778],
    [46.509766666666664, 6.770733333333333],
  ],
  "brenet" => [
    [46.67590714285714, 6.327742857142857],
    [46.66861176470588, 6.3204705882352945],
  ],
  "chavonnes" => [
    [46.33332941176471, 7.08735294117647],
    [46.33293571428571, 7.084421428571428],
  ],
  "bretaye" => [
    [46.3256875, 7.07310625],
    [46.326679999999996, 7.0708],
  ],
  "lioson" => [
    [46.386405555555555, 7.1305555555555555],
    [46.386126315789475, 7.127852631578947],
  ],
  "tome" => [
    [46.362547368421055, 8.690784210526315],
    [46.36408095238095, 8.688861904761904],
  ],
  "barone" => [
    [46.40145, 8.7531875],
    [46.40265, 8.750766666666667],
  ],
  "superiore" => [
    [46.476685714285715, 8.5872],
    [46.47534375, 8.583525],
  ],
  "sassolo" => [
    [46.47655555555556, 8.594488888888888],
    [46.47594545454545, 8.591927272727272],
  ],
  "geistsee" => [
    [46.76079, 7.53496],
    [46.761587500000005, 7.5348375],
  ],
  "lenkerseeli" => [
    [46.449172727272725, 7.442618181818182],
    [46.44750833333333, 7.443533333333333],
  ],
  "stockseewli" => [
    [46.600185714285715, 8.325092857142858],
    [46.6002625, 8.324349999999999],
  ],
  "oberesbanzlauiseeli" => [
    [46.692624, 8.286868],
    [46.692996, 8.285536],
  ],
  "barchetsee" => [
    [47.61523636363636, 8.753672727272727],
    [47.61546428571429, 8.752742857142858],
  ],
  "bichelsee" => [
    [47.45778333333333, 8.901858333333333],
    [47.45734074074074, 8.898385185185186],
  ],
  "hasenseeost" => [
    [47.6066375, 8.8336625],
    [47.607549999999996, 8.830207142857143],
  ],
  "hasenseewest" => [
    [47.607976923076926, 8.828307692307693],
    [47.60853, 8.82641],
  ],
  "hauptwilerweiher" => [
    [47.480051612903225, 9.25486129032258],
    [47.479866666666666, 9.257462499999999],
  ],
  "hugiweiher" => [
    [47.57148611111111, 8.858116666666668],
    [47.57143888888889, 8.860330555555556],
  ],
  "obererbommerweiher" => [
    [47.61762888888889, 9.15945111111111],
    [47.61895581395349, 9.155353488372093],
  ],
  "marwilermoos" => [
    [47.53868536585366, 9.075043902439024],
    [47.538680487804875, 9.073373170731708],
  ],
  "nussbommersee" => [
    [47.61516470588235, 8.820711764705882],
    [47.615226, 8.813954],
  ],
  "vagoweiher" => [
    [47.58600454545454, 9.03055909090909],
    [47.58565, 9.028953846153847],
  ],
  "wilemersee" => [
    [47.60003333333333, 8.799725],
    [47.59995, 8.798466666666666],
  ],
  "wistererweiher" => [
    [47.58204705882353, 9.055711764705881],
    [47.58233333333333, 9.054023809523809],
  ],
  "garda" => [
    [45.806668055555555, 10.791318055555555],
    [45.564154437869824, 10.564620710059172],
    [45.65761315789474, 10.72369605263158],
    [45.523967368421054, 10.724995789473684],
    [45.45874393939394, 10.642948484848485],
    [45.7119, 10.7693875],
    [45.821521705426356, 10.843890697674418],
    [45.49119160839161, 10.53384895104895],
    [45.68009324324324, 10.658204054054053],
    [45.86737748344371, 10.854372185430464],
    [45.63623614457831, 10.606051807228916],
    [45.589195454545454, 10.68813787878788],
    [45.60525350877193, 10.542714912280701],
    [45.45580900900901, 10.699424324324324],
    [45.480665333333334, 10.602148666666666],
    [45.76235222222222, 10.757023333333333],
    [45.76425, 10.807513265306122],
    [45.720910294117644, 10.7109],
  ],
  "caldonazzo" => [
    [46.008802985074624, 11.251864179104478],
    [46.02923048780488, 11.237046341463415],
  ],
};

(:glance)
function readableLakeName(lake as String?) as String {
  // generated code because monkey c does not allow getting the resource by string..
  if (lake == null) {
    return "No lake";
  }
  switch (lake) {
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
      return (
        WatchUi.loadResource(
          Rez.Strings.lucernekreuztrichterandvitznauerbecken
        ) as String
      );
    case "lucerneurnersee":
      return WatchUi.loadResource(Rez.Strings.lucerneurnersee) as String;
    case "lucernegersauerandtreibbecken":
      return (
        WatchUi.loadResource(Rez.Strings.lucernegersauerandtreibbecken) as
        String
      );
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
function lakeType(lake as String) as String {
  System.println("lakeType");
  for (var i = 0; i < LAKES_3D.size(); i++) {
    if (LAKES_3D[i].equals(lake)) {
      return "3D";
    }
  }
  return "1D";
}

function getClosesLake(position_lat_long as [Double, Double]?) as String? {
  System.println("getClosesLake");
  var minDistVal = (10000).toDouble();
  var minDistName = null;
  var keys = POS_LAKES.keys();

  if (position_lat_long != null) {
    for (var i = 0; i < keys.size(); i++) {
      var lakePosArr = POS_LAKES[keys[i]];
      if (lakePosArr != null) {
        for (var j = 0; j < lakePosArr.size(); j++) {
          var lakePos = lakePosArr[j];

          var dx = lakePos[0] - position_lat_long[0];
          var dy = lakePos[1] - position_lat_long[1];

          var distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < minDistVal) {
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

function getLakeByGPS() as String? {
  System.println("getLakeByGPS");
  var position_lat_long = getPosition();
  return getClosesLake(position_lat_long);
}

function getPosition() as [Double, Double]? {
  System.println("getPosition");
  var info = Position.getInfo();

  // if (info != null){
  System.println(info.accuracy);
  System.println(Position.QUALITY_USABLE);
  if (info.accuracy >= Position.QUALITY_LAST_KNOWN) {
    var position = info.position;
    if (position != null) {
      return position.toDegrees();
    }
  }
  return null;
}

(:glance)
function asAlplakeString(time as Time.Moment) as String {
  System.println("asAlplakeString");
  var twoHours = new Time.Duration(2 * 60 * 60); // from +2 to UTC
  var gregorianInfo = Gregorian.info(
    time.subtract(twoHours) as Time.Moment,
    Time.FORMAT_SHORT
  );
  var result =
    gregorianInfo.year.format("%04d") +
    (gregorianInfo.month as Number).format("%02d") + // Number because of Time.FORMAT_SHORT
    gregorianInfo.day.format("%02d") +
    gregorianInfo.hour.format("%02d") +
    gregorianInfo.min.format("%02d");

  return result;
}

(:glance)
function alplakesApiString(
  lake as String,
  start as Time.Moment,
  stop as Time.Moment,
  position as [Double, Double] or Array<Double>
) as String {
  System.println("alplakesApiString");

  if (lakeType(lake).equals("1D")) {
    return alplakesApiString1DLake(lake, start, stop);
  } else {
    return alplakesApiString3DLake(lake, start, stop, position);
  }
}

(:glance)
function alplakesApiString3DLake(
  lake as String,
  start as Time.Moment,
  stop as Time.Moment,
  position as [Double, Double] or Array<Double>
) as String {
  System.println("alplakesApiString3DLake");

  return Lang.format(
    "https://alplakes-api.eawag.ch/simulations/point/delft3d-flow/$1$/$2$/$3$/1/$4$/$5$",
    [
      lake,
      asAlplakeString(start),
      asAlplakeString(stop),
      position[0],
      position[1],
    ]
  );
}

(:glance)
function alplakesApiString1DLake(
  lake as String,
  start as Time.Moment,
  stop as Time.Moment
) as String {
  System.println("alplakesApiString1DLake");

  var oneFiveHour = new Time.Duration(90 * 60);

  return Lang.format(
    "https://alplakes-api.eawag.ch/simulations/1d/point/simstrat/$1$/$2$/$3$/1?variables=T",
    [
      lake,
      asAlplakeString(start.subtract(oneFiveHour) as Time.Moment), // increase timespan
      asAlplakeString(stop.add(oneFiveHour) as Time.Moment), // increase timespan
    ]
  );
}

(:glance)
function processReceivedData(
  lake as String, data as Dictionary
) as [String, Array<String>, Array<Float>, Float] or
  [String, Array<String>, Array<Float>, Null] or
  [Null, Null, Null, Null] {
  System.println("processReceivedData");
  var helper;
  if (lakeType(lake as String).equals("1D")) {
    helper = processReceivedData1D(lake, data);
  } else {
    helper = processReceivedData3D(lake, data);
  }
  var favouriteTemperatureArray = helper[2];

  if (
    favouriteTemperatureArray != null &&
    favouriteTemperatureArray.size() > 0
  ) {
    return helper;
  } else {
    return [null, null, null, null];
  }

}

(:glance)
function processReceivedData3D(
  lake as String, data as Dictionary
) as [String, Array<String>, Array<Float>, Float] or [Null, Null, Null, Null] {
  System.println("processReceivedData3D");
  var fail = [null, null, null, null];
  var dataTemperature = data["variables"]["temperature"];
  if (dataTemperature instanceof Dictionary) {
    var favouriteTemperatureArray = dataTemperature["data"] as Array<Float>;
    var distane = data["distance"]["data"] as Float or Double or Number;
    var favouriteTimeArray = data["time"] as Array<String>; // YYYYmmddhhmm
    return [
      lake,
      favouriteTimeArray,
      favouriteTemperatureArray,
      distane.toFloat(),
    ];
  } else {
    return fail;
  }
}

(:glance)
function processReceivedData1D(
  lake as String, data as Dictionary
) as [String, Array<String>, Array<Float>, Null] or [Null, Null, Null, Null] {
  System.println("processReceivedData1D");
  var favouriteTemperatureArray = data["variables"]["T"]["data"] as Array<Float>;
  var favouriteTimeArray = data["time"] as Array<String>; // YYYY-mm-ddThh:mm:ss+00:00
  //var lake = data["lake"] as String;

  // overwrite string with format YYYYmmddhhmm
  var s;
  for (var i = 0; i < favouriteTimeArray.size(); i++) {
    s = favouriteTimeArray[i];
    if (s.length() >= 16) {
      var options = {
        :year => (s.substring(0, 4) as String).toNumber() as Number,
        :month => (s.substring(5, 7) as String).toNumber() as Number,
        :day => (s.substring(8, 10) as String).toNumber() as Number,
        :hour => (s.substring(11, 13) as String).toNumber() as Number,
        :minute => (s.substring(14, 16) as String).toNumber() as Number,
      };

      var momentTmp = Gregorian.moment(options);
      var twoHours = new Time.Duration(2 * 60 * 60); // from +2 to UTC

      favouriteTimeArray[i] = asAlplakeString(momentTmp.add(twoHours));
    } else {
      return [null, null, null, null];
    }
  }

  return [lake, favouriteTimeArray, favouriteTemperatureArray, null];
}
