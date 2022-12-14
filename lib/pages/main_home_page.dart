import 'package:auto_size_text/auto_size_text.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/TabModel.dart';
import 'package:buffaloes_farm_management/pages/add_buff_page.dart';
import 'package:buffaloes_farm_management/pages/menu/farm_page.dart';
import 'package:buffaloes_farm_management/pages/loading/home_initial_loading_page.dart';
import 'package:buffaloes_farm_management/pages/menu/management_page.dart';
import 'package:buffaloes_farm_management/pages/menu/new_management_page.dart';
import 'package:buffaloes_farm_management/pages/menu/notification_page.dart';
import 'package:buffaloes_farm_management/pages/menu/more_page.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  List<TabModel> tabs = [];

  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      initialTabPage(context);
    }

    double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeInitialState) {
        return const HomeInitialLoadingPage();
      } else {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.white,
          ),
          child: Container(
              color: Colors.black,
              child: Scaffold(
                backgroundColor: tabColor(state).withOpacity(0.14),
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50.0),
                    child: Container(
                      height: 60 + statusBarHeight,
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: AppBar(
                            backgroundColor: tabColor(state),
                            shadowColor: Colors.transparent,
                            surfaceTintColor: tabColor(state),
                            elevation: 0.0,
                            centerTitle: false,
                            systemOverlayStyle: SystemUiOverlayStyle(
                                statusBarIconBrightness: Brightness.light,
                                systemNavigationBarColor: Colors.white,
                                statusBarBrightness: Brightness.dark,
                                statusBarColor: tabColor(state)),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(22),
                              ),
                            ),
                            title: Text(
                              tabName(state),
                              style: GoogleFonts.itim(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            actions: actionsWidget(state),
                          ),
                        ),
                      ),
                    )),
                floatingActionButton: !isLandscapeMode()
                    ? (isShowFab(state)
                        ? FloatingActionButton(
                            shape: const CircleBorder(),
                            onPressed: () async {
                              if (state is HomeFarmState) {
                                // bool result = await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const AddBuffPage(),
                                //       fullscreenDialog: true),
                                // );
                              }
                              if (state is HomeManagementState) {
                                Navigator.of(context).push(
                                  NavigatorHelper.slide(
                                    AddBuffPage(),
                                  ),
                                );
                              }
                            },
                            elevation: 20,
                            //heroTag: "${tabTag(state)}_TAG",
                            backgroundColor: tabColor(state),
                            child: const Icon(FontAwesomeIcons.plus),
                          )
                        : null)
                    : null,
                bottomNavigationBar: !isLandscapeMode()
                    ? SizedBox(
                        height: 60,
                        child: Center(
                            child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          constraints: const BoxConstraints(maxWidth: 400),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(22),
                              )),
                          child: SalomonBottomBar(
                              currentIndex: currentTab,
                              onTap: (int position) {
                                setState(() {
                                  currentTab = position;
                                });
                                tabs[position].onTap?.call();
                                //setState(() => _currentIndex = i)
                              },
                              items: tabs
                                  .map((TabModel tab) => SalomonBottomBarItem(
                                        icon: Icon(tab.icon),
                                        activeIcon: tab.activeIcon != null
                                            ? Icon(
                                                tab.activeIcon,
                                                size: 20,
                                              )
                                            : null,
                                        unselectedColor: Colors.black54,
                                        title: Container(
                                          constraints: const BoxConstraints(maxWidth:120),
                                          child: AutoSizeText(
                                            tab.name,
                                            maxLines: 1,
                                            style: GoogleFonts.itim(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        selectedColor: tab.color,
                                      ))
                                  .toList()),
                        )))
                    : null,
                body: isLandscapeMode()
                    ? landscapeMode(state)
                    : portraitMode(state),
              )),
        );
      }
    });
  }

  Widget portraitMode(state) {
    return Container(
      child: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: tabPage(state),
      )),
    );
  }

  Widget landscapeMode(state) {
    return Container(
      child: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sidebar(state),
            SizedBox(width: 500, child: tabPage(state))
          ],
        ),
      )),
    );
  }

  Widget sidebar(state) {
    return Container(
      width: 200,
      padding: const EdgeInsets.only(left: 20, top: 24),
      child: Column(children: [
        Container(
          width: 180,
          height: 200,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListView(
              padding: const EdgeInsets.only(left: 10, top: 12),
              children: [
                menuButton(
                    position: 0, item: tabs[0], active: state is HomeFarmState),
                menuButton(
                    position: 1,
                    item: tabs[1],
                    active: state is HomeManagementState),
                menuButton(
                    position: 2,
                    item: tabs[2],
                    active: state is HomeNotificationState),
                menuButton(
                    position: 3, item: tabs[3], active: state is HomeMoreState),
              ]),
        ),
        isShowFab(state)
            ? Container(
                padding: const EdgeInsets.only(left: 20, top: 22),
                child: actionButton(state))
            : Container()
      ]),
    );
  }

  bool isLandscapeMode() {
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width >= 700) {
      return true;
    }

    return false;
  }

  initialTabPage(BuildContext context) {
    tabs = [
      TabModel(
          name: "ฟาร์ม",
          icon: FontAwesomeIcons.chartPie,
          activeIcon: FontAwesomeIcons.chartPie,
          color: const Color(0xff0171BB),
          body: FarmPage(),
          tag: "FARM",
          onTap: () {
            context.read<HomeCubit>().farm(context);
          }),
      TabModel(
          name: "บันทึกข้อมูล",
          icon: FontAwesomeIcons.pager,
          activeIcon: FontAwesomeIcons.pager,
          color: Colors.pink,
          body: NewManagementPage(),
          tag: "MANAGEMENT",
          onTap: () {
            context.read<HomeCubit>().management();
          }),
      TabModel(
          name: "แจ้งเตือน",
          icon: FontAwesomeIcons.solidBell,
          activeIcon: FontAwesomeIcons.solidBell,
          color: Colors.orange,
          body: NotificationPage(),
          onTap: () {
            context.read<HomeCubit>().notification();
          }),
      TabModel(
          name: "เพิ่มเติม",
          icon: FontAwesomeIcons.ellipsis,
          activeIcon: FontAwesomeIcons.ellipsis,
          color: Colors.teal,
          body: MorePage(),
          onTap: () {
            context.read<HomeCubit>().more();
          }),
    ];
  }

  List<Widget> actionsWidget(HomeState state) {
    List<Widget> list = [];

    if (state is HomeFarmState) {
      list.add(button(message: "แก้ไข", icon: FontAwesomeIcons.penToSquare));
    }

    return list;
  }

  Color tabColor(HomeState state) {
    return tabs[currentTab].color;
  }

  String tabName(HomeState state) {
    return tabs[currentTab].name;
  }

  Widget tabPage(HomeState state) {
    return tabs[currentTab].body;
  }

  bool isShowFab(HomeState state) {
    return state is HomeManagementState;
  }

  String tabTag(HomeState state) {
    if (state is HomeFarmState || state is HomeManagementState) {
      return tabs[currentTab].tag ?? "";
    }
    return "";
  }

  Widget actionButton(state) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(right: 20, top: 0, bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          if (state is HomeManagementState) {
            Navigator.of(context).push(
              NavigatorHelper.slide(
                AddBuffPage(),
              ),
            );
          }
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(ColorHelper.darken(tabColor(state))),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(tabColor(state)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 17,
            ),
            Container(width: 8),
            const Text(
              "เพิ่ม",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            Container(width: 2),
          ],
        ),
      ),
    );
  }

  Widget menuButton(
      {required int position, required TabModel item, required bool active}) {
    return Container(
      height: active ? 50 : 46,
      padding: const EdgeInsets.only(right: 10, left: 0, top: 0, bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentTab = position;
          });
          item.onTap?.call();
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(active
              ? ColorHelper.darken(Colors.white, .4).withOpacity(.1)
              : item.color.withOpacity(0.05)),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(active
              ? item.color.withOpacity(0.20)
              : ColorHelper.darken(Colors.white, .48).withOpacity(.12)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              margin: const EdgeInsets.only(right:8),
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                color : active ? item.color : Colors.transparent
              ),
            ),
            Icon(
              item.icon,
              color: active ? item.color : Colors.black.withOpacity(0.4),
              size: 16,
            ),
            Container(width: 8),
            AutoSizeText(
              item.name,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: active ? 19 : 17,
                  color: active ? item.color : Colors.black.withOpacity(0.4)),
            ),
            Container(width: 2),
          ],
        ),
      ),
    );
  }

  Widget button({required String message, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
              ColorHelper.darken(Colors.white, .4).withOpacity(.1)),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(
              ColorHelper.lighten(Colors.white, .48).withOpacity(.22)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon ?? FontAwesomeIcons.ellipsis,
              color: ColorHelper.lighten(Colors.white, .6).withOpacity(0.8),
              size: 16,
            ),
            Container(width: 8),
            Text(
              message,
              style: TextStyle(
                  fontSize: 17,
                  color:
                      ColorHelper.lighten(Colors.white, .6).withOpacity(0.8)),
            ),
            Container(width: 2),
          ],
        ),
      ),
    );
  }
}
