import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widget/drawerMenu.dart';
import '../http/HouseholdAccountDataHttp.dart';
import '../entity/HouseholdAccountData.dart';
import './chart_container.dart';

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
              child: Column(
                children: [
                  Expanded(
                    child: ChartContainer(
                        title: '収入支出',
                        color: const Color(0x00000000),
                        chart: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: generateData(
                                    snapshot.data!, HouseholdAccountData.spendingFlg),
                                title: '支出',
                                color: const Color(0xffed733f),
                              ),
                              PieChartSectionData(
                                value: generateData(
                                    snapshot.data!, HouseholdAccountData.incomeFlg),
                                title: '収入',
                                color: const Color(0xFF733FED),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
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

  double generateData(List<HouseholdAccountData> householdAccountDataList, int type) {
    var income = 0.0;
    var outcome = 0.0;

    householdAccountDataList.forEach((HouseholdAccountData householdAccountData) {
      if (householdAccountData.type == HouseholdAccountData.incomeFlg) {
        income += householdAccountData.money;
      } else {
        outcome += householdAccountData.money;
      }
    });

    if (type == HouseholdAccountData.spendingFlg) {
      return outcome;
    }
    return income;
  }
}
