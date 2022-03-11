import 'package:flutter/material.dart';
import 'package:message_app/screens/search_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var uid = user?.uid;
    return Scaffold(
        appBar: AppBar(
          title: Text("Past Conversations"),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange[50]),
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchUser()));
                          },
                          child: const Text(
                            "Start New",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('msgs')
                  .where('sender', isEqualTo: uid)
                  .limit(1)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                            color: Color.fromARGB(255, 85, 176, 250),
                            shape: Border.all(color: Colors.black, width: 3.0)),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Text(
                          '''${document['recip']}: ${document['message']}''',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ));
  }
}

class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var uid = user?.uid;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('msgs')
              .where('sender', isEqualTo: uid)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                        color: Color.fromARGB(255, 85, 176, 250),
                        shape: Border.all(color: Colors.black, width: 3.0)),
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 15,
                    child: Text(
                      'Me: ' + document['recip'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    ));
  }
}
