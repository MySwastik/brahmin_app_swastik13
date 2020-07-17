import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/app/landing_page.dart';
import 'package:brahminapp/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
        title: 'Swastik',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: LandingPage(),
      ),
    );
  }
}
