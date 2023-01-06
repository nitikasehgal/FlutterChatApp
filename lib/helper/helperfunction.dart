import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedpreferenceloggedinkey = 'IsLogIn';
  static String sharedpreferenceusernamekey = 'UserName';
  static String sharedpreferenceuseremail = "UserEmail";

  static Future saveuserlogininformation(bool isUserLogIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedpreferenceloggedinkey, isUserLogIn);
  }

  static Future saveusernameinformation(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferenceusernamekey, name);
  }

  static Future saveuseremailinformation(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferenceuseremail, email);
  }

  static Future getuserlogininformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedpreferenceloggedinkey);
  }

  static Future getuserUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedpreferenceusernamekey);
  }

  static Future getuseremail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedpreferenceuseremail);
  }
}
