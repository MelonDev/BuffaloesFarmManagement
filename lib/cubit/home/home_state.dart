part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeFarmState extends HomeState {
  List<BuffModel>? data;

  HomeFarmState({this.data});
}

class LoadingHomeFarmState extends HomeFarmState {}

class HomeManagementState extends HomeState {
  List<BuffModel>? data;

  HomeManagementState({this.data});
}

class LoadingHomeManagementState extends HomeManagementState {}

class HomeNotificationState extends HomeState {
  List<BuffModel>? data;

  HomeNotificationState({this.data});
}

class LoadingHomeNotificationState extends HomeNotificationState {}


class HomeMoreState extends HomeState {}
