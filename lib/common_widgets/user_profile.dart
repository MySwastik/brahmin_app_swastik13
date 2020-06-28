import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../edit_and_create_profile.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context)=>EditAndCreateProfile(),
                ),
              );
            },
          ),
        ],
      ),
body: Text('di'),
    );
  }
}
