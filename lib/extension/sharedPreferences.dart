import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  setValue(number ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('primaryId', '$number');
  }

  getValues() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('primaryId') != null) {
      return prefs.getString('primaryId');
    } else {
      return null;
    }
  }

  removeValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('primaryId');
  }
}
