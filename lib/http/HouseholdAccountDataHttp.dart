import 'package:api/model/HouseholdAccountData.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'dart:convert' as convert;

class HouseholdAccountDataHttp {
  static Future<List<HouseholdAccountData>>
      getHouseholdAccountDataList() async {
    List<HouseholdAccountData> householdAccountData = [];
    var random = new math.Random();
    householdAccountData = [
    ];

    var url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbwqSD3jNHnUvG30N0CKJyLEwqTtdRCs9ewuVTHDAOqf3dzea7_L/exec');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var data = jsonResponse['data'];

      data.forEach((var item) {
        print(item);

        int id = int.parse(item['id']);
        int type = int.parse(item['type']);
        String detail = item['detail'];
        int amount = int.parse(item['amount']);

        householdAccountData
            .add(HouseholdAccountData(id, type, detail, amount));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return householdAccountData;
  }

  static void saveHouseholdAccountData() {
    print("saveHouseholdAccountData------------------------");
  }
}
