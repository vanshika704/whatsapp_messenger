import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_messenger/chats.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 54, 54, 54),
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
              icon: Icon(Icons.search,color: Colors.white,),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.camera_alt,color: Colors.white,),
              onPressed: () {},
            ),
            PopupMenuButton(color: Colors.white,
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
  labelColor: Colors.white, 
  unselectedLabelColor: Colors.white, 
  tabs: [
    Tab(icon: Icon(Icons.group)),
    Tab(
      text: "CHATS",
    ),
    Tab(
      text: "STATUS",
    ),
    Tab(
      text: "CALLS",
    ),
  ],
),

        ),
        body: Chats(),
      ),
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
            key: UniqueKey(), 
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  chatController.chatData[index]['imageUrl'] ?? ''),
            ),
            title: Text(
              chatController.chatData[index]['name'] ?? '',
              style: TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
            ),
            subtitle: Text(
              chatController.chatData[index]['message'] ?? '',
              style: TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
            ),
            tileColor: Color.fromARGB(255, 37, 37, 37),
            onTap: () {
              Get.to(PersonalChat(), arguments: index);
            },
          );
        },
      ),
    );
  }
}



