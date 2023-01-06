import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getusersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .get();
  }

  getuserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUsers(usermap) {
    FirebaseFirestore.instance.collection('users').doc().set(usermap);
  }

  createchatroom(String chatRoomId, chatroommap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .set(chatroommap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addconversationmessages(String chatroomid, messagemap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomid)
        .collection('chats')
        .add(messagemap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getconversationmessages(String chatroomid) {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomid)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
