import 'package:aisect_custom/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:aisect_custom/widget/ExpandedListAnimationWidget.dart';

// import 'Scrollbar.dart';
// typedef void onRadioSelected(String x);

class DropDown extends StatefulWidget {
  final List<dynamic> listforDropDown;
  final String string;

  final ValueSetter<dynamic> onRadioSelectedForCourse;
  // ignore: prefer_const_constructors_in_immutables
  DropDown({
    Key? key,
    required this.listforDropDown,
    required this.string,
    required this.onRadioSelectedForCourse,
  }) : super(
          key: key,
        );
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  RxBool isStrechedDropDown = false.obs;
  RxInt groupValue = 40.obs;

  ScrollController scrollController3 = ScrollController();

  // _DropDownState(string);
  RxString title = "please assign".obs;

  late TextEditingController _search;
  RxList<dynamic> newDataList = [].obs;
  // var scrollController2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title.value = widget.string;
    scrollController3 = ScrollController();
    // newDataList.value = List.from(widget.listforDropDown);
    _search = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    newDataList.value = List.from(widget.listforDropDown);
  } // String title = " Semester";

  onItemChanged(value) {
    // setState(() {
    newDataList.value = widget.listforDropDown
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffbbbbbb)),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    Container(
                      // height: 45,
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffbbbbbb),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      constraints: const BoxConstraints(
                        minHeight: 45,
                        minWidth: double.infinity,
                      ),
                      alignment: Alignment.center,
                      child: Obx(
                        () => GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child:
                                        Text(title.string)), //to display text
                              ),
                              Icon(isStrechedDropDown.value
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward)
                            ],
                          ),
                          onTap: () {
                            isStrechedDropDown.value =
                                !isStrechedDropDown.value;
                          },
                        ),
                      ),
                    ),
                    Obx(() => ExpandedSection(
                          expand: isStrechedDropDown.value,
                          height: 190,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              formText(
                                  _search,
                                  "Search",
                                  [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z0-9]+|\s'))
                                  ],
                                  25,
                                  Colors.amber[300], (_search) {
                                onItemChanged(_search);
                              }),
                              // ignore: sized_box_for_whitespace
                              Container(
                                height: Constant.height / 5,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: scrollController3,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      controller: scrollController3,
                                      shrinkWrap: true,
                                      itemCount: newDataList.length,
                                      itemBuilder: (context, index) {
                                        return RadioListTile(
                                            title: Text(
                                                newDataList.elementAt(index)),
                                            // title: Text(title),
                                            value: index,
                                            groupValue: groupValue.toInt(),
                                            onChanged: (val) {
                                              // setState(() {

                                              groupValue.value = val as int;

                                              title.value = newDataList
                                                  .elementAt(index);
                                              isStrechedDropDown.value =
                                                  !isStrechedDropDown.value;

                                              // print(title);
                                              // });

                                              widget.onRadioSelectedForCourse(
                                                  title.string);
                                              groupValue.value = 40;
                                            });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget formText(
      final TextEditingController controller,
      final String label,
      final List<TextInputFormatter>? inputFormatters,
      final int? maxLength,
      final Color? color,
      Function(String)? onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (onChanged),
        controller: controller,
        maxLength: maxLength! > 0 ? maxLength : 30,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 63)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
