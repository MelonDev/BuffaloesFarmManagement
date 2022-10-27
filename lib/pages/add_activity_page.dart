import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);

  @override
  _AddActivityPageState createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {

  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        createRectTween: _createRectTween,
        tag: "MANAGEMENT_TAG",
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.pink,
            systemNavigationBarDividerColor: Colors.pink,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            //systemNavigationBarContrastEnforced: true,
          ),
          child: Scaffold(
            backgroundColor: Colors.pink,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
              centerTitle: true,
              title: Text(
                "เพิ่มการจัดการ",
                style: GoogleFonts.itim(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(Icons.close,color:Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              heroTag: null,
              backgroundColor: Colors.white,
              extendedPadding: const EdgeInsets.only(left: 94, right: 94),
              extendedIconLabelSpacing: 12,
              elevation: 2,
              splashColor:  Colors.pink.withOpacity(0.4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              label: Text("บันทึก",
                  style: GoogleFonts.itim(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              icon: const Icon(Icons.save_as_rounded, color: Colors.pink),
            ),
            body: body(),
          ),
        ));
  }

  Widget buildSegment(String text){
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Text(text,textAlign: TextAlign.center,style: const TextStyle(fontSize: 16,
          color: Colors.pink),),
    );
  }

  body(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 10,right: 10),
            padding: const EdgeInsets.all(4),
            child: CupertinoSlidingSegmentedControl<int>(
              backgroundColor:  Colors.black.withOpacity(0.2),
              thumbColor: Colors.white,

              padding: const EdgeInsets.all(4),
              groupValue: 0,
              children: {
                0: buildSegment("ผสมพันธุ์"),
                1: buildSegment("ฉีดวัคซีน"),
                2: buildSegment("ถ่ายพยาธิ"),
                3: buildSegment("รักษาโรค"),

              },
              onValueChanged: (value){

              },
            ),
          ),
        ],
      ),
    );
  }
}
