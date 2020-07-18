import 'package:brahminapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/app/home_page.dart';
import 'package:brahminapp/app/sign_in/sign_in_page.dart';
import 'package:brahminapp/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<UserId>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserId user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }

            return  Provider<DatabaseL>(builder:(context)=>FireStoreDatabase(uid: user.uid),child: HomePage(uid: user.uid,));
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
