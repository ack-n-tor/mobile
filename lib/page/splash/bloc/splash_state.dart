import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SplashState extends Equatable {

  final BuildContext context;

  const SplashState({required this.context});

  @override
  List<Object?> get props => [context];
}