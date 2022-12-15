import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Color primaryColor = const Color(0xFFDCDCDC);
  Color textOuterColor = const Color(0xFF2A2A2A);

  late MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();
    _mapSource = const MapShapeSource.asset(
      'assets/geojson/thailand_northern_province.json',
      shapeDataField: 'name',
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: primaryColor,
          systemNavigationBarDividerColor: primaryColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          //systemNavigationBarContrastEnforced: true,
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: primaryColor,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Container(
                    height: 60 + statusBarHeight,
                    child: Center(
                        child: Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                              surfaceTintColor: primaryColor,
                              systemOverlayStyle: const SystemUiOverlayStyle(
                                statusBarIconBrightness: Brightness.dark,
                                statusBarColor: Color(0xFFDCDCDC)
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(22),
                                ),
                              ),
                              centerTitle: true,
                              title: Text(
                                "รายงาน",
                                style: GoogleFonts.itim(
                                  color: textOuterColor,
                                  fontSize: 24,
                                ),
                              ),
                              titleSpacing: 0,
                              leading: IconButton(
                                icon: Icon(FontAwesomeIcons.xmark,
                                    color: textOuterColor, size: 24),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ))))),
            body: body(),
          ),
        ));
  }

  Widget loading() {
    return const Center(
        child: SpinKitThreeBounce(
      color: Colors.white,
      size: 50.0,
    ));
  }

  Widget body() {
    return Container(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: const BoxDecoration(
            color: kBGColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
              bottom: Radius.circular(22),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          //height: 460,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          //height: MediaQuery.of(context).size.height,
          child: SfMaps(
            layers: [
              MapShapeLayer(
                source: _mapSource,
                //legend: MapLegend(MapElement.shape),
                showDataLabels: true,
                strokeColor: const Color(0xFF9D9D9D),
                strokeWidth: 1.0,
                dataLabelSettings: const MapDataLabelSettings(
                    textStyle: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontWeight: FontWeight.normal,
                        fontSize: 16)),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
