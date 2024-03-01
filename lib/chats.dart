import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_messenger/common/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';//.

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
                  : AssetImage('assets/default.png') as ImageProvider<Object>?,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.contact.displayName ?? 'Unknown',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child:   TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.emailAddress,style: TextStyle(color: const Color.fromARGB(255, 14, 12, 12)),
                      decoration: const InputDecoration(
                        labelText: 'Type.....',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 14, 13, 13)),
                        hintText: 'Type text....',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
                        prefixIcon: Icon(Icons.camera,color: Color.fromARGB(255, 8, 8, 8),),

                        filled: false,
                        
                      ),
                    ),
     
                ),
                SizedBox(width: 2),
                InkWell(
                  onTap: _sendMessage,
                  child: Icon(Icons.send, color: const Color.fromARGB(255, 12, 12, 12)),
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
          return Center(
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
            return ListTile(minLeadingWidth: 10,
              title: Text(
                messageData['message'],
                style: TextStyle(color: Colors.white),
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
