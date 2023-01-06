// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatting_app/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chatting_app/helper/authenticate.dart';
import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/helper/helperfunction.dart';
import 'package:chatting_app/services/auth.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/search.dart';
import 'package:chatting_app/views/signin.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  var chatRooms;
  @override
  void initState() {
    getuserinfo();

    super.initState();
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .where('users', arrayContains: constants.myname)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      userName: snapshot.data!.docs[index]['chatRoomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(constants.myname, ''),
                      chatRoomid: snapshot.data!.docs[index]['chatRoomId'],
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                )
              : Container();
        });
  }

  getuserinfo() async {
    constants.myname = await HelperFunction.getuserUsername();
    DatabaseMethods().getChatRoom(constants.myname).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${constants.myname}");
      });
    });
  }

  AuthMethod authMethod = AuthMethod();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room!"), centerTitle: true, actions: [
        InkWell(
            onTap: () {
              authMethod.signout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Authenticate();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.logout),
            ))
      ]),
      body: Container(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Search();
          }));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomid;
  const ChatRoomTile({
    Key? key,
    required this.userName,
    required this.chatRoomid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return ConversationScreen(chatRoomid);
        })));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(40)),
            child: Text("${userName.substring(0, 1).toUpperCase()}"),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            userName,
            style: TextStyle(color: Colors.white, fontSize: 17),
          )
        ]),
      ),
    );
  }
}
