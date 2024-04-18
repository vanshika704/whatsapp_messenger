import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:whatsapp_messenger/chats.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 37, 35, 35),
          title: const Text(
            "WhatsApp",
            style: TextStyle(
              color: Color.fromARGB(255, 254, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text("New group"),
                  ),
                  const PopupMenuItem(
                    child: Text("New broadcast"),
                  ),
                  const PopupMenuItem(
                    child: Text("Linked devices"),
                  ),
                  const PopupMenuItem(
                    child: Text("Starred messages"),
                  ),
                  const PopupMenuItem(
                    child: Text("Payments"),
                  ),
                  const PopupMenuItem(
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
        body: const Chats(),
      ),
    );
  }
}



class Chats extends StatefulWidget {
  const Chats({super.key});

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
          tileColor: const Color.fromARGB(255, 7, 13, 17),
          leading: CircleAvatar(
            backgroundImage: contact.avatar != null
                ? MemoryImage(contact.avatar!)
                : const AssetImage('assets/default.png') as ImageProvider<Object>?,
          ),
          title: Text(
            contact.displayName ?? '',
            style: const TextStyle(
              color: Colors.white, 
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalChat(contact: contact),
              ),
            );
          },
        );
      },
    );
  }
}
