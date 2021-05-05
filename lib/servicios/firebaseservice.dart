import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userID;
  CollectionReference _refUser, _refKey, _refToken, _refMeGusta, _refCompletado;

  FirebaseService(this.userID){
    _refUser = _db.collection('usuarios');
    _refKey = _db.collection("key");
    _refToken = _db.collection("token");
    _refMeGusta = _db.collection("megusta");
    _refCompletado = _db.collection("completado");
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

  //////////////////////////////////////////////
  
  Future<int> addMeGusta(Map data) async{
    var exits = await _refMeGusta.doc(userID).get();
    if(exits.exists){
      await _refMeGusta.doc(userID).update(data);
      DocumentSnapshot tempData = await _refMeGusta.doc(userID).get();
      return tempData.data().length;
    }else{
      await _refMeGusta.doc(userID).update(data);
      DocumentSnapshot tempData = await _refMeGusta.doc(userID).get();
      return tempData.data().length;      
    }
  }

  Future<bool> comprobarMeGusta(String idJuego) async{
    DocumentSnapshot tempData = await _refMeGusta.doc(userID).get();

    if(tempData.data().containsKey(idJuego)){
      return true;
    }else{
      return false;
    }
  }

  Future<DocumentSnapshot> getMeGusta() async{
    DocumentSnapshot result = await _refMeGusta.doc(userID).get();

    return result;
  }

  Future<void> removeMeGusta(String idJuego) async{
    await _refMeGusta.doc(userID).update({idJuego : FieldValue.delete()});
  }

  //////////////////////////////////////////////
  
  Future<int> addCompletado(Map data) async{
    var exits = await _refCompletado.doc(userID).get();
    if(exits.exists){
      await _refCompletado.doc(userID).update(data);      
      DocumentSnapshot tempData = await _refCompletado.doc(userID).get();
      return tempData.data().length;
    }else{
      await _refCompletado.doc(userID).set(data);
      DocumentSnapshot tempData = await _refCompletado.doc(userID).get();
      return tempData.data().length;
    }
  }

  Future<bool> comprobarCompletado(String idJuego) async{
    DocumentSnapshot tempData = await _refCompletado.doc(userID).get();

    if(tempData.data() != null) {
      if(tempData.data().containsKey(idJuego)){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  Future<DocumentSnapshot> getCompletado() async{
    DocumentSnapshot result = await _refCompletado.doc(userID).get();

    return result;
  }

  Future<DocumentSnapshot> getAllCompletado() async{
    
  }

  Future<void> removeCompletado(String idJuego) async{
    await _refCompletado.doc(userID).update({idJuego : FieldValue.delete()});
  }

}