import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../widget/drawerMenu.dart';
import './input.dart';

class HouseholdAcccountBookDetail extends StatefulWidget {
  @override
  _HouseholdAcccountBookDetail createState() => _HouseholdAcccountBookDetail();
}

class PieData {
  String activity;
  double money;
  PieData(this.activity, this.money);
}

class _HouseholdAcccountBookDetail extends State<HouseholdAcccountBookDetail>
    with SingleTickerProviderStateMixin {
  List<charts.Series<PieData, String>> _pieData;

  @override
  void initState() {
    super.initState();
    _pieData = List<charts.Series<PieData, String>>();
  }

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
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onPressAddButton,
      ),
    );
  }

  Widget createAppBarText() {
    return Text("収入支出");
  }

  void onPressAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => InputForm()),
    );
  }
}
