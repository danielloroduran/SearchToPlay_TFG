import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  FirebaseStorage _db = FirebaseStorage.instance;
  Reference _reference;
  UploadTask _uploadTask;
  final String userId;


  StorageService(this.userId);

  Future<String> subirFotoPerfil(File imagen) async{
    String url = "";
    _reference = _db.ref().child("/"+userId+"/perfil.jpg");
    _uploadTask = _reference.putFile(imagen);
    url = await (await _uploadTask).ref.getDownloadURL();
    return url;
  }

  Future borrarFotoPerfil(String path) async{
    _db.ref().child(path).delete();
  }
}