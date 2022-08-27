import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:aisect_custom/services/LocalData.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/customDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import '../../google/widget/sign_up_widget.dart';
import 'AlertDialogWidget.dart';

class BiometricAuth extends StatefulWidget {
  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  late bool canCheckBiometrics;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  // String uid1 = "no user";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    await _getAvailableBiometrics();
    await _checkBiometrics();

    await _authenticateWithBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print({"canCheckBiometrics $canCheckBiometrics"});
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      showAlertDialogForNoSensorFound(context);
      Fluttertoast.showToast(msg: "No biometric auth found");
      Timer(
          const Duration(milliseconds: 30),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => SignUpWidget()), //HomePageForAuth
              (route) => false));
      print("e: $e");
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      AdvanceDialog(
          title: "Biometric Error", s: " You have no Fingerprint ${e.message}");
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        // useErrorDialogs: true,
        // stickyAuth: true
      );
      setState(() {
        _isAuthenticating = false;
      });
      // initializeUser();
      //Check if condition true then next page comes up
      if (authenticated == true) {
        var data = await LocalData.getName();
        if (data == "admission") {
          Timer(
              const Duration(milliseconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AdmissionHome()),
                  (route) => false));
        } else {
          Timer(
              const Duration(milliseconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePageNav()),
                  (route) => false));
          print("authenticated called on true");
        }
      } else {
        Timer(
            const Duration(milliseconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignUpWidget()),
                (route) => false));
      }
    } on PlatformException catch (e) {
      print("e: ${e.toString()}");

      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or Pin/Password) to authenticate',
        // useErrorDialogs: true,
        // stickyAuth: true,
        // biometricOnly: false
      );
      print({"authenticated $authenticated"});
      // initializeUser();
      //Check if condition true then next page comes up
      if (authenticated == true) {
        const SpinKitChasingDots(color: Colors.white);
        Timer(
            const Duration(milliseconds: 200),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePageNav()),
                (route) => false));
        print("authenticated called on true");
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        // Timer(
        //     Duration(milliseconds: 3),
        //     () => Navigator.of(context).pushAndRemoveUntil(
        //         MaterialPageRoute(builder: (context) => HomePageNavForauth()),
        //         (route) => false));
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      if (e.toString() ==
          "PlatformException(NotAvailable, Required security features not enabled, null, null)") {
        Timer(
            const Duration(milliseconds: 30),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePageNav()),
                (route) => false));
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
    if (_isAuthenticating == false) {
      // showAlertDialogForUserCancelAuth(context);
      Future.delayed(const Duration(milliseconds: 1000), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(
        title: 'Authenticating',
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current State: $_authorized\n'),
              (_isAuthenticating)
                  ? ElevatedButton(
                      onPressed: _cancelAuthentication,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Cancel Authentication"),
                          Icon(Icons.cancel),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Authenticate'),
                              Icon(Icons.perm_device_information),
                            ],
                          ),
                          onPressed: () {
                            _authenticate();
                            print({"_isAuthenticating $_isAuthenticating"});
                            if (_isAuthenticating == true) {}
                          },
                        ),
                        ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_isAuthenticating
                                  ? 'Cancel'
                                  : 'Authenticate: biometrics only'),
                              const Icon(Icons.fingerprint),
                            ],
                          ),
                          onPressed: _authenticateWithBiometrics,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
