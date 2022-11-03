import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  farm(BuildContext context) async {
    emit(LoadingHomeFarmState());
    List<BuffModel>? buffs = await FarmService.buffs();

    //context.read<AuthenticationCubit>().signOut(context);
    emit(HomeFarmState(data: buffs));
  }

  management() async {
    emit(LoadingHomeManagementState());
    List<BuffModel>? buffs = await FarmService.buffs();

    emit(HomeManagementState(data: buffs));
  }

  notification() async {
    emit(LoadingHomeNotificationState());

    emit(HomeNotificationState());
  }

  more() async {
    emit(HomeMoreState());
  }
}
