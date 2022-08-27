import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'LoginScree.dart';
import 'Methods.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  final TextEditingController _search = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  @override
  void dispose() {
    super.dispose();
    _search.dispose();
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
      appBar: AppBar(
        title: Text("Reset Password"),
        leading: InkWell(
          onTap: () {
            Get.to(LoginScreen());
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Put email to reset",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    resetPassword(_search.text);
                    _search.clear();
                    Get.off(LoginScreen, transition: Transition.cupertino);
                  },
                  child: Text("Reset"),
                ),
              ],
            ),
    );
  }
}
