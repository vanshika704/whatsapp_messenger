// personal_chat.dart

import 'package:flutter/material.dart';
import 'package:whatsapp_messenger/common/colors.dart';
import 'package:contacts_service/contacts_service.dart';

class PersonalChat extends StatelessWidget {
  final Contact contact;

  const PersonalChat({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Coloors.backgroundDark(),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: contact.avatar != null
                  ? MemoryImage(contact.avatar!)
                  : AssetImage('assets/default.png') as ImageProvider<Object>?,
            ),
            SizedBox(width: 8),
            Text(
              contact.displayName ?? 'Unknown',
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
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Type.....',
                  hintText: 'Type text....',
                  prefixIcon: Icon(Icons.camera),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
