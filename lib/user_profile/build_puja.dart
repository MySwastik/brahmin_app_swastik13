import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/user_profile/puja_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildPuja extends StatefulWidget {
  final DatabaseL database;

  const BuildPuja({Key key, @required this.database}) : super(key: key);

  @override
  _BuildPujaState createState() => _BuildPujaState();
}

class _BuildPujaState extends State<BuildPuja> {
  String name;
  int rate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.database.getPujaOfferingList,
        builder: (context, snapshot) {
          if (snapshot.data.documents == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Container(
            padding: EdgeInsets.all(8),
            //width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepOrange, width: 2),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Puja you offer ',
                      style: TextStyle(fontSize: 18, color: Colors.deepOrange),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.deepOrange,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PujaPage(
                              database: widget.database,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      name = snapshot.data.documents[index].data['name'];
                      rate = snapshot.data.documents[index].data['rate'];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            Text(
                              '$rate₹',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
