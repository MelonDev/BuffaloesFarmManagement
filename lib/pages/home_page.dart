import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/pages/add_buff_activity_page.dart';
import 'package:buffaloes_farm_management/pages/add_buff_page.dart';
import 'package:buffaloes_farm_management/pages/farm_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<TabModel> tabs = [];

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      initialTabPage(context);
    }

    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
        ),
        child: Scaffold(
          backgroundColor: tabColor(state).withOpacity(0.04),
          appBar: AppBar(
            backgroundColor: tabColor(state),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: Colors.white,
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
          ),
          floatingActionButton: isShowFab(state)
              ? FloatingActionButton(
                  onPressed: () {
                    if (state is HomeFarmState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBuffPage()),
                      );
                    }
                    if (state is HomeManagementState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBuffActivityPage()),
                      );
                    }
                  },
                  heroTag: "${tabTag(state)}_TAG",
                  backgroundColor: tabColor(state),
                  child: const Icon(Icons.add),
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
                currentIndex: tabPosition(state),
                onTap: (int position) {
                  tabs[position].onTap?.call();
                  //setState(() => _currentIndex = i)
                },
                items: tabs
                    .map((TabModel tab) => SalomonBottomBarItem(
                          icon: Icon(tab.icon),
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
    });
  }

  initialTabPage(BuildContext context) {
    tabs = [
      TabModel(
          name: "ฟาร์ม",
          icon: Icons.home,
          color: const Color(0xff0171BB),
          body: const FarmPage(),
          tag: "FARM",
          onTap: () {
            context.read<HomeCubit>().farm();
          }),
      TabModel(
          name: "การจัดการ",
          icon: Icons.favorite_border,
          color: Colors.pink,
          body: Container(),
          tag: "MANAGEMENT",
          onTap: () {
            context.read<HomeCubit>().management();
          }),
      TabModel(
          name: "แจ้งเตือน",
          icon: Icons.search,
          color: Colors.orange,
          body: Container(),
          onTap: () {
            context.read<HomeCubit>().notification();
          }),
      TabModel(
          name: "เพิ่มเติม",
          icon: Icons.person,
          color: Colors.teal,
          body: Container(),
          onTap: () {
            context.read<HomeCubit>().more();
          }),
    ];
  }

  Color tabColor(HomeState state) {
    int position = tabPosition(state);
    return tabs[position].color;
  }

  String tabName(HomeState state) {
    int position = tabPosition(state);
    return tabs[position].name;
  }

  Widget tabPage(HomeState state) {
    int position = tabPosition(state);
    return tabs[position].body;
  }

  bool isShowFab(HomeState state) {
    return state is HomeFarmState || state is HomeManagementState;
  }

  String tabTag(HomeState state) {
    if (state is HomeFarmState || state is HomeManagementState) {
      int position = tabPosition(state);

      return tabs[position].tag ?? "";
    }
    return "";
  }

  int tabPosition(HomeState state) {
    if (state is HomeFarmState) {
      return 0;
    } else if (state is HomeManagementState) {
      return 1;
    } else if (state is HomeNotificationState) {
      return 2;
    } else if (state is HomeMoreState) {
      return 3;
    } else {
      return 0;
    }
  }
}

class TabModel {
  String name;
  IconData icon;
  Widget body;
  Color color;
  Function? onTap;
  String? tag;

  TabModel(
      {required this.name,
      required this.icon,
      required this.body,
      required this.color,
      this.tag,
      this.onTap});
}
