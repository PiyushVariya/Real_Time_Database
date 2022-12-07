// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'avlon_app/first_page.dart';
import 'demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FirstPage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DatabaseReference reference = FirebaseDatabase.instance.ref("users");
    DatabaseReference child = reference.child('name');

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    reference.keepSynced(true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[900],
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              child.push().set(titleController.text).asStream();
                              print("ADD");
                              titleController.clear();
                            },
                            child: const Text('Add Data')),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
          title: const Text('Todos', style: TextStyle(fontSize: 30)),
          backgroundColor: Colors.indigo[900]),
      body: FirebaseAnimatedList(
        query: child,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {
              print('asdf,');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                tileColor: Colors.indigo[100],
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.red[900]),
                      onPressed: () {
                        child
                            .child(snapshot.key!)
                            .ref
                            .update({"title": titleController.text});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[900]),
                      onPressed: () {
                        child.child(snapshot.key!).remove();
                        print("DELETE");
                      },
                    ),
                  ],
                ),
                title: Text(
                  snapshot.value.toString(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddNote extends StatelessWidget {
  const AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    DatabaseReference reference = FirebaseDatabase.instance.ref("users/123");
    DatabaseReference child = reference.child('name');
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: title,
              decoration: const InputDecoration(hintText: 'title'),
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            color: Colors.indigo[900],
            onPressed: () {
              child.push().set(title.text).asStream();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: const Text(
              "save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
