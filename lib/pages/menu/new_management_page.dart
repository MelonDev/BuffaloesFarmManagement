import 'package:auto_size_text/auto_size_text.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../buff_menu_detail.dart';

class NewManagementPage extends StatelessWidget {
  NewManagementPage({Key? key}) : super(key: key);

  Color primaryColor = Colors.pink;
  bool loaded = false;

  List<Map<String, dynamic>> listMapMenus = [
    {
      "title": TitleManagementMenu("ชนิดกระบือ"),
      "children": [
        TileManagementMenu("พ่อพันธุ์",
            modal: "assets/image_icon/male-gender.png",code: "M"),
        TileManagementMenu("แม่พันธุ์", modal: "assets/image_icon/female.png",code: "F"),
        TileManagementMenu("กระบือรุ่น", modal: "assets/image_icon/star.png",code: "T"),
        TileManagementMenu("กระบือขุน", modal: "assets/image_icon/wheat.png",code: "G"),
        TileManagementMenu("ลูกกระบือแรกเกิด",
            modal: "assets/image_icon/pacifier.png",code: "B")
      ]
    },
    {
      "title": TitleManagementMenu("เครื่องมือ"),
      "children": [
        TileManagementMenu("การจำหน่าย",
            icon: "assets/image_icon/money-bag.png"),
        TileManagementMenu("รายงาน", icon: "assets/image_icon/analysis.png"),
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeManagementState) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: state is LoadingHomeManagementState
                ? loading()
                : body(context, state));
      } else {
        return Container();
      }
    });
  }

  loading() {
    return Center(
      child: SpinKitThreeBounce(
        color: ColorHelper.lighten(primaryColor).withOpacity(0.7),
        size: 50.0,
      ),
    );
  }

  body(BuildContext context, HomeManagementState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: RefreshIndicator(
        color: primaryColor,
        child: child(context, state),
        onRefresh: () async {
          context.read<HomeCubit>().management();
        },
      ),
    );
  }

  Widget child(BuildContext context, HomeManagementState state) {
    return listView(context, state);

  }

  Widget listView(BuildContext context, HomeManagementState state) {
    List<Widget> children = [];

    for (Map<String, dynamic> mapMenu in listMapMenus) {
      TitleManagementMenu title = mapMenu['title'];
      children.add(_head(title.name));

      List<Widget> tileWidgets = [];

      List<TileManagementMenu> tileList = mapMenu['children'];
      for (TileManagementMenu tile in tileList) {
        tileWidgets.add(_tileCard(context, tile));
      }

      children.add(Wrap(
        direction: Axis.horizontal, // default
        children: tileWidgets,
      ));
    }

    return ListView.builder(
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: isLandscapeMode(context) ? 0 : 10,
          bottom: 72),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }

  Widget _tileCard(BuildContext context, TileManagementMenu tile) {
    return Container(
        width: (isLandscapeMode(context)
                ? 460
                : MediaQuery.of(context).size.width - 40) /
            2,
        height: 120,
        margin: const EdgeInsets.only(bottom: 16, left: 5, right: 5),
        child: ElevatedButton(
          onPressed: () {
            if(tile.code != null){
              context.read<HomeCubit>().management(code: tile.code);
              Navigator.of(context).push(
                NavigatorHelper.slide(
                  BuffMenuDetail(
                    title: tile.name,
                    code: tile.code
                    // tintColor: ColorHelper.lighten(
                    //     primaryColor, isLandscapeMode(context) ? .84 : .45),
                  ),
                ),
              );
            }
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(ColorHelper.lighten(
                    primaryColor, isLandscapeMode(context) ? .45 : .35)
                //Colors.blue
                ),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(ColorHelper.lighten(
                primaryColor, isLandscapeMode(context) ? .84 : .45)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              width: (isLandscapeMode(context)
                      ? 460
                      : MediaQuery.of(context).size.width - 40) /
                  2,
              padding: const EdgeInsets.only(left: 14, right: 14),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 6),
                  Container(
                      width: 58,
                      height: tile.modal == null ? 54 : 48,
                      child: Stack(
                        children: [
                          Image.asset(
                            tile.icon,
                            width: tile.modal == null ? 54 : 48,
                            height: tile.modal == null ? 54 : 48,
                            color: ColorHelper.darken(primaryColor, .36),
                          ),
                          tile.modal != null
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 26,
                                    width: 26,
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: ColorHelper.darken(
                                            primaryColor, .36),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: ColorHelper.lighten(
                                                primaryColor, .44),
                                            width: 2.4)),
                                    child: Image.asset(
                                      tile.modal!,
                                      width: 26,
                                      height: 26,
                                      color: ColorHelper.lighten(
                                          primaryColor, .44),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      )),
                  Container(height: 10),
                  AutoSizeText(
                    tile.name,
                    maxLines: 1,
                    style: GoogleFonts.itim(
                        color: ColorHelper.darken(primaryColor, .37)
                            .withOpacity(0.84),
                        fontSize: 22),
                  ),
                ],
              )),
        ));
  }

  Widget empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ไม่พบข้อมูล",
            style: GoogleFonts.itim(
                color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.8),
                fontSize: 26),
          ),
          Container(height: 6),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().management();
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  ColorHelper.lighten(primaryColor, .4).withOpacity(0.1)),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  ColorHelper.lighten(primaryColor, .2).withOpacity(0.1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.rotateRight,
                  color: ColorHelper.lighten(primaryColor, .4).withOpacity(0.8),
                  size: 18,
                ),
                Container(width: 12),
                Text(
                  "รีเฟรส",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorHelper.lighten(primaryColor, .4)
                          .withOpacity(0.8)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _head(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 12, bottom: 0, top: 12),
      margin: const EdgeInsets.only(top: 4),
      alignment: Alignment.bottomLeft,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.itim(
                //color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.7),
                color: ColorHelper.lighten(primaryColor, .42).withOpacity(0.84),
                fontSize: 22),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  bool isLandscapeMode(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width >= 700) {
      return true;
    } else if (MediaQuery.of(context).size.width >= 500) {
      return true;
    }

    return false;
  }
}

class ManagementMenu {
  String name;

  ManagementMenu(this.name);
}

class TitleManagementMenu extends ManagementMenu {
  TitleManagementMenu(super.name);
}

class TileManagementMenu extends ManagementMenu {
  String icon;
  String? modal;
  String? code;

  TileManagementMenu(super.name,
      {this.icon = "assets/image_icon/buffalo.png", this.modal,this.code});
}
