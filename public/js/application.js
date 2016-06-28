$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
      google.charts.load('current', {'packages':['gauge']});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart(newScore) {

        var data = google.visualization.arrayToDataTable([
          ['Label', 'Value'],
          ['Score', parseInt(newScore || 0)],
        ]);

        var options = {
          width: 900, height: 263,
          redFrom: -50, redTo: -17,
          yellowFrom:-16, yellowTo: 16,
          greenFrom: 17, greenTo: 50,
          min: -50,
          max: 50,
          minorTicks: 5
        };

        var chart = new google.visualization.Gauge(document.getElementById('chart_div'));

        data.setValue(0, 1, ((newScore || 0) * 100));
        chart.draw(data, options);
      }


      var ajax_call = function() {
        var request = $.ajax({
          url: '/tweets',
          type: 'GET'
        }) // end ajax request
        request.done(function(JSONResponse) {
          console.log(JSONResponse)
          drawChart(JSONResponse.average_score);
          $('.last-tweet').text(JSONResponse.latest_tweet[0].body)
        })
      };


    setInterval(ajax_call, 2000);


  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

});
