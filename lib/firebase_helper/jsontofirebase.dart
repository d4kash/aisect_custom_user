import 'dart:convert';

import 'package:aisect_custom/model/jsontodart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JsonToFirebase extends StatefulWidget {
  JsonToFirebase({Key? key}) : super(key: key);

  @override
  _JsonToFirebaseState createState() => _JsonToFirebaseState();
}

class _JsonToFirebaseState extends State<JsonToFirebase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("assets/files/only_course.json"),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data != null &&
                snapshot.connectionState == ConnectionState.done) {
              var myDataFromJson = json.decode(snapshot.data.toString());
              // var data = myDataFromJson["course"];
              return Upload(myDataFromJson: myDataFromJson);
            } else {
              return const Center(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
          }),
    );
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.myDataFromJson}) : super(key: key);
  final myDataFromJson;
  @override
  Widget build(BuildContext context) {
    List<dynamic> pg = myDataFromJson['PG'];
    List<dynamic> ug = myDataFromJson['UG'];
    List<dynamic> diploma = myDataFromJson['Diploma'];
    // List<dynamic> course = myDataFromJson['course'];
    // List<dynamic> semester = myDataFromJson['semester'];
    // List<dynamic> departement = myDataFromJson['departement'];
    // print(int.tryParse(semester[0]));
    // print(semester[0]);
    var courseColl = FirebaseFirestore.instance.collection('courses');
    // Future<void> uploadToColud(var course, String docname) async {
    //   await courseColl
    //       .doc(docname)
    //       .set({docname: FieldValue.arrayUnion(course)}).then(
    //           (value) => print("uploaded"));
    // }

//this is for Map Uploading
    Future<void> uploadToColud(var course, String docname) async {
      await courseColl
          .doc(docname)
          .update(course)
          .then((value) => print("uploaded"));
    }

    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(pg[0]),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  // await uploadToColud(diploma, "Diploma");//for list likeug,pg,diploma

                  for (var element in pg) {
                    print("in $element");
                    print(myDataFromJson[element]['Fee']);
                    Model courseUpload = Model(
                        myDataFromJson[element]['departement'].toString(),
                        myDataFromJson[element]['course'].toString(),
                        myDataFromJson[element]['csn'].toString(),
                        myDataFromJson[element]['duration'].toString(),
                        myDataFromJson[element]['eligiblity'].toString(),
                        myDataFromJson[element]['Fee'].toString());
                    // print(courseUpload);
                    await uploadToColud(courseUpload.toMap(), element);
                    // var upload = model.toMap();
                  }
                } catch (e) {
                  print(e);
                }
                // print(myDataFromJson['Diploma in Information Technology']);
                // await uploadToColud(departement, "Departement");
              },
              child: const Text("upload json"))
        ],
      ),
    );
  }
}
