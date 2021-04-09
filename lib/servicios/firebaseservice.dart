import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userID;
  CollectionReference _refUser;
  CollectionReference _refKey;
  CollectionReference _refToken;

  FirebaseService(this.userID){
  //  ref = _db.collection('usuarios').document(userID).collection('notas');
    _refUser = _db.collection('usuarios');
    _refKey = _db.collection("key");
    _refToken = _db.collection("token");
  }

/*  Future<QuerySnapshot> getDataCollection(){
    return ref.doc(userID).collection('notas').get();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.doc(userID).collection('notas').orderBy('fecha', descending: true).snapshots();
  }

  Stream<QuerySnapshot> streamDataImportant(){
    return ref.doc(userID).collection('notas').where('importante', isEqualTo: true).orderBy('fecha', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) async{
    return await ref.doc(userID).collection('notas').doc(id).get();
  }

  Future<void> removeDocument(String id) async{
    return await ref.doc(userID).collection('notas').doc(id).delete();
  }

  Future<DocumentSnapshot> addDocument(Map data) async{
    String id = ref.doc(userID).collection('notas').doc().id; // Crea documento nuevo sin datos, pero con ID aleatorio
    await ref.doc(userID).collection('notas').doc(id).set(data); // Sobreescribe todos los datos
    return await getDocumentById(id); // Devuelve el Snapshot con los datos actualizados
  }

  Future<void> updateDocument(Map data, String id) async{
    return await ref.doc(userID).collection('notas').doc(id).update(data);
  }*/

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

  void addCollection() async{
    _refUser.doc(userID).collection("notas");
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