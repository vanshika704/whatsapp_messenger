import 'package:flutter/material.dart';

class personalchat extends StatefulWidget {
  const personalchat({super.key});

  @override
  State<personalchat> createState() => _personalchatState();
}

class _personalchatState extends State<personalchat> {
 final TextEditingController _messagingcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [ 
            TextField(
              controller: _messagingcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'type.....',
                    hintText: 'type text....',
                    prefixIcon: Icon(Icons.camera),
                  ),
            )
            
          ],
        ),
      ),
    );
  }
}