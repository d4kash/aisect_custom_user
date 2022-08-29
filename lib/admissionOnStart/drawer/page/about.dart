import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/utils/image_links.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);
  String aboutAIsect =
      '\n All Indian Society for Electronics and Computer Technology (AISECT), established 31 years back with a novel concept of spreading computer literacy and technology training in rural mass in their mother tongue, is now the leading national network of ICT enabled services with over twenty thousand centers encompassing 28 states and 3 union territories of India. In these years AISECT has enlarged its area of operation from vocational training and computer literacy to skill development activities, financial inclusion, content development, e-learning & e-governance projects, higher education institutions and placement activities. Three universities have been set up so for by AISECT – Dr. C V Raman University at Bilaspur (CG), AISECT University at Patna (Bihar) AISECT University at jharkhand (Jharkhand) and AISECT University at Hazaribag (Jharkhand). Establishing of one more university at Khandwa (Jharkhand) is in the pipeline.The outstanding contribution of AISECT has been lauded by many national and international organizations. It has won prestigious awards year after year for its excellent work. These awards include Indian IT Innovation Award 2005, NASSCOM IT Innovation Award 2006, i4d Award 2007, Golden Icon in e-Governance Award, NASSCOM Emerge 50 Leader Award, TiE Lumis Partners Entrepreneurship Excellence Award, Schwab Social Entrepreneur Award 2010 and Financial Inclusion Award 2011, e-gov India Award 2011, Skoch Corporate Leadership Award 2013, Financial Inclusion and Payment Systems Award 2013, 27th amongst the fastest growing mid-size businesses in India 2013, Voted amongst the top 100 franchises in 2010 and 2013. Hindi Science Magazine of AISECT “Electroniki Apke Liye” has won Rajbhasha Shield Samman by Rashtriya Hindi Academy, Rameshwar Guru Award, Rashtriya Rajbhasa Prachar Samman, Bhartendu Award and Saraswat Samman. AISECT has entered is to MoU with NSDC to impart skill training to thousands of youth through its centers in rural areas across the nation. ';
  String awards =
      'The Her Excellency, the Governor of Jharkhand gave assent to the State Universities Act, that envisages establishing and incorporating universities for teaching and research in the state of Jharkhand.The AISECT University of Jharkhand came into being under this Act on 16th May, 2016. The UGC, New Delhi has recognized the university and registered it under section (2F) of the UGC Act 1956.The University is located at Hazaribag, India and is sponsored by the AISECT.The Visitor of the AISECT University of Jharkhand, Her Excellency, Smt. Draupadi Murmu, appointed Shri Santosh Choubey renowned and a distinguished academic administrator, as its first Chancellor and then the Chancellor of the university appointed to Dr R. N. Yadava, distinguished Scientist and Administrator, as the first Vice Chancellor of AISECT University, Hazaribag.';
  RxBool isFirstOpened = false.obs;
  RxBool isSecOpened = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBarScreen(
        title: 'About',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() => Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ImageContainer(about),
                      // CachedNetworkImage(
                      //   fit: BoxFit.fill,
                      //   placeholder: (context, url) =>
                      //       SizedBox(child: Constant.circle()),
                      //   imageUrl: about,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 40),
                        child: Text('ABOUT',
                            style: TextStyle(
                                fontSize: height / 30,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Divider(
                    height: height / 15,
                    thickness: 2,
                  ),
                  Container(
                      child: ExpansionTile(
                    initiallyExpanded: isFirstOpened.value,
                    onExpansionChanged: (value) {
                      isFirstOpened.value = value;
                      if (isFirstOpened.isTrue) {
                        isSecOpened.value = !value;
                      } else {
                        isSecOpened.value = value;
                      }
                    },
                    title: Text("AISECT GROUP"),
                    children: [ListTile(title: Text(aboutAIsect))],
                  )),
                  Container(
                      child: ExpansionTile(
                    initiallyExpanded: isSecOpened.value,
                    onExpansionChanged: (value) {
                      if (isSecOpened.isTrue) {
                        isFirstOpened.value = !value;
                      } else {
                        isFirstOpened.value = value;
                      }
                    },
                    title: Text("AWARDS TO UNIVERSITY"),
                    children: [ListTile(title: Text(awards))],
                  )),
                ],
              )),
        ),
      ),
    );
  }

  Widget ImageContainer(String path) => ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(380)),
        child: Container(
          height: height / 2.7,
          width: width / 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Colors.yellow,
                // Colors.orangeAccent,
                // Colors.yellow.shade300,
                Color(0xFF89216B),
                Color(0xFFCE546D)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CachedNetworkImage(
            placeholder: (context, url) => Constant.circle(),
            imageUrl: path,
          ),
        ),
      );
}
