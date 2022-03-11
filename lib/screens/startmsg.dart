import 'package:flutter/material.dart';
import 'package:message_app/screens/messaging.dart';

import '../reusable_widgets/reusable_widgets.dart';

class StartConversation extends StatefulWidget {
  const StartConversation({Key? key}) : super(key: key);

  @override
  State<StartConversation> createState() => _StartConversationState();
}

class _StartConversationState extends State<StartConversation> {
  TextEditingController _searchUsername = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Recipient Username", Icons.person_outline,
                false, _searchUsername),
            const SizedBox(
              height: 20,
            ),
            submitSearch(context, true, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NewMessage(username: _searchUsername.text)));
            })
          ],
        ),
      ),
    );
  }
}
