$(function() {
  var word_array = $('#wordcloud').data('word-array');
  $('#wordcloud').jQCloud(word_array, {
    encodeURI: false
  });
});


$(this).on('shown.bs.tab', function (e) {
    var types = $('ul.nav-tabs li.active a').attr("data-identifier");
    var typesArray = types.split(",");
    $.each(typesArray, function (key, value) {
        eval(value + ".redraw()");
    })
});

$(function () {
  var m_names;
  m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");


  usline =  Morris.Line({
      element: 'us_rankings_chart',
      data: $('#us_rankings_chart').data('rankings'),
      xkey: 'pulldate',
      ykeys: ['topfree', 'topfreegames', 'toppaid', 'toppaidgames'],
      labels: ['Top Free', 'Top Free Games', 'Top Paid', 'Top Paid Games'],
      yLabelFormat: function(y) {
        return -y;
      },
      ymax: -1,
      ymin: -200,
      xLabels: "day",
      xLabelFormat: function(x) {
        return m_names[x.getMonth()] + ' ' + x.getDate() + ', ' + x.getFullYear();
      },
      hideHover: 'auto',
      hoverCallback: function(index, options, content, row) {
        return options.data[index].hoverstring;
      },
      pointSize: 0
    });
  $(function() {
    return usline;
  });

  auline = Morris.Line({
      element: 'au_rankings_chart',
      data: $('#au_rankings_chart').data('rankings'),
      xkey: 'pulldate',
      ykeys: ['topfree', 'topfreegames', 'toppaid', 'toppaidgames'],
      labels: ['Top Free', 'Top Free Games', 'Top Paid', 'Top Paid Games'],
      yLabelFormat: function(y) {
        return -y;
      },
      ymax: -1,
      ymin: -200,
      xLabels: "day",
      xLabelFormat: function(x) {
        return m_names[x.getMonth()] + ' ' + x.getDate() + ', ' + x.getFullYear();
      },
      hideHover: 'auto',
      hoverCallback: function(index, options, content, row) {
        return options.data[index].hoverstring;
      },
      pointSize: 0
    });
  $(function() {
    return auline
  });

  caline = Morris.Line({
      element: 'ca_rankings_chart',
      data: $('#ca_rankings_chart').data('rankings'),
      xkey: 'pulldate',
      ykeys: ['topfree', 'topfreegames', 'toppaid', 'toppaidgames'],
      labels: ['Top Free', 'Top Free Games', 'Top Paid', 'Top Paid Games'],
      yLabelFormat: function(y) {
        return -y;
      },
      ymax: -1,
      ymin: -200,
      xLabels: "day",
      xLabelFormat: function(x) {
        return m_names[x.getMonth()] + ' ' + x.getDate() + ', ' + x.getFullYear();
      },
      hideHover: 'auto',
      hoverCallback: function(index, options, content, row) {
        return options.data[index].hoverstring;
      },
      pointSize: 0
    });
  $(function() {
    return caline
  });

  ukline = Morris.Line({
      element: 'uk_rankings_chart',
      data: $('#uk_rankings_chart').data('rankings'),
      xkey: 'pulldate',
      ykeys: ['topfree', 'topfreegames', 'toppaid', 'toppaidgames'],
      labels: ['Top Free', 'Top Free Games', 'Top Paid', 'Top Paid Games'],
      yLabelFormat: function(y) {
        return -y;
      },
      ymax: -1,
      ymin: -200,
      xLabels: "day",
      xLabelFormat: function(x) {
        return m_names[x.getMonth()] + ' ' + x.getDate() + ', ' + x.getFullYear();
      },
      hideHover: 'auto',
      hoverCallback: function(index, options, content, row) {
        return options.data[index].hoverstring;
      },
      pointSize: 0
    });
  $(function() {
    return ukline
  });  

});