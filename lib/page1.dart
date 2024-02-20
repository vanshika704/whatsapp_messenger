import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WhatsApp",
          style: TextStyle(
            color: Color.fromARGB(255, 254, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("New group"),
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                ),
                PopupMenuItem(
                  child: Text("Linked devices"),
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                ),
                PopupMenuItem(
                  child: Text("Payments"),
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                ),
              ];
            },
          ),
        ],
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.group)),
            Tab(text: "CHATS"),
            Tab(text: "STATUS"),
            Tab(text: "CALLS"),
          ],
        ),
      ),
      body: Chats(),
    );
  }
}



class ChatController extends GetxController {

  RxList<Map<String, String>> chatData = [
    {"name": "John Doe", "message": "Hello!", "imageUrl": "url_to_image"},
    {"name": "Jane Doe", "message": "Hi there!", "imageUrl": "url_to_image"},
    
  ].obs;
}

class Chats extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: chatController.chatData.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  chatController.chatData[index]['imageUrl'] ?? ''),
            ),
            title: Text(chatController.chatData[index]['name'] ?? ''),
            subtitle: Text(chatController.chatData[index]['message'] ?? ''),
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}

