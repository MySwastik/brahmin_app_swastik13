import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'other_user.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<UserId>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
      if (snapshot.data == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      final user = snapshot.data;
      return StreamBuilder<QuerySnapshot>(
          stream: FireStoreDatabase(uid: user.uid).getUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: FloatingSearchBar.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot =
                    snapshot.data.documents[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OtherUser(
                                profilePic: documentSnapshot.data["file"],
                                firstName: documentSnapshot.data["firstName"],
                                lastName: documentSnapshot.data["lastName"],
                                aboutYou: documentSnapshot.data["aboutYou"],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CircularProfileAvatar(
                                  'G',
                                  animateFromOldImageOnUrlChange: true,
                                  child: Image.network(
                                    documentSnapshot["file"].toString(),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                              .expectedTotalBytes !=
                                              null
                                              ? loadingProgress
                                              .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                  radius: 40,
                                  borderWidth: 1,
                                  borderColor: Colors.deepOrange,
                                  elevation: 8,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        documentSnapshot.data["firstName"] +
                                            " " +
                                            documentSnapshot.data["lastName"],
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black54),
                                      ),
                                      //SizedBox(height: 8,),
                                      Text(
                                        documentSnapshot.data["aboutYou"],
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black54),
                                      ),
                                      Divider(
                                        height: 5,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  iconSize: 30,
                                  color: Colors.deepOrange,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  trailing: CircleAvatar(
                    child: Text("RD"),
                  ),
                  onChanged: (String value) {},
                  onTap: () {},
                  decoration: InputDecoration.collapsed(
                    hintText: "Search...",
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });

        });

  }
}
