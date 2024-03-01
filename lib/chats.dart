import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'dart:math';
import 'package:whatsapp_messenger/common/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PersonalChat extends StatefulWidget {
  final Contact contact;

  const PersonalChat({Key? key, required this.contact}) : super(key: key);

  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final TextEditingController _messageController = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
                onPressed: () async {
                await Get.to(_joinMeeting());
                },

                icon: const Icon(
                  Icons.video_call_outlined,
                  color: Colors.white,
                )),
            PopupMenuButton(
              color: Colors.white,
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
      body: Column(
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
                    style:
                        const TextStyle(color: Color.fromARGB(255, 14, 12, 12)),
                    decoration: const InputDecoration(
                      labelText: 'Type.....',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 14, 13, 13)),
                      hintText: 'Type text....',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
                      prefixIcon: Icon(
                        Icons.camera,
                        color: Color.fromARGB(255, 8, 8, 8),
                      ),
                      filled: false,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                InkWell(
                  onTap: _sendMessage,
                  child: const Icon(Icons.send,
                      color: Color.fromARGB(255, 12, 12, 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('your_collection')
          .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('receiverId', isEqualTo: widget.contact.identifier)
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        var messages = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var messageData = messages[index].data() as Map<String, dynamic>;
            return ListTile(
              minLeadingWidth: 10,
              title: Text(
                messageData['message'],
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
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

void _handlePopupMenuSelection(String value) {
  if (value == "block") {
  } else if (value == "wallpaper") {
  } else if (value == "clear_chat") {}
}
String generateRandomRoomName() {
  final random = Random();
  return 'room_${random.nextInt(9999)}';
}
 _joinMeeting() async {
    try {
      var roomName = generateRandomRoomName();
      var options = JitsiMeetingOptions(room: roomName);
      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      print("Error: $error");
    }
  }
 