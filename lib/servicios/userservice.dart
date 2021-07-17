import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService{

  final FirebaseAuth _fa = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signInEmail(String email, String password) async{
    UserCredential userCredential = await _fa.signInWithEmailAndPassword(email: email, password: password).catchError((error){
      throw Exception(error);
    });
    return userCredential.user;
  }

  Future<User> signInGoogle() async{

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if(googleUser != null){
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential user = await _fa.signInWithCredential(credential).catchError((error){
        throw Exception(error);
      });
      return user.user;
    }

  }

  Future<User> createUser(String email, String password) async{
    UserCredential userCredential = await _fa.createUserWithEmailAndPassword(email: email, password: password).catchError((error){
      throw Exception(error);
    });
    return userCredential.user;
  }

  Future<User> getCurrentUser() async{
    User user = _fa.currentUser;
    return user;
  }

  void newPassword(String email) async{
    await _fa.sendPasswordResetEmail(email: email);
  }

  Future<void> cerrarSesion() async{
    await googleSignIn.signOut();
    await _fa.signOut();
  }

  void cerrarSesionGoogle() async{
    await googleSignIn.signOut();
  }

} 