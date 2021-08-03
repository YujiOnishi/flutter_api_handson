import 'package:api/model/HouseholdAccountData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  InputForm();

  @override
  MyInputFormState createState() => MyInputFormState();
}

enum RadioValue { SPENDING, INCOME }

class MyInputFormState extends State<InputForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HouseholdAccountData data = HouseholdAccountData(0, 0, "", 0);
  RadioValue _gValue = RadioValue.SPENDING;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('家計簿登録'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              createRadioListColumn(),
              createTextFieldColumn(),
              createSaveIconButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget createRadioListColumn() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          createSpendingRadioList(),
          createIncomeRadioList(),
        ],
      ),
    );
  }

  Widget createSpendingRadioList() {
    return RadioListTile(
      title: Text('支出'),
      value: RadioValue.SPENDING,
      groupValue: _gValue,
      onChanged: (value) => _onRadioSelected(value),
    );
  }

  Widget createIncomeRadioList() {
    return RadioListTile(
      title: Text('収入'),
      value: RadioValue.INCOME,
      groupValue: _gValue,
      onChanged: (value) => _onRadioSelected(value),
    );
  }

  Widget createTextFieldColumn() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          createItemTextField(),
          createMoneyTextField(),
        ],
      ),
    );
  }

  Widget createItemTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: const Icon(Icons.library_books),
        hintText: '項目',
        labelText: 'Item',
      ),
      onSaved: (String value) {
        data.item = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return '項目は必須入力項目です';
        }
        return null;
      },
      initialValue: data.item,
    );
  }

  Widget createMoneyTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: const Icon(CupertinoIcons.money_dollar),
        hintText: '金額',
        labelText: 'Money',
      ),
      onSaved: (String value) {
        data.item = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return '金額は必須入力項目です';
        }
        return null;
      },
      initialValue: data.item,
    );
  }

  Widget createSaveIconButton() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: ElevatedButton(
        child: Text('登録'),
        onPressed: () {},
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }
}
