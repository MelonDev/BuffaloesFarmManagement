import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBuffPage extends StatelessWidget {
  const AddBuffPage({Key? key}) : super(key: key);

  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        createRectTween: _createRectTween,
        tag: "FARM_TAG",
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: const Color(0xff0171BB),
            systemNavigationBarDividerColor: const Color(0xff0171BB),
            systemNavigationBarIconBrightness: Brightness.light,
            //systemNavigationBarContrastEnforced: true,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xff0171BB),
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
                "เพิ่มกระบือ",
                style: GoogleFonts.itim(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
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
              splashColor: const Color(0xff0171BB).withOpacity(0.4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              label: Text("บันทึก",
                  style: GoogleFonts.itim(
                      color: const Color(0xff0171BB),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              icon: const Icon(Icons.save_as_rounded, color: Color(0xff0171BB)),
            ),
            body: Container(),
          ),
        ));
  }
}
