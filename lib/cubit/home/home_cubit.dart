import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  farm() async {
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
