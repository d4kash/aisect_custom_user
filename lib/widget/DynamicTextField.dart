import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import 'containerWidget.dart';
import '../services/constant.dart';

class DynamicTextField extends StatefulWidget {
  const DynamicTextField({Key? key}) : super(key: key);

  @override
  _DynamicTextFieldState createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  List<DynamicWidget> listDynamic = [];
  List<String> data = [];
  RxInt indexValue = 0.obs;
  static final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    addDynamic();
  }

  addDynamic() {
    if (data.length != 0) {
      data = [];
      listDynamic = [];
      print('if');
    }
    setState(() {});
    if (listDynamic.length >= 5) {
      return;
    }
    listDynamic.add(DynamicWidget());
    indexValue.value = listDynamic.length;
  }

  removeDynamic() {
    if (data.length != 0) {
      data = [];
      listDynamic = [];
      print('if');
    }
    setState(() {});
    try {
      if (listDynamic.length <= 1) {
        return;
      }
      listDynamic.removeLast();
      indexValue.value = listDynamic.length;
    } catch (e) {
      Constant.showSnackBar(context, "Can't delete ");
    }
  }

  submitData() {
    try {
      data = [];

      listDynamic.forEach((widget) => {
            if (widget.controller.text != "")
              {data.add(widget.controller.text)}
            else
              {Constant.showSnackBar(context, "Provide Subject Code ")}
          });
      print(listDynamic.length);
      print("data in $data");
      Constant.revaluationData = data;
      setState(() {});
      // print(data.length);
      // print(listDynamic.length);
      // print(data[0]);
      // print(data[1]);
    } catch (e) {
      print("error: $e");
      // Constant.showSnackBar(context, " error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Flexible(
        flex: 1,
        child: Card(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text("${index + 1} : ${data[index]}"),
                    ),
                    const Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: listDynamic.length,
        itemBuilder: (_, index) {
          return Wrap(children: [
            listDynamic[index],
          ]);
        },
      ),
    );

    Widget submitButton = Container(
      child: ElevatedButton(
        onPressed: submitData,
        child: const Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Submit Data'),
        ),
      ),
    );

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          data.length == 0 ? dynamicTextField : result,
          SizedBox(height: Constant.height / 50),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center,
              // runAlignment: WrapAlignment.spaceBetween,

              children: [
                data.length == 0 ? submitButton : Container(),
                SizedBox(
                  width: Constant.width / 15,
                ),
                FloatingActionButton(
                  onPressed: addDynamic,
                  child: const Icon(CarbonIcons.add),
                ),
                SizedBox(
                    width: 30, child: Center(child: Text(indexValue.string))),
                FloatingActionButton(
                  onPressed: removeDynamic,
                  child: const Icon(CarbonIcons.delete),
                ),
              ])
        ]));
  }
}

class DynamicWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  FormTextCont textBox = FormTextCont();
  // var formKey;

  DynamicWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: textBox.formText(
          controller,
          const Icon(Icons.person, color: Colors.black),
          "Subject Code",
          [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
          RequiredValidator(errorText: "subject code"),
          10,
          TextInputType.name,
          Colors.amber[300]),
    );
  }
}
