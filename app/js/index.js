// Formats the values that appear to the right of horizontal bars
export function barChartFormatter(params) {
  var myValue = Math.round(+params.value[0]);
  var formattedValue = `$${myValue.toLocaleString('en-US')}`;
  return (formattedValue);
}

// Formats the values that appear in the `on hover` tooltip
export function barChartTooltip(params) {
  var proportion = Math.round((+params.name + Number.EPSILON) * 1000) / 10;
  var tooltip = `${params.marker + params.value[1]}: ` + `<strong>${
    proportion}%` + '</strong>';
  return (tooltip);
}

// Formats the label for map
export function mapLabelFormatter(params, ticket, callback) {
  var value = Math.round(+params.value);
  
  if(value >= 0) {
    var formattedValue = value.toLocaleString('en-US');
    var label = `${params.name}: ` + `$${formattedValue}`;
  } else {
    var label = 'No Orders Placed';
  }
  
  return (label);
}

// Sets the value of the shiny input; this functionality results in different content 
// being displayed in the modal for the table of products `Details` modal.
export function getId(clicked_id) {
  console.log(clicked_id);
  Shiny.setInputValue('app-tab_product_inventory-table_of_products-button_id', clicked_id, {priority: 'event'});
}

// Format the tooltip for the product lead time bar chart
export function formatLeadTimeTooltip(params) {
  var overallAvg = +params.name;
  var tooltip = params.marker + params.value[0] + ': ' + '<strong>' + params.value[1] + '</strong>' + ' days' + 
  '<br />Overall Average: ' + '<strong>' + overallAvg + '</strong>' + ' days';
  
  return(tooltip)
}
