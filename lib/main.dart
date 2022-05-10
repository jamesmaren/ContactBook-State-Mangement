import 'package:flutter/material.dart';
import 'package:state_management_flutter/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    //Define "/new-contact" as a new route
    routes: {
      '/new-contact': (context) => const NewContactView(),
    },
  ));
}

class Contact {
  final String name;
  const Contact({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = []; // we need a contacts storage

  int get length => _contacts.length; // expose how many contacts we have

  //simple add function
  void add({required Contact contact}) {
    _contacts.add(contact);
  }

  //Remove function on ContactBook
  void remove({required Contact contact}) {
    _contacts.remove(contact);
  }

//function to retrieve contacts with index
  Contact? contact({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),

      //use listView.Builder for the body of the Scaffold
      body: ListView.builder(
        itemCount: contactBook.length,
        //listTile Per Contact
        itemBuilder: (context, index) {
          final contact = contactBook.contact(atIndex: index)!;
          return ListTile(
            title: Text(contact.name),
          );
        },
      ),

      // we need way to add new contacts
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// work on a new view to add contacts
class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  _NewContactViewState createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  //inorder to grab text out of our text field
  //add TextEditingController to view so as user to be able
  //to write the name of the new contact
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //scaffold for NewContactView
    return Scaffold(
      appBar: AppBar(
        title: const Text('add a new contact'),
      ),
      body: Column(
        children: [
          //Add TextField and assign Our controller to it
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter a new contact name her...",
            ),
          ),
          //Add TextButton And add Contact upon pressing it and pop back too
          TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            },
            child: const Text("Add Contact"),
          )
        ],
      ),
    );
  }
}
