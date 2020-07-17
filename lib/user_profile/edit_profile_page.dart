import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/user_profile/build_puja.dart';
import 'package:brahminapp/user_profile/image_selecter.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final DatabaseL database;
  final uid;

  const EditProfilePage({Key key, @required this.database, @required this.uid})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  DateTime _dateTime;
  String _aboutYou;
  String firstName;
  String lastName;
  String file;
  String aboutYou;

  Widget _buildFirstName(String defaultName) {
    return TextFormField(
      initialValue: defaultName,
      decoration: InputDecoration(labelText: 'First name'),
      maxLength: 20,
      validator: (String value) {
        if (value.isEmpty) {
          return 'First name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }

  Widget _buildLastName(String defaultName) {
    return TextFormField(
      initialValue: defaultName,
      decoration: InputDecoration(labelText: 'Last name'),
      maxLength: 20,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _lastName = value;
      },
    );
  }

  Widget _buildAboutYou(String aboutYou) {
    return TextFormField(
      initialValue: aboutYou,
      decoration: InputDecoration(labelText: 'About You'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'About you is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _aboutYou = value;
      },
    );
  }

  Widget _buildDobPicker() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Date of Birth',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            Container(
              child: Text(
                _dateTime == null ? 'DD/MM/YY' : '$_dateTime',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.date_range),
          color: Colors.deepOrange,
          iconSize: 45,
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2021))
                .then((date) {
              setState(() {
                _dateTime = date;
              });
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmit(DatabaseL database) {
    return FlatButton(
      child: Text(
        'Submit',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        database.setData(data: {
          'firstName': _firstName,
          'lastName': _lastName,
          'aboutYou': _aboutYou,
          'file': file,
          'uid': widget.uid,
          'swastik': 0,
        });
        Navigator.of(context).pop();
      },
    );
  }

  _navigation() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ImageSelector(
                database: widget.database,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            firstName = '';
            lastName = '';
            file = null;
            aboutYou = '';
          } else {
            firstName = snapshot.data.documents[0].data['firstName'];
            lastName = snapshot.data.documents[0].data['lastName'];
            file = snapshot.data.documents[0].data['file'];
            aboutYou = snapshot.data.documents[0].data['aboutYou'];
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              centerTitle: true,
              actions: <Widget>[
                _buildSubmit(widget.database),
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: CircularProfileAvatar(
                            'G',
                            animateFromOldImageOnUrlChange: true,
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
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                            radius: 70,
                            borderWidth: 5,
                            borderColor: Colors.deepOrange,
                            elevation: 8,
                          ),
                          onTap: () {
                            _navigation();
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 2,
                        ),
                        _buildFirstName(firstName),
                        _buildLastName(lastName),
                        _buildAboutYou(aboutYou),
                        _buildDobPicker(),
                        SizedBox(height: 50),
                        //_buildSubmit(database),
                        BuildPuja(
                          database: widget.database,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
