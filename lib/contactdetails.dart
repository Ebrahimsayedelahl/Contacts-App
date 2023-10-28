
import 'package:contacts/homescreen.dart';
import 'package:flutter/material.dart';
import 'sql.dart';
import 'model.dart';


class ContactDetails extends StatefulWidget {
  final Contacts contact;

  const ContactDetails({required this.contact});



  @override

  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController url = TextEditingController();
  late Sql helper;

  @override
  void initState() {
    super.initState();
    name.text=widget.contact.contactName;
    number.text=widget.contact.contactNumber;
    url.text=widget.contact.imageURL;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details',style: TextStyle(color: Color(0xFF0977CB),fontSize: 30),),
        centerTitle:true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 100.0,
                backgroundImage: Image.network(url.text).image,
                backgroundColor: Colors.transparent,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Contact Name',
                ),
              ),
              TextField(
                controller: number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Contact Image Number',
                ),
              ),
              TextField(
                controller: url,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Contact Image URL',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF0977CB))),
                  onPressed: () {
                    String updatedName = name.text;
                    String updatedNumber = number.text;
                    String updatedURL = url.text;

                    Contacts updatedContact = Contacts(
                      id: widget.contact.id,
                      contactName: updatedName,
                      contactNumber: updatedNumber,
                      imageURL: updatedURL,
                    );

                    Sql.instance.updateContacts(updatedContact);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text(
                    'SAVE',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Contact'),
                          content: const Text('Are you sure you want to delete this contact?'),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {

                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'YES',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Sql.instance.deleteContact(widget.contact.id!);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen())) ;
                                 setState(() {
                                 });
                              },
                            ),
                          ],
                        );
                      },
                    );

                    setState(() {

                    });
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 25,color: Color(0xFF0977CB)),
                  ),
                ),
              ),


          ],),
        ),
      ),
    );
  }
}
