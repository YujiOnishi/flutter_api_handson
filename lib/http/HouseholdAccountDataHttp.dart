import 'package:api/model/HouseholdAccountData.dart';

class HouseholdAccountDataHttp {
  static List<HouseholdAccountData> getHouseholdAccountDataList(){
    List<HouseholdAccountData> householdAccountData = [];
    householdAccountData = [
      HouseholdAccountData(1, 0, "カメラ", 20000),
      HouseholdAccountData(2, 1, "売上", 20000),
      HouseholdAccountData(3, 1, "雑収入", 20000),
      HouseholdAccountData(4, 0, "レンズ", 20000),
    ];
    return householdAccountData;
  }

  static void saveHouseholdAccountData(){
    print("saveHouseholdAccountData------------------------");
  }
}