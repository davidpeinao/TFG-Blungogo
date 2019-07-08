/// Example of a combo time series chart with two series rendered as lines, and
/// a third rendered as points along the top line with a different color.
///
/// This example demonstrates a method for drawing points along a line using a
/// different color from the main series color. The line renderer supports
/// drawing points with the "includePoints" option, but those points will share
/// the same color as the line.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Graph(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory Graph.withSampleData(
      Map<String, List<Map<String, dynamic>>> activities, metric) {
    return new Graph(
      _createSampleData(activities, metric),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Configure the default renderer as a line renderer. This will be used
      // for any series that does not define a rendererIdKey.
      //
      // This is the default configuration, but is shown here for  illustration.
      defaultRenderer: new charts.LineRendererConfig(),
      // Custom renderer configuration for the point series.

      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesMetric, DateTime>> _createSampleData(
      Map<String, List<Map<String, dynamic>>> allActivities, String metric) {
    // hacer N listas que sean el nombre de cada user y de valor la lista de actividades
    // para cada lista recorrerla haciendo new TimeSeriesMetric(new DateTime(2017, 9, 19), 5),

    List<String> userNames = allActivities.keys.toList();
    List<List<Map<String, dynamic>>> activitiesByUser =
        allActivities.values.toList();
    List colors = [
      charts.MaterialPalette.blue.shadeDefault,
      charts.MaterialPalette.red.shadeDefault,
      charts.MaterialPalette.green.shadeDefault,
      charts.MaterialPalette.yellow.shadeDefault,
      charts.MaterialPalette.indigo.shadeDefault,
      charts.MaterialPalette.pink.shadeDefault,
      charts.MaterialPalette.purple.shadeDefault
    ];

    List<charts.Series<TimeSeriesMetric, DateTime>> series = [];
    for (var i = 0; i < allActivities.length; i++) {
      List<TimeSeriesMetric> data = [];

      for (var j = 0; j < activitiesByUser[i].length; j++) {
        if (metric != "totalTime") {
          data.add(TimeSeriesMetric(activitiesByUser[i][j]["datetime"],
              double.parse(activitiesByUser[i][j][metric])));
        }
        if (metric == "totalTime") {
          String totalTimeString = activitiesByUser[i][j][metric];
          //digit of hour
          double hours = double.parse(totalTimeString.substring(0, 1));
          // 2 digits of minutes
          double minutes = double.parse(totalTimeString.substring(2, 4));
          // 2 digits of seconds
          double seconds = double.parse(totalTimeString.substring(5, 7));
          //gets total time in minutes
          double totalTimeDouble = (hours * 60) + minutes + (seconds / 60);
          data.add(TimeSeriesMetric(
              activitiesByUser[i][j]["datetime"], totalTimeDouble));
        }
      }
      if (data.isNotEmpty) {
        charts.Series<dynamic, dynamic> serie =
            new charts.Series<TimeSeriesMetric, DateTime>(
          id: userNames[i],
          colorFn: (_, __) => colors[i],
          domainFn: (TimeSeriesMetric metric, _) => metric.time,
          measureFn: (TimeSeriesMetric metric, _) => metric.metric,
          data: data,
          displayName: userNames[i],
        );

        series.add(serie);
      }
    }
    return series;
  }
}

/// Sample time series data type.
class TimeSeriesMetric {
  final DateTime time;
  final double metric;

  TimeSeriesMetric(this.time, this.metric);
}
