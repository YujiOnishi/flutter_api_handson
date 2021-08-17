import 'package:flutter/material.dart';
import '../UI/householdAccountBookDetail.dart';
import '../UI/householdAccountBookList.dart';

class DrawerMenu extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('お問い合わせは以下まで'),
            accountEmail: Text('freelancer@y-onishi.net'),
          ),
          ListTile(
            title: Text('収入支出'),
            onTap: () {
              Navigator.of(context).push<dynamic>(
                HouseholdAccountBookDetail.route(),
              );
            },
          ),
          ListTile(
            title: Text('家計簿一覧'),
            onTap: () {
              Navigator.of(context).push<dynamic>(
                HouseholdAccountBookList.route(),
              );
            },
          ),
        ],
      ),
    );
  }
}
