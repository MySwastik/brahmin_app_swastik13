import 'dart:io';
import 'package:brahminapp/common_widgets/image_picker_handmade.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class EditAndCreateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditAndCreateProfileState();
  }
}

class EditAndCreateProfileState extends State<EditAndCreateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _url;
  DateTime _dateTime;
  File _selectedFile =ImageFile().get();

  Widget _profilePic() {
    return CircularProfileAvatar(
      '',
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImagePickerHandmade(),
          ),
        );
      },
      child: _selectedFile != null
          ? Image.file(_selectedFile)
          : Image.asset("images/placeholder.jpg"),
      borderColor: Colors.indigo,
      borderWidth: 5,
      elevation: 5,
      radius: 50,
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildAboutYou() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'About You'),
      keyboardType: TextInputType.multiline,
      validator: (String value) {
        if (value.isEmpty) {
          return 'About you is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildSpecialisation() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Specialization'),
      keyboardType: TextInputType.multiline,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Specialization is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildAge() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Age'),
        keyboardType: TextInputType.multiline,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Specialization is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _url = value;
        },
      ),
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
          color: Colors.indigo,
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

  Widget _buildSubmit() {
    return RaisedButton(
      child: Text(
        'Submit',
        style: TextStyle(color: Colors.blue, fontSize: 16),
      ),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }

        _formKey.currentState.save();

        print(_name);
        print(_email);
        // print(_phoneNumber);
        print(_url);
        print(_password);
        // print(_calories);

        //Send to API
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
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
                  _profilePic(),
                  SizedBox(height: 5,),
                  Divider(
                    height: 2,
                  ),
                  _buildName(),
                  _buildAboutYou(),
                  _buildDobPicker(),
                  SizedBox(height: 50),
                  _buildSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
