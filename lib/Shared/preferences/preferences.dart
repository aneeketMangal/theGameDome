import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake/register/avatar.dart';

firstTimeHandling() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('new')) {
    prefs.setBool('new', false);
    return true;
  } else {
    return false;
  }
}

insertToSharedPreferences(int val, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('avatar', val);
  prefs.setString('username', name);
}

updateToSharedPreferences(int val, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('avatar', val);
  prefs.setString('username', name);
}

Future<Avatar> readDataFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int avatarIndex = prefs.getInt('avatar');
  String userName = prefs.getString('username');
  if (userName == null) {
    return Avatar(0, "firstTime??");
  } else {
    return Avatar(avatarIndex, userName);
  }
}
