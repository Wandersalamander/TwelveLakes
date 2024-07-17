function maximum(a){
  var max = a[0];
  for (var i = 1; i < a.size(); i++) {
    if (a[i] > max) {
      max = a[i];
    }
  }
  return max;
}

function minimum(a){
  var min = a[0];
  for (var i = 1; i < a.size(); i++) {
    if (a[i] < min) {
      min = a[i];
    }
  }
  return min;
}

function mean(a){
  var mean = 0.0;
  for (var i = 0; i < a.size(); i++) {
    mean += a[i];
  }
  return mean / a.size();

}


function span(a){
  return maximum(a) - minimum(a);
}