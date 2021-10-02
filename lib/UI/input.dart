import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../entity/HouseholdAccountData.dart';
import '../http/HouseholdAccountDataHttp.dart';

enum RadioValue { SPENDING, INCOME }

class InputFormState extends StateNotifier<RadioValue> {
  InputFormState() : super(RadioValue.INCOME);

  void changeState(value) {
    this.state = value;
  }
}

final inputFormProvider = StateNotifierProvider<InputFormState, RadioValue>((refs) => InputFormState());

class InputForm extends ConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => InputForm(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HouseholdAccountData _data = HouseholdAccountData(0, 0, "", 0);
  BuildContext? _context;
  RadioValue? _groupValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _groupValue = ref.watch(inputFormProvider);
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('家計簿登録'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              _createRadioListColumn(ref, _groupValue!),
              _createTextFieldColumn(),
              _createSaveIconButton(ref, _formKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createRadioListColumn(WidgetRef ref, RadioValue groupValue) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          _createRadioList(ref, groupValue, RadioValue.INCOME),
          _createRadioList(ref, groupValue, RadioValue.SPENDING),
        ],
      ),
    );
  }

  Widget _createRadioList(
      WidgetRef ref, RadioValue groupValue, RadioValue value) {
    String text = (value == RadioValue.SPENDING ? '支出' : '収入');

    return RadioListTile(
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: (value) => _onRadioSelected(value, ref),
    );
  }

  Widget _createTextFieldColumn() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _createItemTextField(),
          _createMoneyTextField(),
        ],
      ),
    );
  }

  Widget _createItemTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: const Icon(Icons.library_books),
        hintText: '項目',
        labelText: 'Item',
      ),
      onSaved: (String? value) {
        _data.item = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return '項目は必須入力項目です';
        }
        return null;
      },
      initialValue: _data.item,
    );
  }

  Widget _createMoneyTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: const Icon(CupertinoIcons.money_dollar),
        hintText: '金額',
        labelText: 'Money',
      ),
      onSaved: (String? value) {
        _data.money = int.parse(value!);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return '金額は必須入力項目です';
        }
        return null;
      },
      initialValue: _data.item,
    );
  }

  Widget _createSaveIconButton(WidgetRef ref, GlobalKey<FormState> formKey) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: ElevatedButton(
        child: Text('登録'),
        onPressed: () {
          formKey.currentState!.save();
          _data.type =
              ref.read(inputFormProvider.notifier).state == RadioValue.INCOME
                  ? 1
                  : 0;
          HouseholdAccountDataHttp.saveHouseholdAccountData(_data);
          Navigator.of(_context!).pop<dynamic>();
        },
      ),
    );
  }

  void _onRadioSelected(dynamic value, WidgetRef ref) {
    ref.read(inputFormProvider.notifier).changeState(value);
  }
}
