import 'package:aisect_custom/widget/customDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

// a simple sialog to be visible everytime some error occurs
// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//       builder: (context) => AlertDialog(
//           title: Text("Error"),
//           content: Text(err),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Ok"),
//             ),
//           ],
//         ),
//       context: context);

// }

// many unhandled google error exist
// will push them soon
// Future<bool> googleSignIn() async {
//   GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     AuthCredential credential = GoogleAuthProvider.getCredential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     AuthResult result = await auth.signInWithCredential(credential);

//     FirebaseUser user = await auth.currentUser();
//     print(user.uid);

//     return Future.value(true);
//   }
// }

Future<User?> signInWithGoogleFun() async {
  try {
    //SIGNING IN WITH GOOGLE
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    //CREATING CREDENTIAL FOR FIREBASE
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    //SIGNING IN WITH CREDENTIAL & MAKING A USER IN FIREBASE  AND GETTING USER CLASS
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    //CHECKING IS ON
    assert(!user!.isAnonymous);

    final User? currentUser = await _auth.currentUser;
    assert(currentUser!.uid == user!.uid);

    // print(user);
    return user;
  } catch (e) {
    print(e);
  }
  return null;
}

// instead of returning true or false
// returning user to directly access UserID
Future signUp({required String email, required String password}) async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}

//SIGN IN METHOD
Future<bool> signIn({required String email, required String password}) async {
  try {
    (await _auth.signInWithEmailAndPassword(email: email, password: password));
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        AdvanceDialog(
          title: "Error",
          s: e.code,
        );
        break;
      case 'ERROR_WRONG_PASSWORD':
        AdvanceDialog(
          title: "Error",
          s: e.code,
        );
        break;
      case 'ERROR_USER_NOT_FOUND':
        AdvanceDialog(
          title: "Error",
          s: e.code,
        );
        break;
      case 'ERROR_USER_DISABLED':
        AdvanceDialog(
          title: "Error",
          s: e.code,
        );
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        AdvanceDialog(
          title: ("Error"),
          s: e.code,
        );
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        AdvanceDialog(
          title: ("Error"),
          s: e.code,
        );
        break;
    }
    return Future.value(true);
  }
}
//new

//  Future<User?> registerUsingEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;
//     try {
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       user = userCredential.user;
//       await user!.updateDisplayName(name);
//       await user.reload();
//       user = auth.currentUser;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//         AdvanceDialog(
//           title: Text("Error"),
//           s: e.code,
//         );
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//         AdvanceDialog(
//           title: Text("Error"),
//           s: e.code,
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//     return user;
//   }

//SIGN OUT METHOD
Future signOut() async {
  // await _auth.signOut();
  final User? currentUser = await _auth.currentUser;
  try {
    if (currentUser!.providerData[0].providerId == 'google.com') {
      print("in if condn");
      await GoogleSignIn().signOut();
      // await googleSignIn.disconnect();
    } else {
      print("in else condn");
      await FirebaseAuth.instance.signOut();
    }
  } catch (e) {
    print("$e");
  } // print(currentUser!.providerData[1].providerId);

  // await _auth.signOut();

  print('signout');
}
// Future<User> signin(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result =
//         await _auth.signInWithEmailAndPassword(email: email, password: email);
//     User user = result.user;
//     // return Future.value(true);
//     return Future.value(user);
//   } catch (e) {
//     // simply passing error code as a message
//     print(e.code);
//     switch (e.code) {
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_DISABLED':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         showErrDialog(context, e.code);
//         break;
//     }
//     // since we are not actually continuing after displaying errors
//     // the false value will not be returned
//     // hence we don't have to check the valur returned in from the signin function
//     // whenever we call it anywhere
//     return Future.value(null);
//   }
// }

// // change to Future<FirebaseUser> for returning a user
// Future<User> signUp(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result = await auth.createUserWithEmailAndPassword(
//         email: email, password: email);
//     FirebaseUser user = result.user;
//     return Future.value(user);
//     // return Future.value(true);
//   } catch (error) {
//     switch (error.code) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         showErrDialog(context, "Email Already Exists");
//         break;
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, "Invalid Email Address");
//         break;
//       case 'ERROR_WEAK_PASSWORD':
//         showErrDialog(context, "Please Choose a stronger password");
//         break;
//     }
//     return Future.value(null);
//   }
// }

// void signOut() async
// {
//   await googleSignIn.signOut();
//   await _auth.signOut();
// }
