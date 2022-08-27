import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass {
  Widget frostedGlassEffectDemo(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          child: Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 7,
                sigmaY: 7,
              ),
              child: Container(
                height: 220,
                width: 360,
              ),
            ),
            Container(
              height: 230,
              width: 360,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                    )
                  ],
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffff9a9e),
                      Color.fromARGB(255, 176, 127, 113)
                    ],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: 270,
                        child: Text(
                          "Debit Card",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      "7622   4574   3688   3640   ",
                      style: TextStyle(
                          fontSize: 23, color: Colors.white.withOpacity(0.4)),
                    ),
                    SizedBox(
                      width: 275,
                      child: Row(
                        children: [
                          Text(
                            "6372",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            "VALID \n THRU",
                            style: TextStyle(
                                fontSize: 6,
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "  09/25",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: 275,
                        child: Text(
                          "FLUTTER DEVS",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
