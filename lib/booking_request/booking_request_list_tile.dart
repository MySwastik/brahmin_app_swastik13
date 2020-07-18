import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingRequestListTile extends StatefulWidget {
  final name;
  final service;
  final date;
  final time;
  final picUrl;
  final tuid;
  final tid;
  final uid;

  const BookingRequestListTile(
      {Key key,
      @required this.name,
      @required this.service,
      @required this.date,
      @required this.time,
      @required this.picUrl,
      @required this.tuid,
      @required this.tid,
      @required this.uid})
      : super(key: key);

  @override
  _BookingRequestListTileState createState() => _BookingRequestListTileState();
}

class _BookingRequestListTileState extends State<BookingRequestListTile> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseL>(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircularProfileAvatar(
            'G',
            animateFromOldImageOnUrlChange: true,
            child: Image.network(
              widget.picUrl,
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
            radius: 40,
            borderWidth: 1,
            borderColor: Colors.deepOrange,
            elevation: 8,
          ),
          Column(
            children: <Widget>[
              Text(widget.name, style: TextStyle(color: Colors.black54)),
              Text(widget.service, style: TextStyle(color: Colors.black54)),
              Column(
                children: <Widget>[
                  Text(widget.date, style: TextStyle(color: Colors.black54)),
                  Text(widget.time, style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                onPressed: () {
                  database.updateBooking(
                      tuid: widget.tuid, tid: widget.tid, response: true);
                },
              ),
              FlatButton(
                child: Text(
                  'Decline',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
