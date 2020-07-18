import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseL {
  Future<void> setData({
    @required Map<String, dynamic> data,
  });

  Future<void> updateBooking(
      {@required String tuid, @required String tid, @required bool response});

  Stream<QuerySnapshot> get getPujaOfferingList;

  Stream<QuerySnapshot> get getBookingRequest;

  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  });

  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
  });

  Future<void> bookingStatus(
      {@required Map<String, dynamic> data,
      @required String tuid,
      @required tid});

  Stream<QuerySnapshot> get getUserData;

  Future<void> deletepuja(String id);

  Stream<QuerySnapshot> get getUsers;
}

class FireStoreDatabase implements DatabaseL {
  FireStoreDatabase({@required this.uid});

  final dynamic uid;
  final id = DateTime.now();

  Future<void> setData({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'punditUsers/$uid/user_profile/user_data';
    String path1 = 'Avaliable_pundit/$uid';
    final reference = Firestore.instance.document(path);
    final reference1 = Firestore.instance.document(path1);
    await reference.setData(data);
    await reference1.setData(data);
    print('$path: $data');
  }

  Future<void> deletepuja(String pid) async {
    Firestore.instance.document('punditUsers/$uid/puja_offering/$pid').delete();
  }

  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'Avaliable_pundit/$uid';
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> bookingStatus(
      {@required Map<String, dynamic> data,
      @required String tuid,
      @required tid}) async {
    String path = 'users/$tuid/bookings/$tid';
    String path1 = 'punditUsers/$uid/bookingrequest/$tid';

    final reference = Firestore.instance.document(path);
    final reference1 = Firestore.instance.document(path1);
    print('$path: $data');
    await reference.setData(data);
    await reference1.setData(data);
  }

  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
  }) async {
    final pid = DateTime.now();
    String path1 = 'Avaliable_pundit/$uid/puja_offering/$pid';
    String path = 'punditUsers/$uid/puja_offering/$pid';
    final reference1 = Firestore.instance.document(path1);
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
    await reference1.setData(data);
    print('$path: $data');
  }

  Stream<QuerySnapshot> get getUserData {
    return Firestore.instance
        .collection('punditUsers/$uid/user_profile')
        .snapshots();
  }

  Stream<QuerySnapshot> get getUsers {
    return Firestore.instance.collection('Avaliable_pundit').snapshots();
  }

  Stream<QuerySnapshot> get getPujaOfferingList {
    return Firestore.instance
        .collection('punditUsers/$uid/puja_offering')
        .snapshots();
  }

  Stream<QuerySnapshot> get getBookingRequest {
    return Firestore.instance
        .collection('punditUsers/$uid/bookingrequest')
        .snapshots();
  }

  Future<void> updateBooking(
      {@required String tuid, @required String tid, @required bool response}) {
    Firestore.instance
        .collection('punditUsers/$uid/bookingrequest')
        .document(tid)
        .updateData({'request': response});
    Firestore.instance
        .collection('users/$tuid/bookings')
        .document(tid)
        .updateData({'request': response});
  }
}
