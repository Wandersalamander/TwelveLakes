import Toybox.Lang;

function maximum(a as Array<Float> or Array<Double> or Array<Number>) as Float or Double or Number {
  var max = a[0];
  for (var i = 1; i < a.size(); i++) {
    if (a[i] > max) {
      max = a[i];
    }
  }
  return max;
}

function minimum(a as Array<Float> or Array<Double> or Array<Number>) as Float or Double or Number {
  var min = a[0];
  for (var i = 1; i < a.size(); i++) {
    if (a[i] < min) {
      min = a[i];
    }
  }
  return min;
}

function mean(a as Array<Float> or Array<Double> or Array<Number>) as Float {
  var mean = 0.0;
  for (var i = 0; i < a.size(); i++) {
    mean += a[i].toFloat();
  }
  return mean / a.size().toFloat();

}


function span(a as Array<Float> or Array<Double> or Array<Number>) as Float or Double or Number {
  return maximum(a) - minimum(a);
}