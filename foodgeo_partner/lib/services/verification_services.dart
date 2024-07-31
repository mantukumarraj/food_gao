import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerficationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final databaseName="restaurants";


  Future<void> insertData( bool value) async {
    var uuid = auth.currentUser?.uid;

    await _firestore.collection(databaseName).doc(uuid).set({"name": value});
  }

  Future<void> updateData( bool value) async {
    var uuid = auth.currentUser?.uid;
    await _firestore.collection(databaseName).doc(uuid).update({"name": value});
  }

  Stream<DocumentSnapshot> getDataStream(String uuid) {
    return _firestore.collection(databaseName).doc(uuid).snapshots();
  }
}