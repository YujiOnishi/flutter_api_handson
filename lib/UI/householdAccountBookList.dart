import 'package:flutter/material.dart';
import '../widget/drawerMenu.dart';
import './input.dart';
import '../http/HouseholdAccountDataHttp.dart';
import '../entity/HouseholdAccountData.dart';

class HouseholdAccountBookList extends StatelessWidget {
  final List<Tab> _tabs = <Tab>[
    Tab(text: '総合'),
    Tab(text: '収入'),
    Tab(text: '支出'),
  ];

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => HouseholdAccountBookList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<HouseholdAccountData>> householdAccountDataList = HouseholdAccountDataHttp.getHouseholdAccountDataList();

    return FutureBuilder<List<HouseholdAccountData>>(
      future: householdAccountDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text("家計簿一覧"),
                bottom: TabBar(
                  tabs: _tabs,
                ),
              ),
              drawer: DrawerMenu(),
              body: TabBarView(
                children: _tabs.map(
                  (Tab tab) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _createHouseholdAcccountBookDetail(tab.text, snapshot.data),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _onPressAddButton(context);
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('error');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createHouseholdAcccountBookDetail(String tabText, List<HouseholdAccountData> householdAccountDataList) {
    int tabType;

    switch (tabText) {
      case '総合':
        tabType = 3;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '収入':
        tabType = HouseholdAccountData.incomeFlg;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '支出':
        tabType = HouseholdAccountData.spendingFlg;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      default:
        return Text("エラー");
    }
  }

  List<Widget> _createWordCards(int tabType, List<HouseholdAccountData> householdAccountDataList) {
    return householdAccountDataList.map(
      (HouseholdAccountData householdAccountData) {
        if (householdAccountData.type == tabType || tabType == 3) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: _createWordTile(householdAccountData, tabType),
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget _createWordTile(HouseholdAccountData householdAccountData, int tabType) {
    Icon icon = householdAccountData.type == HouseholdAccountData.spendingFlg
        ? Icon(
            Icons.subdirectory_arrow_left_outlined,
            color: Colors.pink,
          )
        : Icon(
            Icons.add_box,
            color: Colors.blue,
          );
    return ListTile(
      leading: icon,
      title: Text(householdAccountData.item),
      subtitle: Text(
        '${householdAccountData.money}円',
      ),
    );
  }

  void _onPressAddButton(BuildContext context) {
    Navigator.of(context).push<dynamic>(
      InputForm.route(),
    );
  }
}
