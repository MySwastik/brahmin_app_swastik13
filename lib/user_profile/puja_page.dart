import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/user_profile/edit_puja_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PujaPage extends StatefulWidget {
  final DatabaseL database;

  const PujaPage({Key key, @required this.database}) : super(key: key);

  @override
  _PujaPageState createState() => _PujaPageState();
}

class _PujaPageState extends State<PujaPage> {
  String pujaName;
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

          return Scaffold(
            appBar: AppBar(),
            body: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  pujaName = snapshot.data.documents[index].data['name'];
                  rate = snapshot.data.documents[index].data['rate'];
                  String id=snapshot.data.documents[index].documentID;
                  return Dismissible(
                      key: Key('puja-$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.red,),
                      onDismissed: (direction){
                        widget.database.deletepuja(id);
                      },
                      child: _buildTile(pujaName, rate));
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPuja(
                          database: widget.database,
                        )));
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }
}

Widget _buildTile(String name, int rate) {
  return Card(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          Text(
            '$rate₹',
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}
