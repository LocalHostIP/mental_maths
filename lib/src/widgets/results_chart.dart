import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/results.dart';

class ResultsChart {
  Results results;
  late List<charts.Series<ResultDataSeries, String>> _seriesPieData;
  late List<charts.Series<ResultDataSeries, String>> _seriesBarData;

  ResultsChart(this.results);

  void _generatePieData() {
    /*
    _seriesPieData = [];
    var data = [
      new ResultDataSeries(
          type: 'Work',
          average: 30,
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      new ResultDataSeries(
          type: 'Work 2',
          average: 50,
          barColor: charts.ColorUtil.fromDartColor(Colors.red)),
      new ResultDataSeries(
          type: 'Work 3',
          average: 20,
          barColor: charts.ColorUtil.fromDartColor(Colors.green)),
    ];
    _seriesPieData.add(charts.Series(
      id: 'Results Pie',
      data: data,
      domainFn: (_seriesData, _) => _seriesData.type,
      measureFn: (_seriesData, _) => _seriesData.average,
      colorFn: (_seriesData, _) => _seriesData.barColor,
      labelAccessorFn: (_seriesData, index) => _seriesData.average.toString(),
    ));
    * */
  }

  void _generateBarData(String type, int level) {
    _seriesBarData = [];
    OpRegister result = results.addition[level];

    if (type == MathProblems.OPSub) result = results.subtraction[level];
    var data1 = [
      new ResultDataSeries(
          type: 'Last ' + Results.nv2.toString(),
          average: result.promV2,
          record: result.recordV2,
          difference: result.getDifferenceV2()),
      new ResultDataSeries(
          type: 'Last ' + Results.nv3.toString(),
          average: result.promV3,
          record: result.recordV3,
          difference: result.getDifferenceV3()),
      new ResultDataSeries(
          type: 'Total',
          average: result.promTotal,
          record: 0,
          difference: result.getDifference()),
    ];
    var data2 = [
      new ResultDataSeries(
        type: 'Last ' + Results.nv2.toString(),
        difference: result.getDifferenceV2(),
        average: result.promV2,
        isDifference: true,
      ),
      new ResultDataSeries(
          type: 'Last ' + Results.nv3.toString(),
          difference: result.getDifferenceV3(),
          average: result.promV3,
          isDifference: true),
      new ResultDataSeries(
          type: 'Total',
          difference: result.getDifference(),
          average: result.promTotal,
          isDifference: true)
      ,
    ];
    var data3 = [
      new ResultDataSeries(
          type: 'Last ' + Results.nv2.toString(),
          average: result.promV2,
          record: result.recordV2,
          difference: result.getDifferenceV2()),
      new ResultDataSeries(
          type: 'Last ' + Results.nv3.toString(),
          average: result.promV3,
          record: result.recordV3,
          difference: result.getDifferenceV3()),
    ];
    _seriesBarData.add(charts.Series(
        id: 'Difference',
        data: data2,
        domainFn: (_seriesData, _) => _seriesData.type,
        measureFn: (_seriesData, _) => _seriesData.getValue(),
        colorFn: (_seriesData, _) => _seriesData.getColor(),
        labelAccessorFn: (_seriesData, index) => _seriesData.getLabel(),
        fillPatternFn: (_seriesData, _) => _seriesData.getPatternType(),
        fillColorFn: (_seriesData, _) => _seriesData.getColor()));

    _seriesBarData.add(charts.Series(
        id: 'Average',
        data: data1,
        domainFn: (_seriesData, _) => _seriesData.type,
        measureFn: (_seriesData, _) => _seriesData.getValue(),
        colorFn: (_seriesData, _) => _seriesData.getColor(),
        labelAccessorFn: (_seriesData, index) => _seriesData.getLabel(),
        fillPatternFn: (_seriesData, _) => _seriesData.getPatternType(),
        fillColorFn: (_seriesData, _) => _seriesData.getColor()));

    _seriesBarData.add(charts.Series(
      id: 'Record',
      data: data3,
      domainFn: (_seriesData, _) => _seriesData.type,
      measureFn: (_seriesData, _) => _seriesData.record,
      displayName: 'hola',
      labelAccessorFn: (_seriesData, _) => _seriesData.record.toString()
    )..setAttribute(charts.rendererIdKey, 'RecordLine'));
  }

  Widget getBarChart(String type, int level) {
    _generateBarData(type, level);
    return Expanded(
        child: charts.BarChart(
      _seriesBarData,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      animationDuration: Duration(seconds: 1),
      barRendererDecorator: new charts.BarLabelDecorator(
        insideLabelStyleSpec: new charts.TextStyleSpec(
            fontSize: 12,
            fontFamily: 'Georgia',
            color: charts.MaterialPalette.white),
        outsideLabelStyleSpec: new charts.TextStyleSpec(
            fontSize: 12,
            fontFamily: 'Georgia',
            color: charts.MaterialPalette.black),
        labelPosition: charts.BarLabelPosition.inside,
        labelAnchor: charts.BarLabelAnchor.middle,
      ),

      customSeriesRenderers: [
        new charts.BarTargetLineRendererConfig<String>(
            //Id used
            customRendererId: 'RecordLine',
            groupingType: charts.BarGroupingType.grouped,
            roundEndCaps: true,
        ),
      ],
    ));
  }

  Widget getPieChart() {
    return charts.PieChart(
      _seriesPieData,
      animate: true,
      animationDuration: Duration(seconds: 1),
      behaviors: [
        new charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.white,
              fontFamily: 'Georgia',
              fontSize: 11),
        )
      ],
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 100,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside)
          ]),
    );
  }
}

class ResultDataSeries {
  final String type;
  final double average;
  double difference = 0;
  bool isDifference;
  double record = 50;

  ResultDataSeries({
    required this.type,
    required this.average,
    this.isDifference = false,
    this.difference = 0,
    this.record = 0,
  });

  String getLabel() {
    if (isDifference)
      return '';
    else
      return average.toString();
  }

  charts.FillPatternType getPatternType() {
    if (isDifference) {
      if (difference > 0)
        return charts.FillPatternType.solid;
      else
        return charts.FillPatternType.forwardHatch;
    } else
      return charts.FillPatternType.solid;
  }

  charts.Color getColor() {
    if (!isDifference)
      return charts.ColorUtil.fromDartColor(Colors.blue);
    else {
      if (difference > 0)
        return charts.ColorUtil.fromDartColor(Colors.red);
      else
        return charts.ColorUtil.fromDartColor(Colors.green);
    }
  }

  double getValue() {
    if (isDifference)
      if(difference==average)
        return 0;
      else
        return difference.abs();
    else {
      if(difference==average)
        return average;
      else{
        if (difference > 0)
          return average - difference;
        else
          return average;
      }
    }
  }
}
