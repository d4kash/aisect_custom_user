import 'package:aisect_custom/widget/theme_changer.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatefulWidget {
  final String text;
  final List<dynamic> cateogery;
  final ValueChanged? onChanged;
  final ValueSetter<dynamic> onItemSelect;

  const CustomDropdown({
    Key? key,
    required this.text,
    required this.cateogery,
    this.onChanged,
    required this.onItemSelect,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late GlobalKey actionKey;
  double? height, width, xPosition, yPosition;
  RxBool isDropdownOpened = false.obs;
  OverlayEntry? floatingDropdown;
  var c = Get.put(DropDown1());

  @override
  void initState() {
    c.get_text.value = widget.text;
    actionKey = LabeledGlobalKey(widget.text);

    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox =
        actionKey.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    // print(height);
    // print(width);
    // print(xPosition);
    // print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
          left: xPosition,
          width: width,
          top: yPosition! + height!,
          height: 4 * height! + 40,
          child: dropDown1(height as double, widget.cateogery));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        if (isDropdownOpened.value) {
          floatingDropdown!.remove();
        } else {
          findDropdownData();
          floatingDropdown = _createFloatingDropdown();
          Overlay.of(context)!.insert(floatingDropdown!);
        }

        isDropdownOpened.value = !isDropdownOpened.value;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 52, 50, 50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Obx(() => Text(
                  c.get_text.toString().toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                )),
            const Spacer(),
            isDropdownOpened.value
                ? const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
          ],
        ),
      ),
    );
  }

  Widget dropDown1(final double itemHeight, final List<dynamic> cat) {
    var c = Get.put(DropDown1());
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: const Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.red.shade600,
              ),
            ),
          ),
        ),
        Material(
          elevation: 20,
          shape: ArrowShape(),
          child: Container(
            height: 4 * itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cat.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: GestureDetector(
                      child: DropDownItem(
                        text: (cat.elementAt(index)),
                        iconData: CarbonIcons.add,
                      ),
                      onTap: () {
                        c.index.value = index;
                        widget.onItemSelect(index);
                        c.get_text.value = cat.elementAt(index);
                        print(c.get_text);
                        if (isDropdownOpened.value) {
                          floatingDropdown!.remove();
                        } else {
                          findDropdownData();
                          floatingDropdown = _createFloatingDropdown();
                          Overlay.of(context)!.insert(floatingDropdown!);
                        }

                        isDropdownOpened.value = !isDropdownOpened.value;
                      },
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  final List<dynamic> cat;
  final ValueChanged? onChanged;
  // final ValueSetter<dynamic> onItemSelect;

  const DropDown({
    Key? key,
    required this.itemHeight,
    required this.cat,
    this.onChanged,
    // required this.onItemSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: const Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.red.shade600,
              ),
            ),
          ),
        ),
        Material(
          elevation: 20,
          shape: ArrowShape(),
          child: Container(
            height: 4 * itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cat.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: DropDownItem(
                        text: (cat.elementAt(index)),
                        iconData: CarbonIcons.add,
                      ),
                      onTap: () {},
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  // final VoidCallback onTap;
  const DropDownItem({
    Key? key,
    required this.text,
    required this.iconData,
    this.isSelected = false,
    this.isFirstItem = false,
    this.isLastItem = false,
  }) : super(key: key);

  factory DropDownItem.first(
      {required String text,
      required IconData iconData,
      required bool isSelected}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last(
      {required String text,
      required IconData iconData,
      required bool isSelected}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isLastItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirstItem ? const Radius.circular(8) : Radius.zero,
          bottom: isLastItem ? const Radius.circular(8) : Radius.zero,
        ),
        color: isSelected ? Colors.red.shade900 : Colors.red.shade600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Icon(
            iconData,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ArrowShape extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getOuterPath
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }
}
