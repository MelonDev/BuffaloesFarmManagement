import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/models/NotificationModel.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  farm(BuildContext context) async {
    emit(LoadingHomeFarmState());
    Map<String, dynamic>? data = await FarmService.summary();

    //context.read<AuthenticationCubit>().signOut(context);
    emit(HomeFarmState(data: data));
  }

  management() async {
    emit(LoadingHomeManagementState());
    List<BuffModel>? buffs = await FarmService.buffs();

    emit(HomeManagementState(data: buffs));
  }

  notification() async {
    emit(LoadingHomeNotificationState());
    List<NotificationModel>? notifications = await FarmService.notifications();

    emit(HomeNotificationState(data: notifications));
  }

  more() async {
    emit(HomeMoreState());
  }
}
