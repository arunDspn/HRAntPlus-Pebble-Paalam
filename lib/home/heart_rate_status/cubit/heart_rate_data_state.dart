part of 'heart_rate_data_cubit.dart';

abstract class HeartRateDataState extends Equatable {
  const HeartRateDataState();
}

class HeartRateDataInitial extends HeartRateDataState {
  @override
  List<Object> get props => [];
}

class HeartRateDataNotConnected extends HeartRateDataState {
  @override
  List<Object> get props => [];
}

class HeartRateDataConnected extends HeartRateDataState {
  @override
  List<Object> get props => [];
}
