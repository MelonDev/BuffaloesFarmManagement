import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/pages/report_page.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitialState());

  report(BuildContext context) async {

  }

}
