import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService{

  final FirebaseAuth _fa = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signInEmail(String email, String password) async{
    return (await _fa.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future signInGoogle() async{
    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      if(googleUser != null){
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        User user = (await _fa.signInWithCredential(credential)).user;
        return user;
      }
    }catch(e){
      print(e);
    }
  }

  Future<User> createUser(String email, String password) async{
    return (await _fa.createUserWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<User> getCurrentUser() async{
    User user = _fa.currentUser;
    return user;
  }

  void newPassword(String email) async{
    await _fa.sendPasswordResetEmail(email: email);
  }

  void _changePassword(String password) async{
    User user = await getCurrentUser();
    user.updatePassword(password);
  }

  /*Future<void> updateUser(String email, String nombre) async{
    User user = await getCurrentUser();
    UserUpdateInfo userUpdate = new UserUpdateInfo();
    userUpdate.displayName = nombre;
    return await user.updateEmail(email);
    //user.reload();

  }*/

  void cerrarSesion(){
    googleSignIn.signOut();
    _fa.signOut();
  }

  void cerrarSesionGoogle() async{
    await googleSignIn.signOut();
  }

} 