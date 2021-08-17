import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/drawerMenu.dart';
import './input.dart';

class PieData {
  String activity;
  double money;
  PieData(this.activity, this.money);
}

// ignore: must_be_immutable
class HouseholdAcccountBookDetail extends HookConsumerWidget {
  List<charts.Series<PieData, String>> _pieData = [];

  generateData() {
    var pieData = [
      new PieData('支出 ', 35.8),
      new PieData('収入', 18.3),
    ];
    _pieData.add(
      charts.Series(
        domainFn: (PieData data, _) => data.activity,
        measureFn: (PieData data, _) => data.money,
        id: 'Time spent',
        data: pieData,
        labelAccessorFn: (PieData data, _) => '${data.activity}:${data.money}',
      ),
    );
    return _pieData;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: createAppBarText(),
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: charts.PieChart(
          generateData(),
          animate: true,
          animationDuration: Duration(seconds: 1),
          defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside)
            ],
          ),
        ),
      ),
    );
  }

  Widget createAppBarText() {
    return Text("収入支出");
  }
}
