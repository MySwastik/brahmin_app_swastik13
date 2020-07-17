import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseL {
  Future<void> setData({
    @required Map<String, dynamic> data,
  });

  Stream<QuerySnapshot> get getPujaOfferingList;

  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  });

  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
  });

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
    String path = 'Users/$uid/user_profile/user_data';
    String path1 = 'Avaliable_pundit/$uid';
    final reference = Firestore.instance.document(path);
    final reference1 = Firestore.instance.document(path1);
    await reference.setData(data);
    await reference1.setData(data);
    print('$path: $data');
  }

  Future<void> deletepuja(String id) async {
    Firestore.instance.document('Users/$uid/puja_offering/$id').delete();
  }

  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'Avaliable_pundit/$uid';
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
  }) async {
    String path1 = 'Avaliable_pundit/$uid/puja_offering/$id';
    String path = 'Users/$uid/puja_offering/$id';
    final reference1 = Firestore.instance.document(path1);
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
    await reference1.setData(data);
    print('$path: $data');
  }

  Stream<QuerySnapshot> get getUserData {
    return Firestore.instance.collection('Users/$uid/user_profile').snapshots();
  }

  Stream<QuerySnapshot> get getUsers {
    return Firestore.instance.collection('Avaliable_pundit').snapshots();
  }

  Stream<QuerySnapshot> get getPujaOfferingList {
    return Firestore.instance
        .collection('Users/$uid/puja_offering')
        .snapshots();
  }
}
