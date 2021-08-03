class HouseholdAccountData {
  static final spendingFlg = 0;
  static final incomeFlg = 1;
  int id;
  int type;
  String item;
  int money;
  HouseholdAccountData(this.id, this.type, this.item, this.money);
}