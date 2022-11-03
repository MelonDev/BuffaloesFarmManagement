import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmPage extends StatelessWidget {
  FarmPage({Key? key}) : super(key: key);

  Color primaryColor = const Color(0xff0171BB);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeFarmState) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: state is LoadingHomeFarmState
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
    ));
  }

  body(BuildContext context, HomeFarmState state) {
    if (state.data != null) {
      if (state.data!.isNotEmpty) {
        return ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          itemCount: state.data?.length ?? 0,
          itemBuilder: (context, index) {
            return card(state.data![index]);
          },
        );
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
              context.read<HomeCubit>().farm(context);
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

  card(BuffModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor, .5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      width: 10,
      height: 120,
    );
  }
}
