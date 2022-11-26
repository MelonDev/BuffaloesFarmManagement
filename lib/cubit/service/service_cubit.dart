import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitialState());
}
