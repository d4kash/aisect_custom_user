import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/constant.dart';
import '../../widget/appBar.dart';

class HelpPage extends StatelessWidget {
  HelpPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.backgroundColor,
        appBar: AppBarScreen(
          title: "Help",
        ),
        body: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(children: [
                FaIcon(FontAwesomeIcons.locationArrow, color: Colors.red),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Locate us :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "   Matwari Chowk \n   Infront of Gandhi Maidan,\n   Hazaribag – 825301 \n   (Jharkhand) India ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                // Text(
                //   " Hazaribag – 825301 \n  (Jharkhand) India ",
                //   style: TextStyle(fontSize: 20),
                // ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Main Campus :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "   Tarwa Kharwa,\n   Hazaribag – 825301 \n   (Jharkhand) India ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Contact us :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "   Administrative office: +918252299990",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "   Admission Enquiry:- +918292846702",
                  style: TextStyle(fontSize: 18),
                ),

                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("List of HODs",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),

                SizedBox(
                  height: 10,
                ),
                _buildTableRow(map),
              ]),
            ),
          ),
        ));
  }

  var map = [
    {
      "name": "	Dr.Arvind Kumar",
      "faculty": "Agriculture",
      "contact": "9792972781"
    },
    {"name": "Dr.Sweta Singh", "faculty": "Arts ", "contact": "8789736225"},
    {"name": "Ms.Richa", "faculty": "Arts", "contact": "7004182557"},
    {"name": "Ms.Neha Sinha 	", "faculty": "Science", "contact": "9308731564"},
    {
      "name": "Mr.Ritesh Kumar",
      "faculty": "Management ",
      "contact": "7260005934"
    },
    {"name": "Mr.Uday Ranjan", "faculty": "CS & IT", "contact": "9608341186"}
  ];

  Widget _buildTableRow(List<Map<String?, String?>> map) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Table(
        //if data is loaded then show table
        border: TableBorder.all(width: 1, color: Colors.black45),
        children: map.map((nameone) {
          //display data dynamically from namelist List.
          return (TableRow(//return table row in every loop
              children: [
            //table cells inside table row
            
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(5), child: Text(nameone["name"]!))),
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(nameone["faculty"]!))),
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(nameone["contact"]!))),
          ]));
        }).toList(),
      ),
    );
  }

//   var map = {"1": 	Dr.Arvind Kumar 	Agriculture 	9792972781
// 2. 	Dr.Sweta Singh 	Arts 	8789736225
// 3. 	Ms.Richa 	Arts 	7004182557
// 4. 	Ms.Neha Sinha 	Science 	9308731564
// 5. 	Mr.Ritesh Kumar 	Management 	7260005934
// 6. 	Mr.Uday Ranjan 	CS & IT 	9608341186};
}
