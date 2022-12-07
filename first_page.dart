import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController shopNoController = TextEditingController();
  TextEditingController squareFeetController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController ownerNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void listenForUpdates({required DocumentSnapshot doc}) {
    final docRef = FirebaseFirestore.instance.collection('Avalon').doc(doc.id);
    docRef.snapshots().listen(
      (event) {
        var data = event as DocumentSnapshot;
        print("-------------------- ${event.data()}");
        print(">++++++++++++++++++ current SHOP NO: ${data["shopNo"]}");
        print(">++++++++++++++++++ current OWNER NAME: ${data["ownerName"]}");
      },
      onError: (error) => print("------------------Listen failed: $error"),
    );
  }

  // final Stream<int> _bids = (() {
  //   late final StreamController<int> controller;
  //   controller = StreamController<int>(
  //     onListen: () async {
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       controller.add(1);
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       await controller.close();
  //     },
  //   );
  //   return controller.stream;
  // })();

  //   void listen() {
  //     final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('Avalon').snapshots();
  //     _usersStream.listen((event) {
  //       print('current data: ${event}');
  //
  //     });
  //   }

  // @override
  //   void initState() {
  //     listen();
  //     // TODO: implement initState
  //     super.initState();
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            bottomSheet(
              btnTitle: 'Add Data',
              shopNoController: shopNoController,
              squareFeetController: squareFeetController,
              ownerNoController: ownerNoController,
              ownerNameController: ownerNameController,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addData();
                  print('Add Data');
                }
              },
            );
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text('First Page')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Avalon').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data?.docs[index];
              return ListTile(
                leading: Text(doc?['shopNo'] ?? ''),
                title: Text(doc?['ownerName'] ?? ''),
                subtitle: Text(doc?['ownerNo'] ?? ''),
                trailing: IconButton(
                    onPressed: () {
                      shopNoController.text = doc?['shopNo'];
                      squareFeetController.text = doc?['squareFeet'];
                      ownerNoController.text = doc?['ownerNo'];
                      ownerNameController.text = doc?['ownerName'];
                      bottomSheet(
                          btnTitle: 'Update Data',
                          shopNoController: shopNoController,
                          squareFeetController: squareFeetController,
                          ownerNoController: ownerNoController,
                          ownerNameController: ownerNameController,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Avalon')
                                .doc(doc?.id)
                                .update({
                              'shopNo': shopNoController.text,
                              'squareFeet': squareFeetController.text,
                              'ownerNo': ownerNoController.text,
                              'ownerName': ownerNameController.text,
                            });
                            listenForUpdates(doc: doc!);

                            Navigator.pop(context);
                          });
                      print('Update Data');
                    },
                    icon: const Icon(Icons.edit)),
              );
            },
          );
        },
      ),
    );
  }

  addData() async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    var ref = firebaseFireStore.collection('Avalon').doc(shopNoController.text);

    FirebaseFirestore.instance.enableNetwork();

    Navigator.pop(context);
    await ref.set({
      'shopNo': shopNoController.text,
      'squareFeet': squareFeetController.text,
      'ownerNo': ownerNoController.text,
      'ownerName': ownerNameController.text,
    });
    // listenForUpdates(doc: doc!);
    shopNoController.clear();
    squareFeetController.clear();
    ownerNoController.clear();
    ownerNameController.clear();
  }

  bottomSheet({
    required TextEditingController shopNoController,
    required TextEditingController squareFeetController,
    required TextEditingController ownerNoController,
    required TextEditingController ownerNameController,
    required void Function() onPressed,
    required String btnTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                TextFormField(
                  controller: shopNoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter shop no',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter shop no';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: squareFeetController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter square feet',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter square feet';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: ownerNoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter owner no',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter owner no';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: ownerNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter owner name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter owner name ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: onPressed, child: Text(btnTitle)))
              ],
            ),
          ),
        );
      },
    );
  }
}
