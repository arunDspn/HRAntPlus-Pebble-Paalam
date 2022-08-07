import 'package:ant_pebble_paalam/ant_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_result_state.dart';

class SearchResultCubit extends Cubit<SearchResultState> {
  SearchResultCubit() : super(SearchResultInitial());

  void gotDevices(List<DeviceInfo?> devices) {
    emit(SearchResultLoaded(devices));
  }
}
