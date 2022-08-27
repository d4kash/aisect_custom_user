import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: buildLoginButtonWidget(context));
  }

  Widget buildLoginButtonWidget(context) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 16, right: 16),
        width: MediaQuery.of(context).size.width - 32,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // RawMaterialButton(
            //   fillColor: Colors.pink,
            //   splashColor: Colors.purple,
            //   child: Padding(
            //     padding: EdgeInsets.all(10.0),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: const [
            //         Icon(
            //           Icons.play_circle_outline,
            //           color: Colors.white,
            //           size: 32,
            //         ),
            //         SizedBox(
            //           width: 10.0,
            //         ),
            //         Text(
            //           "Kiss Me",
            //           maxLines: 1,
            //           style: TextStyle(color: Colors.white, fontSize: 20),
            //         ),
            //       ],
            //     ),
            //   ),
            //   shape: const UnderlineInputBorder(),
            //   onPressed: () {},
            // ),
            // RawMaterialButton(
            //   fillColor: Colors.green,
            //   splashColor: Colors.greenAccent,
            //   child: Padding(
            //     padding: EdgeInsets.all(10.0),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: const [
            //         Icon(
            //           Icons.face,
            //           color: Colors.amber,
            //           size: 32,
            //         ),
            //         SizedBox(
            //           width: 10.0,
            //         ),
            //         Text(
            //           "Kiss Me",
            //           maxLines: 1,
            //           style: TextStyle(color: Colors.white, fontSize: 20),
            //         ),
            //       ],
            //     ),
            //   ),
            //   shape: const StadiumBorder(),
            //   onPressed: () {},
            // ),
            RawMaterialButton(
              fillColor: Colors.purpleAccent,
              splashColor: Colors.lightGreen,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.face,
                      color: Colors.amber,
                      size: 32,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Kiss Me",
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
            ),
          ],
        ));
  }
}
