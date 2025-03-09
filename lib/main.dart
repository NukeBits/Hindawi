import 'package:flutter/material.dart';
import 'package:hindawi/pages/home/main.dart';  
import 'package:hindawi/utils/config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await config();
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}


