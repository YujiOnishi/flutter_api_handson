import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../widget/drawerMenu.dart';
import '../http/HouseholdAccountDataHttp.dart';
import '../entity/HouseholdAccountData.dart';

class PieData {
  String activity;
  double money;
  PieData(this.activity, this.money);
}

class HouseholdAccountBookDetail extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => HouseholdAccountBookDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<HouseholdAccountData>> householdAccountDataList =
        HouseholdAccountDataHttp.getHouseholdAccountDataList();

    return FutureBuilder<List<HouseholdAccountData>>(
      future: householdAccountDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("収入支出"),
            ),
            drawer: DrawerMenu(),
            body: Center(
              child: charts.PieChart(
                generateData(snapshot.data),
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
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<charts.Series<PieData, String>> generateData(
      List<HouseholdAccountData> householdAccountDataList) {
    List<charts.Series<PieData, String>> _pieData = [];
    double income = 0;
    double outcome = 0;

    householdAccountDataList
        .forEach((HouseholdAccountData householdAccountData) {
      if (householdAccountData.type == HouseholdAccountData.incomeFlg) {
        income += householdAccountData.money;
      } else {
        outcome += householdAccountData.money;
      }
    });
    var pieData = [
      new PieData('支出 ', outcome),
      new PieData('収入', income),
    ];
    _pieData.add(
      charts.Series(
        domainFn: (PieData data, _) => data.activity,
        measureFn: (PieData data, _) => data.money,
        id: 'Time spent',
        data: pieData,
        labelAccessorFn: (PieData data, _) => '${data.activity}:${data.money}円',
      ),
    );
    return _pieData;
  }
}
