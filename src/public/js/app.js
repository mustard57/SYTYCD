var config = {
  height: 300
};

var charts = [
  {
    id: "lists",
    name: "Lists",
    facet: "list",
    type: "pie"
  },

  {
    id: "authors",
    name: "Authors",
    facet: "author",
    type: "spline"
  }
];

/**
 * Refreshes the contents of a chart via ajax
 */
function refreshChart(facet) {
  var chart = this;
  $.ajax({
    url: "charts.json",
    data: {
      facet: facet,
      q: $('#current-query').val()
    },
    cache: false,
    dataType: "json",
    success: function (data) {
      var d, i, sd = [], categories = [];
      if (data.series) {
        for (i = 0; i < data.series.length; i++) {
          d = data.series[i];
          sd.push(d);
          categories.push(d.name);
        }
      }
      chart.series[0].setData(sd, false);
      chart.xAxis[0].setCategories(categories, false);
      chart.redraw();
    }
  });
}

/**
 * When a user clicks on a chart value update the constraints applied
 */
function handleClick(event) {
  var query = $('#current-query').val();
  var q = [];
  if (query && query.length > 0) {
    q.push(query);
  }
  q.push(event.currentTarget.series.name + ":" + event.currentTarget.name);
  window.location = "?q=" + q.join(" ");
}

/**
 * Creates a new highcharts chart
 */
function newChart(params) {
  var options = {
    chart: {
      renderTo: params.id,
      type: params.type,
      height: config.height
    },
    title: {
      text: params.name
    },
    xAxis: {
      labels: {
        rotation: -45,
        align: 'right'
      }
    },
    yAxis: {
      title: {
        text: 'Count'
      }
    },
    legend: {
      enabled: false
    },
    series:[{
      name: params.facet,
      data: [],
      cursor: 'pointer',
      point: {
        events: {
          click: handleClick
        }
      }
    }]
  };

  var chart = new Highcharts.Chart(options);
  chart.refresh = refreshChart;
  return chart;
}

$(document).ready(function() {
  if ($('#charts')) {
    var i;
    for (i in charts) {
      var chartData = charts[i];
      $('#charts').append('<div class="chart-wrapper"><div id="' + chartData.id + '"></div></div>');

      newChart(chartData).refresh(chartData.facet);
    }
  }
});