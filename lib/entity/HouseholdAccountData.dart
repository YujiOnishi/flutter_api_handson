class HouseholdAccountData {
  static final _spendingFlg = 0;
  static final _incomeFlg = 1;
  int _id;
  int _type;
  String _item;
  int _money;
  HouseholdAccountData(this._id, this._type, this._item, this._money);

  static get incomeFlg => _incomeFlg;
  static get spendingFlg => _spendingFlg;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  String get item => _item;

  set item(String value) {
    _item = value;
  }

  int get money => _money;

  set money(int value) {
    _money = value;
  }

}