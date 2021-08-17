import 'package:api/model/HouseholdAccountData.dart';
import 'package:api/http//HouseholdAccountDataHttp.dart';
import 'package:flutter/material.dart';
import '../widget/drawerMenu.dart';
import './input.dart';

class HouseholdAccountBookList extends StatelessWidget {
  final List<Tab> tabs = <Tab>[
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
    Future<List<HouseholdAccountData>> householdAccountDataList =
        HouseholdAccountDataHttp.getHouseholdAccountDataList();

    return FutureBuilder<List<HouseholdAccountData>>(
      future: householdAccountDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: createAppBarText(),
                bottom: TabBar(
                  tabs: tabs,
                ),
              ),
              drawer: DrawerMenu(),
              body: TabBarView(
                children: tabs.map(
                      (Tab tab) {
                    return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            createHouseholdAcccountBookDetail(
                                tab.text, snapshot.data),
                          ],
                        ),
                    );
                  },
                ).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  onPressAddButton(context);
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

  Widget createHouseholdAcccountBookDetail(
      String tabText, List<HouseholdAccountData> householdAccountDataList) {
    int tabType;

    switch (tabText) {
      case '総合':
        tabType = 3;
        return Column(
          children: createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '収入':
        tabType = HouseholdAccountData.incomeFlg;
        return Column(
          children: createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '支出':
        tabType = HouseholdAccountData.spendingFlg;
        return Column(
          children: createWordCards(tabType, householdAccountDataList),
        );
        break;
      default:
        return Text("エラー");
    }
  }

  Widget createAppBarText() {
    return Text("家計簿一覧");
  }

  List<Widget> createWordCards(
      int tabType, List<HouseholdAccountData> householdAccountDataList) {
    return householdAccountDataList.map(
      (HouseholdAccountData householdAccountData) {
        if (householdAccountData.type == tabType || tabType == 3) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                createWordTile(householdAccountData, tabType),
                createButtonBar(householdAccountData.id),
              ],
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget createWordTile(
      HouseholdAccountData householdAccountData, int tabType) {
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

  Widget createButtonBar(int id) {
    return ButtonBar(
      children: <Widget>[
        createDeleteButton(id),
      ],
    );
  }

  Widget createDeleteButton(int id) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        onPressDeleteButton(id);
      },
    );
  }

  void onPressDeleteButton(int id) {}

  void onPressAddButton(BuildContext context) {
    Navigator.of(context).push<dynamic>(
      InputForm.route(),
    );
  }
}
