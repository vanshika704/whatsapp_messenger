import 'package:flutter/material.dart';
import 'package:whatsapp_messenger/common/colors.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({Key? key}) : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final TextEditingController _messagingcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Text("John Doe"),
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
                controller: _messagingcontroller,
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
//.