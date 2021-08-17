import 'package:api/http/HouseholdAccountDataHttp.dart';
import 'package:api/model/HouseholdAccountData.dart';
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
class HouseholdAcccountBookDetail extends StatelessWidget {
  List<HouseholdAccountData> householdAccountDataList = [];
  List<charts.Series<PieData, String>> _pieData = [];

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => HouseholdAcccountBookDetail(),
    );
  }

  generateData(List<HouseholdAccountData> householdAccountDataList) {
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

  @override
  Widget build(BuildContext context) {
    this.householdAccountDataList =
        HouseholdAccountDataHttp.getHouseholdAccountDataList();

    return Scaffold(
      appBar: AppBar(
        title: createAppBarText(),
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: charts.PieChart(
          generateData(householdAccountDataList),
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
