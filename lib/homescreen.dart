import 'package:flutter/material.dart';
import 'sql.dart';
import 'model.dart';
import 'contactdetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<HomeScreen> {
  List<Contacts> contactsList = [];
  TextEditingController nameInput = TextEditingController();
  TextEditingController numberInput = TextEditingController();
  TextEditingController urlInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Contact',
          style: TextStyle(color: Color(0xFF0977CB), fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0977CB),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 250,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: nameInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Contact Name',
                          ),
                        ),
                        TextField(
                          controller: numberInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Contact Number',
                          ),
                        ),
                        TextField(
                          controller: urlInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Contact Image URL',
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 500,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFF0977CB)),
                            ),
                            onPressed: () async {
                              await Sql.instance.insertContact(
                                Contacts(
                                  contactName: nameInput.text,
                                  contactNumber: numberInput.text,
                                  imageURL: urlInput.text,
                                ),
                              );
                              Navigator.pop(context);
                              setState(() {
                                nameInput.clear();
                                numberInput.clear();
                                urlInput.clear();
                              });
                            },
                            child: const Text(
                              'ADD',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Contacts>>(
        future: Sql.instance.getAllContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            contactsList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                Contacts contact = contactsList[index];
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ContactDetails(contact: contact))) ;
                    },
                    child: Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(contact.imageURL),
                            backgroundColor: Colors.transparent,
                          ),
                          Text(contact.contactName),
                          Text(contact.contactNumber),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}