import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'booking_request_list_tile.dart';

class BookingRequestPage extends StatefulWidget {
  final uid;

  const BookingRequestPage({Key key, this.uid}) : super(key: key);

  @override
  _BookingRequestPageState createState() => _BookingRequestPageState();
}

class _BookingRequestPageState extends State<BookingRequestPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<UserId>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final UserId userId = snapshot.data;
          return StreamBuilder<QuerySnapshot>(
              stream: FireStoreDatabase(uid: userId.uid).getBookingRequest,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Scaffold(
                  body: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        final String name = snapshot
                            .data.documents[index].data['client']
                            .toString();
                        final String service = snapshot
                            .data.documents[index].data['service']
                            .toString();
                        final String picUrl = snapshot
                            .data.documents[index].data['pic']
                            .toString();
                        final String date = snapshot
                            .data.documents[index].data['date']
                            .toString();
                        final String time = snapshot
                            .data.documents[index].data['time']
                            .toString();
                        final String tid =
                            snapshot.data.documents[index].documentID;
                        final String tuid =
                            snapshot.data.documents[index].data['clientid'];
                        return Provider<DatabaseL>(
                          builder: (contex) =>
                              FireStoreDatabase(uid: userId.uid),
                          child: BookingRequestListTile(
                            name: name,
                            service: service,
                            picUrl: picUrl,
                            date: date,
                            time: time,
                            tid: tid,
                            tuid: tuid,
                            uid: userId.uid,
                          ),
                        );
                      }),
                );
              });
        });
  }
}
