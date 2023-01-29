part of 'service_cubit.dart';

@immutable
abstract class ServiceState {}

class ServiceInitialState extends ServiceState {}

class ServiceReportState extends ServiceState {
  Map<String, dynamic>? data;
  List<ReportBaseModel>? mapModels;

  ServiceReportState({this.data,this.mapModels});
}

