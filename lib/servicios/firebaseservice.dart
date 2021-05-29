import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userID;
  CollectionReference _refUser, _refKey, _refToken, _refMeGusta, _refCompletado, _refValorado, _refJuegosValorados;

  FirebaseService(this.userID){
    _refUser = _db.collection('usuarios');
    _refKey = _db.collection("key");
    _refToken = _db.collection("token");
    _refMeGusta = _db.collection("megusta");
    _refCompletado = _db.collection("completado");
    _refValorado = _db.collection("valorado");
    _refJuegosValorados = _db.collection("juegosvalorados");
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    return await _refUser.doc(userId).get();
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
      await _refMeGusta.doc(userID).set(data);
      DocumentSnapshot tempData = await _refMeGusta.doc(userID).get();
      return tempData.data().length;      
    }
  }

  Future<bool> comprobarMeGusta(String idJuego) async{
    DocumentSnapshot tempData = await _refMeGusta.doc(userID).get();

    if(tempData.data() != null){
      if(tempData.data().containsKey(idJuego)){
        return true;
      }else{
        return false;
      }
    }
    return false;
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

  Future<Map> getAllCompletado() async{
    QuerySnapshot completosDocument = await _refCompletado.get();
    QuerySnapshot usuariosDocument = await _refUser.get();
    List<QueryDocumentSnapshot> idUsuarios, idUsuariosCompletados;
    Map idUsuariosMerge = new Map();

    if(usuariosDocument != null){
      idUsuarios = usuariosDocument.docs;
    }

    if(completosDocument != null){
      idUsuariosCompletados = completosDocument.docs;
    }

    for(int i = 0; i < idUsuarios.length; i++){
      for (int j = 0; j < idUsuariosCompletados.length; j++){
        if(idUsuariosCompletados[j].id == idUsuarios[i].id){
          String nombre = idUsuarios[i].data()['usuario'];
          List idJuego = [];
          idUsuariosCompletados[j].data().entries.forEach((e){
            idJuego.add(e.key);
          });
          idUsuariosMerge[nombre] = idJuego;
        }
      }
    }
    
    
  var sortedMap = Map.fromEntries(
      idUsuariosMerge.entries.toList()
      ..sort((e1, e2) => (e2.value.length).compareTo(e1.value.length)));
  
    return sortedMap;
  }

  Future<void> removeCompletado(String idJuego) async{
    await _refCompletado.doc(userID).update({idJuego : FieldValue.delete()});
  }

  ///////////////////////////////////////////////////

  Future<void> addValorado(String idJuego, String nota, String comentario) async{
    var exits = await _refValorado.doc(userID).get();

    Map<String, Map<String, String>> dataUser = new Map<String, Map<String, String>>();
    Map<String, String> valoracionV = new Map<String, String>();

    valoracionV["nota"] = nota;
    valoracionV["comentario"] = comentario;

    dataUser[idJuego] = valoracionV;

    if(exits.exists){
      await _refValorado.doc(userID).update(dataUser);
    }else{
      await _refValorado.doc(userID).set(dataUser);     
    }

    var exitsIdJuego = await _refJuegosValorados.doc(idJuego).get();

    Map<String, Map<String, String>> data = new Map<String, Map<String, String>>();
    Map<String, String> valoracionJV = new Map<String, String>();

    valoracionJV["nota"] = nota;
    valoracionJV["comentario"] = comentario;

    data[userID] = valoracionJV;
    

    if(exitsIdJuego.exists){
      await _refJuegosValorados.doc(idJuego).update(data);
    }else{
      await _refJuegosValorados.doc(idJuego).set(data);
    }
  }

  Future<bool> comprobarValorado(String idJuego) async{
    DocumentSnapshot tempData = await _refValorado.doc(userID).get();

    if(tempData.data() != null){
      if(tempData.data().containsKey(idJuego)){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  Future<DocumentSnapshot> getValorado() async{
    DocumentSnapshot result = await _refValorado.doc(userID).get();

    return result;
  }

  Future<List> getNotaValorado(String id) async{
    DocumentSnapshot result = await _refValorado.doc(userID).get();
    List listResult = [];
    if(result.data() != null){
      listResult.add(result.data()[id]["nota"]);
      listResult.add(result.data()[id]["comentario"]);
      return listResult;
    }
    return [];
  }

  Future<double> getMediaValorado(String idJuego) async{
    DocumentSnapshot result = await _refJuegosValorados.doc(idJuego).get();
    double nota = 0;
    if(result.data() != null){
      result.data().values.forEach((element) {
        nota += double.parse(element["nota"]);
      });
      return nota / result.data().length;
    }
  }

  Future<List<Map<dynamic, dynamic>>> getValoradoId(String idJuego) async{
    DocumentSnapshot result = await _refJuegosValorados.doc(idJuego).get();
    DocumentSnapshot userResult;
    Map<dynamic, dynamic> finalResult = new Map<dynamic, dynamic>();
    List<Map<dynamic, dynamic>> userNotas = [];

    if(result.data() != null){
      for( var k in result.data().keys){
        userResult = await _refUser.doc(k).get();
        if(userResult.data() != null){
          finalResult = userResult.data();
          finalResult["nota"] = result.data()[k]["nota"];
          finalResult["comentario"] = result.data()[k]["comentario"];
          userNotas.add(finalResult);
        }
      }
    }
    return userNotas;
  }

  Future<void> removeValorado(String idJuego) async{
    await _refValorado.doc(userID).update({idJuego : FieldValue.delete()});
    
    DocumentSnapshot resultValorado = await _refValorado.doc(userID).get();
    if(resultValorado.data().isEmpty){
      await _refValorado.doc(userID).delete();
    }

    await _refJuegosValorados.doc(idJuego).update({userID : FieldValue.delete()});

    DocumentSnapshot resultJuegoValorado = await _refJuegosValorados.doc(idJuego).get();
    if(resultJuegoValorado.data().isEmpty){
      await _refJuegosValorados.doc(idJuego).delete();
    }
  }

}