import 'package:flutter/material.dart';
import 'package:state_management_flutter/home_page.dart';
import 'package:uuid/uuid.dart';

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
  final String id;
  final String name;
  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

//convert ContactBook To ValueNotifier<List<Contact>>

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = []; // we need a contacts storage

//after Value notifier update to code, update length getter to use value.length
  int get length => value.length; // expose how many contacts we have

  //simple add function
  void add({required Contact contact}) {
    //after Value notifier update to code, update "add(...)" function to use "value" instead
    final contacts = value;
    contacts.add(contact);
    value = contacts;
    notifyListeners();
  }

  //Remove function on ContactBook
  void remove({required Contact contact}) {
    //after Value notifier update to code, Update"remove(..)function to use "valuye"
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

//function to retrieve contacts with index
//after Value notifier update to code, Update "contact(..)" function to use "value" instead
  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),

      //use listView.Builder for the body of the Scaffold
      //after valuelistenerbuilder wrap , we use it as its body
      body: ValueListenableBuilder(
          //return listview inside valueListenableBuilder
          valueListenable: ContactBook(),
          builder: (contact, value, child) {
            final contacts = value as List<Contact>;
            return ListView.builder(
              itemCount: contacts.length,
              //listTile Per Contact
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  //make your cells dismissable using dismissible and valueke(contact.id)
                  onDismissed: (direction) {
                    contacts.remove(contact);
                  },
                  key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 6.0,
                    child: ListTile(
                      title: Text(contact.name),
                    ),
                  ),
                );
              },
            );
          }),

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
