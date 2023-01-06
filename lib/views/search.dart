import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/models/user.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController usercontroller = TextEditingController();
  QuerySnapshot? snapshot;

  createChatRoomandStartConversation(String username) {
    if (username != constants.myname) {
      List<String> users = [username, constants.myname];
      String chatroomid = getChatRoomId(username, constants.myname);
      Map<String, dynamic> chatroommap = {
        'users': users,
        'chatRoomId': chatroomid
      };
      databaseMethods.createchatroom(chatroomid, chatroommap);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConversationScreen(chatroomid);
      }));
    } else {
      print("You cann't send message to yourself");
    }
  }

  initiatesearch() {
    databaseMethods.getusersByUsername(usercontroller.text).then((val) {
      setState(() {
        snapshot = val;
      });
    });
  }

  Widget searchList() {
    return snapshot == null
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = snapshot!.docs[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['email'],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      createChatRoomandStartConversation(data['name']);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ]),
              );
            },
            itemCount: snapshot!.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: usercontroller,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        hintText: 'Search Users',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintStyle:
                            TextStyle(color: Colors.white54, fontSize: 18)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    initiatesearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ])),
                      padding: EdgeInsets.all(12),
                      child: Image.asset('assets/images/search_white.png')),
                )
              ],
            ),
          ),
          searchList()
        ],
      )),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
