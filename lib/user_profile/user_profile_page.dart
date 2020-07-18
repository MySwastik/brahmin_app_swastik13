import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/user_profile/edit_profile_page.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final DatabaseL database;
  final uid;

  const UserProfilePage({Key key, @required this.database,@required this.uid}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String firstName;
    String lastName;
    String file;
    String aboutYou;
    return StreamBuilder<QuerySnapshot>(
        stream: widget.database.getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data.documents.isEmpty) {
            firstName = 'Edit your name!';
            lastName = ' ';
            file = null;
            aboutYou = 'Tell the people about yourself!';
          } else {
            firstName = snapshot.data.documents[0].data['firstName'];
            lastName = snapshot.data.documents[0].data['lastName'];
            file = snapshot.data.documents[0].data['file'];
            aboutYou = snapshot.data.documents[0].data['aboutYou'];
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('User profile'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>EditProfilePage(database: widget.database,uid: widget.uid,)
                      ),
                    );
                  },
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Container(
              child: SingleChildScrollView(
                child: SizedBox(
                  height:  MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          color: Colors.deepOrange,
                          child: Center(
                            child: CircularProfileAvatar(
                              ' ',
                              radius: 80,
                              borderColor: Colors.white,
                              borderWidth: 5,
                              elevation: 8,
                              child: file == null
                                  ? Image.asset('images/placeholder.jpg')
                                  : Image.network(
                                      file,
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
                                                    loadingProgress.expectedTotalBytes
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                firstName +" "+ lastName,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 40,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Age: 20',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                aboutYou,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),

                              _buildPujaList(widget.database),

                              // BuildPuja(database: database)
                            ],
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Widget _buildPujaList(DatabaseL databse) {
  String name;
  int rate;
  return StreamBuilder<QuerySnapshot>(
      stream: databse.getPujaOfferingList,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
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
            border: Border.all(color: Colors.grey[300], width: 2),
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Puja you offer ',
                style: TextStyle(fontSize: 18, color: Colors.deepOrange),
              ),
              Divider(
                thickness: 2,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    name = snapshot.data.documents[index].data['puja'];
                    rate = snapshot.data.documents[index].data['price'];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Text(
                            '$rate₹',
                            style: TextStyle(color: Colors.green, fontSize: 16),
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
