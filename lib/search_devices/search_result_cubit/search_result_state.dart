part of 'search_result_cubit.dart';

abstract class SearchResultState extends Equatable {
  const SearchResultState();
}

class SearchResultInitial extends SearchResultState {
  @override
  List<Object> get props => [];
}

class SearchResultLoading extends SearchResultState {
  @override
  List<Object> get props => [];
}

class SearchResultLoaded extends SearchResultState {
  final List<DeviceInfo?> devices;

  SearchResultLoaded(this.devices);
  @override
  List<Object> get props => [devices];
}

class SearchResultFailed extends SearchResultState {
  @override
  List<Object> get props => [];
}

/// Used to close search result modal
class SearchResultDone extends SearchResultState {
  @override
  List<Object> get props => [];
}
