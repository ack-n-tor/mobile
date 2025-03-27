import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class BulletinState extends Equatable {
  final NetworkStatus status;
  final String? headline;

  const BulletinState({this.status = NetworkStatus.initial, this.headline});

  BulletinState copyWith({NetworkStatus? status, String? headline}) {
    return BulletinState(status: status ?? this.status, headline: headline ?? this.headline);
  }

  @override
  List<Object?> get props => [status, headline];
}

