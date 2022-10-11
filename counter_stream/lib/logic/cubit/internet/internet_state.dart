part of 'internet_cubit.dart';

enum ConnectionType { Wifi, Mobile }

abstract class InternetState extends Equatable {
  const InternetState();
}

class InternetLoading extends InternetState {
  @override
  List<Object> get props => [];
}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  const InternetConnected({required this.connectionType});

  @override
  List<Object> get props => [];
}

class InternetDisconnected extends InternetState {
  @override
  List<Object> get props => [];
}
