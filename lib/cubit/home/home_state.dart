part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeFarmState extends HomeState {
  Map<String, dynamic>? data;

  HomeFarmState({this.data});
}

class LoadingHomeFarmState extends HomeFarmState {}

class HomeManagementState extends HomeState {
  List<BuffModel>? data;
  bool isAdmin = false;

  HomeManagementState({this.data,this.isAdmin = false});
}

class LoadingHomeManagementState extends HomeManagementState {}

class HomeNotificationState extends HomeState {
  List<NotificationModel>? data;

  HomeNotificationState({this.data});
}

class LoadingHomeNotificationState extends HomeNotificationState {}


class HomeMoreState extends HomeState {}
