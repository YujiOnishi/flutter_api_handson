import 'package:api/model/HouseholdAccountData.dart';
import 'package:api/http//HouseholdAccountDataHttp.dart';
import 'package:flutter/material.dart';
import '../widget/drawerMenu.dart';
import './input.dart';

class HouseholdAcccountBookList extends StatefulWidget {
  @override
  _HouseholdAcccountBookList createState() => _HouseholdAcccountBookList();
}

class _HouseholdAcccountBookList extends State<HouseholdAcccountBookList>
    with SingleTickerProviderStateMixin {
  List<HouseholdAccountData> householdAccountDataList = [];
  TabController tabController;
  final List<Tab> tabs = <Tab>[
    Tab(text: '総合'),
    Tab(text: '収入'),
    Tab(text: '支出'),
  ];

  @override
  void initState() {
    tabController = TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.householdAccountDataList = HouseholdAccountDataHttp.getHouseholdAccountDataList();

    return Scaffold(
      appBar: AppBar(
        title: createAppBarText(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              onPressAddButton();
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
        ),
      ),
      drawer: DrawerMenu(),
      body: TabBarView(
        controller: tabController,
        children: tabs.map(
          (Tab tab) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  createHouseholdAcccountBookDetail(tab.text),
                ],
              ),
            );
          },
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onPressAddButton,
      ),
    );
  }

  Widget createHouseholdAcccountBookDetail(String tabText) {

    int tabType;

    switch (tabText) {
      case '総合':
        tabType = 3;
        return Column(
          children: createWordCards(tabType),
        );
        break;
      case '収入':
        tabType = HouseholdAccountData.incomeFlg;
        return Column(
          children: createWordCards(tabType),
        );
        break;
      case '支出':
        tabType = HouseholdAccountData.spendingFlg;
        return Column(
          children: createWordCards(tabType),
        );
        break;
      default:
        return Text("エラー");
    }
  }

  Widget createAppBarText() {
    return Text("家計簿一覧");
  }

  List<Widget> createWordCards( int tabType) {
    return householdAccountDataList.map(
      (HouseholdAccountData householdAccountData) {
        if (householdAccountData.type == tabType || tabType == 3) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                createWordTile(householdAccountData,tabType),
                createButtonBar(householdAccountData.id),
              ],
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget createWordTile(HouseholdAccountData householdAccountData ,int tabType) {
    Icon icon =
    householdAccountData.type == HouseholdAccountData.spendingFlg
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

  void onPressAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => InputForm()),
    );
  }
}
