import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherUser extends StatefulWidget {
  final String profilePic;
  final String firstName;
  final String aboutYou;
  final String lastName;

  const OtherUser(
      {Key key,
      @required this.profilePic,
      @required this.firstName,
      @required this.aboutYou,
      @required this.lastName})
      : super(key: key);

  @override
  _OtherUserState createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                CircularProfileAvatar(
                  'G',
                  animateFromOldImageOnUrlChange: true,
                  child: Image.network(
                    widget.profilePic,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  radius: 70,
                  borderWidth: 1,
                  borderColor: Colors.deepOrange,
                  elevation: 8,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.firstName + " " + widget.lastName,
                  style: TextStyle(fontSize: 40, color: Colors.black54),
                ),
                Text(
                  widget.aboutYou,
                  style: TextStyle(fontSize: 30, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
