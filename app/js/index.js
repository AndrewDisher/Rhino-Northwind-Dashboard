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

export function mapLabelFormatter(params, ticket, callback) {
  const value = Math.round(+params.value);
  const formattedValue = value.toLocaleString('en-US');
  const label = `${params.name}: ` + `$${formattedValue}`;
  return (label);
}
