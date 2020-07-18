import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPuja extends StatefulWidget {
  final DatabaseL database;

  const AddPuja({Key key, @required this.database}) : super(key: key);

  @override
  _AddPujaState createState() => _AddPujaState();
}

class _AddPujaState extends State<AddPuja> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        widget.database.setPujaOffering(data: {
          'puja': _name,
          'price': _ratePerHour,
          'Benefit':
              'The significance or benefits of performing Lakshmi pooja are as given below: Family life becomes more harmonious– To each & every person in the world, their families are the most treasured people. Performing Lakshmi pooja with all the family members creates a sense of harmony & ensures a peaceful environment at home',
          'PanditD':
              '2 pandit will come .One will be purohit and one will be in practice pandit',
          'Pujan Samagri':
              'दिवाली पूजा के लिए रोली यानी टीका, चावल (अक्षत), पान-सुपारी, लौंग, इलायची, धूप, कपूर, घी, तेल, दीपक, कलावा, नारियल, गंगाजल, फल, फूल, मिठाई, दूर्वा, चंदन, मेवे, खील, बताशे, चौकी, कलश, फूलों की माला, शंख, लक्ष्मी-गणेश की मूर्ति, थाली, चांदी का सिक्का, 11 दिए और इससे ज्यादा दिये अपनी श्रृद्धानुसार एकत्रित कर लें।',
          'time': '30min',
        });
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Add Puja'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              _submit();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Puja name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
