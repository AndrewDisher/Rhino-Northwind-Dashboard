// Formats the values that appear to the right of horizontal bars
export function barChartFormatter(params) {
  var myValue = Math.round(+params.value[0]);
  var formattedValue = '$' + myValue.toLocaleString('en-US');
  return(formattedValue)
}

// Formats the values that appear in the `on hover` tooltip
export function barChartTooltip(params) {
  var proportion = Math.round((+params.name + Number.EPSILON) * 1000) / 10;
  var tooltip = params.marker + params.value[1] + ': ' + '<strong>' + 
  proportion + '%' + '</strong>';
  return(tooltip)
}