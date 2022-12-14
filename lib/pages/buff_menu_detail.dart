import 'package:age_calculator/age_calculator.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/pages/add_buff_page.dart';
import 'package:buffaloes_farm_management/pages/buff_detail_page.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BuffMenuDetail extends StatelessWidget {
  BuffMenuDetail({Key? key, required this.title,this.code}) : super(key: key);

  String? title,code;

  Color primaryColor = Colors.pink;

  Color backgroundColor = ColorHelper.darken(Colors.pink, .46);
  Color tintColor = Colors.pink;

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    //primaryColor = ColorHelper.lighten(primaryColor, isLandscapeMode(context) ? .84 : .45);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: backgroundColor,
          systemNavigationBarDividerColor: backgroundColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          //systemNavigationBarContrastEnforced: true,
        ),
        child: Container(
          color: backgroundColor,
            child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Scaffold(
                          backgroundColor: backgroundColor,
                          appBar: PreferredSize(
                              preferredSize: const Size.fromHeight(50.0),
                              child: Container(
                                  height: 60 + statusBarHeight,
                                  child: Center(
                                      child: Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 500),
                                          child: AppBar(
                                            backgroundColor: tintColor,
                                            shadowColor: Colors.transparent,
                                            elevation: 0.0,
                                            surfaceTintColor: backgroundColor,
                                            systemOverlayStyle:
                                                SystemUiOverlayStyle(
                                                    statusBarIconBrightness:
                                                        Brightness.light,
                                                    statusBarColor: tintColor),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(22),
                                              ),
                                            ),
                                            centerTitle: true,
                                            title: Text(
                                              title ?? "",
                                              style: GoogleFonts.itim(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                            titleSpacing: 0,
                                            leading: IconButton(
                                              icon: const Icon(
                                                  FontAwesomeIcons.xmark,
                                                  color: Colors.white,
                                                  size: 24),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                          ))))),
                          floatingActionButton: FloatingActionButton(
                            shape: const CircleBorder(),
                            onPressed: () async {
                              Navigator.of(context).push(
                                NavigatorHelper.slide(
                                  AddBuffPage(buffTypeKey: code,),
                                ),
                              );
                            },
                            elevation: 20,
                            backgroundColor: primaryColor,
                            child: const Icon(FontAwesomeIcons.plus),
                          ),
                          body: BlocBuilder<HomeCubit, HomeState>(
                              builder: (context, state) {
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
                          })),
                    )))));
  }

  body(BuildContext context, HomeManagementState state) {
    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: child(context, state),
        onRefresh: () async {
          context.read<HomeCubit>().management(code: code);
        },
      ),
    );
  }

  loading() {
    return Center(
      child: SpinKitThreeBounce(
        color: ColorHelper.lighten(primaryColor).withOpacity(0.7),
        size: 50.0,
      ),
    );
  }

  Widget child(BuildContext context, HomeManagementState state) {
    if (state.data != null) {
      if (state.data!.isNotEmpty) {
        return listView(state);
      }
    }
    return empty(context);
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
              context.read<HomeCubit>().management(code: code);
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

  Widget listView(HomeManagementState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 72),
      itemCount: state.data?.length ?? 0,
      itemBuilder: (context, index) {
        return card(context, state.data![index]);
      },
    );
  }

  card(BuildContext context, BuffModel model) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent,
          child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  // color: ColorHelper.lighten(primaryColor, .5)
                  //     .withOpacity(0.1),
                  color: const Color(0xFF211b1d),
                  borderRadius: BorderRadius.circular(12)),
              height: 130,
              child: Stack(
                children: [
                  headerImage(model),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 8, left: 86, right: 16),
                      child: Column(children: [
                        Row(
                          children: [
                            Text(
                              model.name ?? "",
                              style: GoogleFonts.itim(
                                  color: ColorHelper.lighten(primaryColor, .42),
                                  fontSize: 24),
                            ),
                            Container(width: 12, height: 0),
                            Container(
                                decoration: BoxDecoration(
                                  color: ColorHelper.lighten(primaryColor)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 4, bottom: 4),
                                child: Text(
                                  getGenderName(model.gender),
                                  style: GoogleFonts.itim(
                                      color: ColorHelper.lighten(
                                          primaryColor, .42),
                                      fontSize: 16),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "เบอร์หู: ${model.tag ?? "ไม่ทราบ"}",
                              style: GoogleFonts.itim(
                                  color: ColorHelper.lighten(primaryColor, .42),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        Container(width: 0, height: 1),
                        Row(
                          children: [
                            Text(
                              "อายุ: ${getAge(model.birth_date)}",
                              style: GoogleFonts.itim(
                                  color: ColorHelper.lighten(primaryColor, .42),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  ColorHelper.lighten(primaryColor)
                                      .withOpacity(0.5),
                                  Colors.transparent
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.5, 0.0),
                                stops: const [0.2, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "สถานะ: ${model.status ?? "ปกติ"}",
                              style: GoogleFonts.itim(
                                  color: ColorHelper.lighten(primaryColor, .42),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ))),
      onTap: () {
        Navigator.of(context).push(
          NavigatorHelper.slide(
            BuffDetailPage(
              id: model.id ?? "",
              buff: model,
            ),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BuffDetailPage(
        //             id: model.id ?? "",
        //             buff: model,
        //           ),
        //       fullscreenDialog: true),
        // );
      },
    );
  }

  String getAge(String? birthDate) {
    if (birthDate != null) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(birthDate);
      DateDuration duration =
          AgeCalculator.age(tempDate, today: DateTime.now());
      if (duration.years == 0 && duration.months == 0) {
        return "วันนี้";
      } else if (duration.years == 0 && duration.months != 0) {
        return "${duration.months} เดือน";
      } else if (duration.years != 0 && duration.months == 0) {
        return "${duration.years} ปี";
      } else {
        return "${duration.years} ปี ${duration.months} เดือน";
      }
    }
    return "ไม่ระบุ";
  }

  String getGenderName(String? gender) {
    if (gender != null) {
      if (gender == "MALE") {
        return "เพศผู้";
      }
      if (gender == "FEMALE") {
        return "เพศเมีย";
      }
    }
    return "";
  }

  Widget headerImage(BuffModel model) {
    return Align(
      alignment: Alignment.topLeft,
      child: Hero(
          tag: "${model.id ?? ""}_IMAGE",
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            child: SizedBox(
              width: 70,
              height: 130,
              child: image(model.image_url),
            ),
          )),
    );
  }

  Widget image(String? url) {
    print(url);
    // return Image.network(
    //   url ?? "",
    //   fit: BoxFit.cover,
    // );

    return CachedNetworkImage(
      imageUrl: url ?? "",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            //colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
              color: ColorHelper.lighten(primaryColor).withOpacity(0.2))),
      errorWidget: (context, url, error) => Container(
        color: ColorHelper.lighten(primaryColor).withOpacity(0.4),
        child: Center(
            child: Icon(FontAwesomeIcons.fileImage,
                size: 34, color: Colors.white.withOpacity(0.5))),
      ),
    );
  }

  bool isLandscapeMode(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width >= 700) {
      return true;
    }

    return false;
  }
}
