import 'package:aisect_custom/Authenticate/Methods.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/admissionOnStart/AdmissionOnStart.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Home/HomePage copy.dart';
import 'LoginScree.dart';

class CreateAccount extends StatefulWidget {
  final isAdmission;

  const CreateAccount({Key? key, required this.isAdmission}) : super(key: key);
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  final RegExp aadharRegex =
      new RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  bool isLoading = false;

  bool _obscureText = true;
  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // body: isLoading
      //     ? Center(
      //         child: Container(
      //           height: size.height / 20,
      //           width: size.height / 20,
      //           child: CircularProgressIndicator(),
      //         ),
      //       )
      //     : showWidget(size, context),
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        return model.isOnline
            ? isLoading
                ? Center(
                    child: Container(
                      height: size.height / 20,
                      width: size.height / 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : showWidget(size, context)
            : NoInternet();
      }),
    );
  }

  SingleChildScrollView showWidget(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: size.width / 0.5,
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          Container(
            width: size.width / 1.1,
            child: Text(
              "Introduce Yourself",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: size.width / 1.1,
            child: Text(
              "we keep this information private",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: field(size, "Name", Icons.account_box, _name, false),
            ),
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: field(size, "email", Icons.account_box, _email, false),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: Stack(children: [
                field(size, "password", Icons.lock, _password, _obscureText),
                Positioned(
                  top: 2,
                  right: 10,
                  child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              // width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 10,
                width: size.width / 1.1,
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: _phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_box),
                        hintText: "phone no",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (val) {
                        if (!phoneRegex.hasMatch(val!)) {
                          return "Not Valid";
                        }
                        return null;
                      },
                    )),
              ),
              // child: field(
              //     size, "aadhar", Icons.account_box, _aadhar, false),
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          customButton(size, widget.isAdmission),
          Container(
              height: size.height / 14,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white38),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account? ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  isAdmission: false,
                                ))),
                    child: Text(
                      " LOGIN",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionRef =
      _firestore.collection("Raw_students_info");
  //! creating user
  Future createUser() async {
    try {
      await _userCollectionRef.doc(constuid).set({
        'full name': _name.text,
        'Phone No': _phone.text,
        'role': 'student'
      });
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong!"),
      ));
    }
  }

  static final CollectionReference _userCollectionRefForAdmission =
      _firestore.collection("New_Admission_Request");
  //! creating user
  Future createUserForAdmission() async {
    try {
      await _userCollectionRefForAdmission.doc(constuid).set({
        'full name': _name.text,
        'Phone No': _phone.text,
        'email': _phone.text,
        'isAdmissionDone': false,
        'role': 'For Admission',
        "admission - section": true,
        'ProfileUrl':
            'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/StudentProfileImg%2FEEFEZxEPLoTm0byR3wJZVIyCIJ62%2Fimage_picker9094997287726926097.gif?alt=media&token=6c9e4b36-a9d9-4acb-b2d9-0bda4c66bb3c'
      });
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong!"),
      ));
    }
  }

  Widget customButton(Size size, bool isAdmission) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty &&
            _phone.text.isNotEmpty &&
            phoneRegex.hasMatch(_phone.text)) {
          setState(() {
            isLoading = true;
          });

          if (isAdmission == false) {
            createAccount(_name.text, _email.text, _password.text, _phone.text)
                .then((user) {
              if (user != null) {
                setState(() {
                  isLoading = false;
                });
                // createUser();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePageNav()));
                print("Account Created Sucessfull");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Account created Sucessfully!"),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Email not valid!"),
                ));
                print("Login Failed");
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            createAccountForAdmission(
                    _name.text, _email.text, _password.text, _phone.text)
                .then((user) {
              if (user != null) {
                setState(() {
                  isLoading = false;
                });
                // createUser();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => AdmissionHome()));
                print("Account Created For admission Sucessfull");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Account created Sucessfully!"),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Email not valid!"),
                ));
                print("Login Failed");
                setState(() {
                  isLoading = false;
                });
              }
            });
          }
        } else {
          print("Please Fill all Fields");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please Fill all feilds correctly!"),
          ));
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.deepOrange),
          alignment: Alignment.center,
          child: const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(Size size, String hintText, IconData icon,
      TextEditingController cont, bool obsc) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        obscureText: obsc,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
