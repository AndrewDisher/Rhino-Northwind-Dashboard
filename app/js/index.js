// Formats the values that appear to the right of horizontal bars
export function barChartFormatter(params) {
  const myValue = Math.round(+params.value[0]);
  const formattedValue = `$${myValue.toLocaleString('en-US')}`;
  return (formattedValue);
}

// Formats the values that appear in the `on hover` tooltip
export function barChartTooltip(params) {
  const proportion = Math.round((+params.name + Number.EPSILON) * 1000) / 10;
  const tooltip = `${params.marker + params.value[1]}: ` + `<strong>${
    proportion}%` + '</strong>';
  return (tooltip);
}

// Formats the `on click` label for map
export function mapLabelFormatter(params, ticket, callback) {
  const value = Math.round(+params.value);
  const formattedValue = value.toLocaleString('en-US');
  const label = `${params.name}: ` + `$${formattedValue}`;
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
  return(params.marker + params.value[0] + ': ' + 
  '<strong>' + params.value[1] + '</strong>' + ' days')
}
