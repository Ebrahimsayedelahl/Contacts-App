import 'package:contacts/ContactDetails.dart';
import 'package:contacts/homescreen.dart';
import 'package:flutter/material.dart';
import 'sql.dart';
import 'model.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Sql.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      HomeScreen(),
    );
  }
}
