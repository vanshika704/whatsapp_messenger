import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
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
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              color: Colors.white,
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

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (BuildContext context, int index) {
        Contact contact = _contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: contact.avatar != null
                ? MemoryImage(contact.avatar!)
                : AssetImage('assets/default.png') as ImageProvider<Object>?,
          ),
          title: Text(contact.displayName ?? ''),
          onTap: () {
            Get.to(PersonalChat(), arguments: _contacts[index]);
          },
        );
      },
    );
  }
}
