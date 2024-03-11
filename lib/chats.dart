import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:whatsapp_messenger/common/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class PersonalChat extends StatefulWidget {
  final Contact contact;

  const PersonalChat({Key? key, required this.contact}) : super(key: key);

  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final TextEditingController _messageController = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();

    if (widget.contact.identifier != null) {
      messaging.subscribeToTopic(widget.contact.identifier!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Coloors.backgroundDark(),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.contact.avatar != null
                  ? MemoryImage(widget.contact.avatar!)
                  : const AssetImage('assets/default.png') as ImageProvider<Object>?,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.contact.displayName ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.video_call_outlined,
                color: Colors.white,
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more, color: Colors.white),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text("block"),
                  ),
                  const PopupMenuItem(
                    child: Text("wallpaper"),
                  ),
                  const PopupMenuItem(
                    child: Text("clear chat"),
                  )
                ];
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children:[ Image.asset(
      'assets/chatsbackground.jpg', 
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
           Column(
          children: [
            Expanded(
              child: Container(
                color: Coloors.backgroundDark(),
                child: _buildChatHistory(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color.fromARGB(255, 14, 12, 12)),
                      decoration: const InputDecoration(
                        labelText: 'Type.....',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 14, 13, 13)),
                        hintText: 'Type text....',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
                        prefixIcon: Icon(
                          Icons.camera,
                          color: Color.fromARGB(255, 8, 8, 8),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: _sendMessage,
                    child: const Icon(Icons.send, color: Color.fromARGB(255, 7, 7, 7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

 Widget _buildChatHistory() {
  return Column(
    children: [
      Expanded(
        child: Container(
          color: Coloors.backgroundDark(),
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(_messages[index]),
                onDismissed: (direction) {
                  setState(() {
                    _messages.removeAt(index);
                  });
                },
                background: Container(
                  color: Colors.red, 
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  minLeadingWidth: 2,
                  tileColor: Colors.transparent,
                  title: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        // User swiped left (negative velocity), you can perform some action here
                      } else if (details.primaryVelocity! > 0) {
                        // User swiped right (positive velocity), you can perform some action here
                      }
                    },
                    child: Text(
                      _messages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });

      FirebaseFirestore.instance.collection('your_collection').add({
        'senderId': FirebaseAuth.instance.currentUser?.uid,
        'receiverId': widget.contact.identifier,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }
}


class CallPage extends StatelessWidget {
  final String callID;
  final Contact contact;

  const CallPage({
    Key? key,
    required this.callID,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNumber = contact.phones?.isNotEmpty == true
        ? contact.phones!.first.value ?? ''
        : '';

    String userName = contact.displayName ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Coloors.backgroundDark(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          ZegoUIKitPrebuiltCall(
            appID: 945202887,
            appSign:
                '42a38bb963af959422d95fe9bd149d4f1d14c11a3c85bb3a1e03ea3cb6192ec0',
            userID: phoneNumber,
            userName: userName,
            callID: callID,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // End the call when the button is pressed
          Navigator.pop(context); // Close the call page
        },
        child: Icon(Icons.call_end),
        backgroundColor: Colors.red,
      ),
    );
  }
}
