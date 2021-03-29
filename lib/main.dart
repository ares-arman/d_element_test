import 'package:d_element_test/screens/products_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: Color.fromRGBO(254, 80, 0, 0.5),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductsList(title: 'Flutter Demo Home Page'),
    );
  }
}

