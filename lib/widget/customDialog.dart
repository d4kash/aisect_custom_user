import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

import '../services/constant.dart';

// ignore: must_be_immutable
class AdvanceDialog extends StatefulWidget {
  String s;
  String title;
  Widget? pageName;
  AdvanceDialog({Key? key, required this.s, required this.title, this.pageName})
      : super(key: key);

  @override
  _AdvanceDialogState createState() => _AdvanceDialogState();
}

class _AdvanceDialogState extends State<AdvanceDialog> {
  _AdvanceDialogState();

  // String message = "No semester Selected";
  // Widget title = const Text("Dialog");
  @override
  void initState() {
    super.initState();
    // message = widget.s;
    // title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        // ignore: deprecated_member_use
        clipBehavior: Clip.none, alignment: Alignment.topCenter,
        children: [
          // SizedBox(
          //   height: Constant.height / 3,
          // ),
          SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: SizedBox(
              height: Constant.height / 2.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 15)),

                    const SizedBox(
                      height: 15,
                    ),
                    Text(widget.s,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(
                      height: 10,
                    ),
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      onPressed: () {
                        // if (widget.pageName != null) {
                        //   Get.off(() => widget.pageName);
                        // } else {
                        Navigator.of(context).pop();
                        // }
                      },
                      child: Text("Done"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 60,
              child: Icon(
                CarbonIcons.document_tasks,
                size: 50,
                color: Colors.white,
              ),
            ),
            top: -60,
          ),
        ],
      ),
    );
  }
}
