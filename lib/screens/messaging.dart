import 'package:flutter/material.dart';
import 'package:message_app/screens/database.dart';
import 'package:message_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String username;
  const NewMessage({Key? key, required this.username}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController myController = TextEditingController();
  List<String> msgs = [];
  var uid;
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final postMessageField = TextFormField(
      controller: myController,
      style: TextStyle(
        decorationColor: Colors.white,
        color: Colors.white,
      ),
      autofocus: false,
      onSaved: (value) {},
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          hintStyle: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("${widget.username}"),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            child: const Text("Logout"),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('msgs')
                .where('recip', isEqualTo: widget.username)
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
                        'Me: ' + document['message'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                postMessageField,
                MaterialButton(
                  child: Text('Send Message'),
                  onPressed: () {
                    setState(() {
                      msgs.add(myController.text);

                      sendMsg(myController.text, widget.username);
                      myController.clear();
                    });
                  },
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
