import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/TabModel.dart';
import 'package:buffaloes_farm_management/pages/add_buff_page.dart';
import 'package:buffaloes_farm_management/pages/menu/farm_page.dart';
import 'package:buffaloes_farm_management/pages/loading/home_initial_loading_page.dart';
import 'package:buffaloes_farm_management/pages/menu/management_page.dart';
import 'package:buffaloes_farm_management/pages/menu/notification_page.dart';
import 'package:buffaloes_farm_management/pages/menu/more_page.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
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
          child: Scaffold(
            backgroundColor: tabColor(state).withOpacity(0.04),
            appBar: AppBar(
              backgroundColor: tabColor(state),
              elevation: 0,
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
            floatingActionButton: isShowFab(state)
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
                            const AddBuffPage(),
                          ),
                        );
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const AddBuffPage(),
                        //       fullscreenDialog: true),
                        // );
                      }
                    },
                    elevation: 20,
                    //heroTag: "${tabTag(state)}_TAG",
                    backgroundColor: tabColor(state),
                    child: const Icon(FontAwesomeIcons.plus),
                  )
                : null,
            bottomNavigationBar: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                            title: Text(
                              tab.name,
                              style: GoogleFonts.itim(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            selectedColor: tab.color,
                          ))
                      .toList()),
            ),
            body: tabPage(state),
          ),
        );
      }
    });
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
          name: "การจัดการ",
          icon: FontAwesomeIcons.pager,
          activeIcon: FontAwesomeIcons.pager,
          color: Colors.pink,
          body: ManagementPage(),
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

  List<Widget> actionsWidget(HomeState state){
    List<Widget> list = [];

    if(state is HomeFarmState){
      list.add(button(message:"แก้ไข",icon: FontAwesomeIcons.penToSquare));
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

  Widget button({required String message, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.only(right:20,top:10,bottom:10),
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
                  color: ColorHelper.lighten(Colors.white, .6).withOpacity(0.8)),
            ),
            Container(width: 2),
          ],
        ),
      ),
    );
  }
}
