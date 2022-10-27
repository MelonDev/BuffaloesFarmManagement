import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  farm(BuildContext context) async {
    await FarmService.buffs();
    //context.read<AuthenticationCubit>().signOut(context);
    emit(HomeFarmState());
  }

  management() async {
    emit(HomeManagementState());
  }

  notification() async {
    emit(HomeNotificationState());
  }

  more() async {
    emit(HomeMoreState());
  }
}
