import 'package:chatting_app/helper/authenticate.dart';
import 'package:chatting_app/helper/helperfunction.dart';
import 'package:chatting_app/views/chat_room_screen.dart';
import 'package:chatting_app/views/signin.dart';
import 'package:chatting_app/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userloggedin;
  @override
  void initState() {
    getloggedInState();
    super.initState();
  }

  getloggedInState() async {
    await HelperFunction.getuserlogininformation().then((value) {
      setState(() {
        userloggedin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chatting App",
      debugShowCheckedModeBanner: false,
      home: userloggedin != null
          ? userloggedin == true
              ? ChatRoomScreen()
              : Authenticate()
          : Authenticate(),
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff1f1f1f)),
    );
  }
}
