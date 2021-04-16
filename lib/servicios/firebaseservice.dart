import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userID;
  CollectionReference _refUser;
  CollectionReference _refKey;
  CollectionReference _refToken;

  FirebaseService(this.userID){
    _refUser = _db.collection('usuarios');
    _refKey = _db.collection("key");
    _refToken = _db.collection("token");
  }

  Future<DocumentSnapshot> getUserById() async {
    return await _refUser.doc(userID).get();
  }

  Future<void> addUser(Map data) async{
    await _refUser.doc(userID).set(data); // Crea el usuario con su ID
  }

  Future <void> removeUser() async{
    return await _refUser.doc(userID).delete();
  }

  Future<void> updateUser(Map data) async{
    return await _refUser.doc(userID).update(data);
  }

  //////////////////////////////////////////////
  
  Future<DocumentSnapshot> getKey() async{
    return await _refKey.doc("idkey").get();
  }

  //////////////////////////////////////////////
  
  Future<DocumentSnapshot> getAppToken() async{
    return await _refToken.doc("idtoken").get();
  }

    Future<void> updateAppToken(Map data) async{
    return await _refToken.doc("idtoken").update(data);
  }
}