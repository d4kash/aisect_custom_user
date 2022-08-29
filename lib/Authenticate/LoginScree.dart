import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/admissionOnStart/AdmissionOnStart.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'CreateAccount.dart';
import 'ForgotPassword.dart';
import 'Methods.dart';

class LoginScreen extends StatefulWidget {
  final isAdmission;

  const LoginScreen({
    Key? key,
    this.isAdmission,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  RxBool isLoading = false.obs;
  RxBool _obscureText = true.obs;
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
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
      // body:
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        // print(context.watch<ConnectivityProvider>());

        return model.isOnline
            ? Obx(() => isLoading.isTrue
                ? Center(
                    child: Container(
                      height: size.height / 20,
                      width: size.height / 20,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : showWidget(size, context))
            : NoInternet();
      }),
    );
  }

  final formGlobalKey = GlobalKey<FormState>();
  SingleChildScrollView showWidget(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formGlobalKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(
              height: size.height / 10,
            ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   width: size.width / 0.5,
            //   child:
            //       IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
            // ),
            SizedBox(
              height: size.height / 50,
            ),
            Container(
              width: size.width / 1.1,
              child: const Text(
                "Identify yourself!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: size.width / 1.1,
              child: Text(
                "To get entry in your house!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Container(
              width: size.width,
              alignment: Alignment.center,
              child: field(size, "email", Icons.account_box, _email, false,
                  (value) {
                return GetUtils.isEmail(value!) ? null : 'Enter valid email';
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Obx(() => Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: Stack(children: [
                      field(size, "password", Icons.lock, _password,
                          _obscureText.value, (value) {
                        return null;
                      }),
                      Positioned(
                        top: 2,
                        right: 10,
                        child: IconButton(
                            icon: Icon(
                              _obscureText.isTrue
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // setState(() {
                              _obscureText.value = !_obscureText.value;
                              // });
                            }),
                      ),
                    ]),
                  )),
            ),
            SizedBox(
              height: size.height / 10,
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
                    InkWell(
                      onTap: () => Get.to(() => ForgotPassword(),
                          transition: Transition.cupertino),
                      child: const Text(
                        " Forgot Password",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: size.height / 40,
            ),
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
                    const Text(
                      "Don't have account? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.to(
                          () => CreateAccount(
                                isAdmission: widget.isAdmission,
                              ),
                          transition: Transition.cupertino),
                      child: const Text(
                        " SIGNUP",
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
      ),
    );
  }

  Widget customButton(Size size, bool isAdmission) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          // setState(() {
          isLoading.value = true;
          // });

          if (isAdmission == false) {
            logIn(_email.text.trim(), _password.text.trim()).then((user) {
              if (user != null) {
                print("Login Sucessfull");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("welcome to your house!"),
                ));
                // setState(() {
                isLoading.value = false;
                // });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomePageNav())); //HomePageNav
              } else {
                print("Login Failed");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("you are not identified by our member!"),
                ));
                // setState(() {
                isLoading.value = false;
                // });
              }
            });
          } else {
            logInAdmission(_email.text.trim(), _password.text.trim())
                .then((user) {
              if (user != null) {
                print("Login Sucessfull Admission");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("welcome to your house!"),
                ));
                // setState(() {
                isLoading.value = false;
                // });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AdmissionHome()),
                  (route) => false,
                ); //HomePageNav
              } else {
                print("Login Failed");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("you are not identified by our member!"),
                ));
                // setState(() {
                isLoading.value = false;
                // });
              }
            });
          }
        } else {
          print("Please fill form correctly");
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
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size,
      String hintText,
      IconData icon,
      TextEditingController cont,
      bool obsc,
      String? Function(String?)? validator) {
    return Container(
      height: size.height / 10,
      width: size.width / 1.1,
      child: TextFormField(
        controller: cont,
        obscureText: obsc,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
