import 'package:aisect_custom/services/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

String Onboardbackground =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fbackground1.png?alt=media&token=2bb2bba7-26aa-4a46-a31d-555712276228';
String CompleteProfile1 =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fwarning.json?alt=media&token=7bede418-f46b-40a1-9821-bef7dd7ed56b';
String splashImage =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Feducation1.json?alt=media&token=b2e221a5-a80e-4170-b042-317f77bd1e65';
String phoneauth1 =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fillustration-3.png?alt=media&token=67d64a28-5eea-487d-b909-fd3f2e6e2e3b';
String phoneAuth2 =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fillustration-2.png?alt=media&token=2ba437ef-d29e-4a90-a852-b8637bfb1f98';
String phoneauth =
    'https://console.firebase.google.com/u/0/project/aisect-42fe7/storage/aisect-42fe7.appspot.com/files/~2Fimages';
String phoneMain =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fbackground.png?alt=media&token=e2e368bc-bff9-4378-a463-0e9656c82573';
String network =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Fmeditation-wait-please.json?alt=media&token=1d798d5c-f2cd-47bf-aef9-03c585c030ac';
String about =
    'https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/images%2Faisect.png?alt=media&token=139ae9b5-b7d6-4a71-8ce6-6a3b1de02128';
// String background1 =
//     'https://github.com/d4kash/assets/blob/main/background1.png';
// String background1 =
//     'https://github.com/d4kash/assets/blob/main/background1.png';
// String background1 =
//     'https://github.com/d4kash/assets/blob/main/background1.png';
// String background1 =
//     'https://github.com/d4kash/assets/blob/main/background1.png';
// String background1 =
//     'https://github.com/d4kash/assets/blob/main/background1.png';
Widget ChasedNetwork(String path) => CachedNetworkImage(
      placeholder: (context, url) => Constant.circle(),
      imageUrl: 'https://picsum.photos/250?image=9',
    );
