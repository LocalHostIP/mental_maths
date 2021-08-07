import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';

class ResultsChart {
  Save _results;
  late List<charts.Series<ResultDataSeries, String>> _seriesBarData;

  ResultsChart(this._results);

  void _generateCurrentLevelData(String type, int level) {
    _seriesBarData = [];
    OperationRegister result = _results.addition[level];

    if (type == MathProblems.OPSub) result = _results.subtraction[level];
    var data1 = [
      new ResultDataSeries(
          type: 'Last ' + Save.nLast1.toString(),
          average: result.aveV2,
          record: result.recordV2,
          difference: result.getDifferenceV2()),
      new ResultDataSeries(
          type: 'Last ' + Save.nLast2.toString(),
          average: result.aveV3,
          record: result.recordV3,
          difference: result.getDifferenceV3()),
      new ResultDataSeries(
          type: 'Total',
          average: result.aveTotal,
          record: 0,
          difference: result.getDifference()),
    ];
    var data2 = [
      new ResultDataSeries(
        type: 'Last ' + Save.nLast1.toString(),
        difference: result.getDifferenceV2(),
        average: result.aveV2,
        isDifference: true,
      ),
      new ResultDataSeries(
          type: 'Last ' + Save.nLast2.toString(),
          difference: result.getDifferenceV3(),
          average: result.aveV3,
          isDifference: true),
      new ResultDataSeries(
          type: 'Total',
          difference: result.getDifference(),
          average: result.aveTotal,
          isDifference: true)
      ,
    ];
    var data3 = [
      new ResultDataSeries(
          type: 'Last ' + Save.nLast1.toString(),
          average: result.aveV2,
          record: result.recordV2,
          difference: result.getDifferenceV2()),
      new ResultDataSeries(
          type: 'Last ' + Save.nLast2.toString(),
          average: result.aveV3,
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
    _generateCurrentLevelData(type, level);
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
