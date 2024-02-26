import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_messenger/common/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class PersonalChat extends StatefulWidget {
  final Contact contact;

  const PersonalChat({Key? key, required this.contact}) : super(key: key);

  @override
  _PersonalChatState createState() => _PersonalChatState();
}

 class _PersonalChatState extends State<PersonalChat> {
  TextEditingController _messageController = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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
                  : AssetImage('assets/default.png') as ImageProvider<Object>?,
            ),
            SizedBox(width: 8),
            Text(
              widget.contact.displayName ?? 'Unknown',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Coloors.backgroundDark(),
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.emailAddress,style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Type.....',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Type text....',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.camera,color: Colors.white,),

                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    child: Icon(Icons.send,color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
