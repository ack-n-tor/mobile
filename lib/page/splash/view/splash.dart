import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/animation/bounce_animation/bounce_animation_builder.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/splash/bloc/splash_bloc.dart';

typedef SplashScreenFactory = SplashScreen Function();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;

    return BlocProvider(
      create: (context) => SplashBloc(context: context, data: user),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                BounceAnimationBuilder(
                  builder: (_, __) {
                    return Center(
                      child: InteractiveViewer(
                        scaleEnabled: false,
                        boundaryMargin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(
                          key: const ValueKey('SPLASH_LOGO'),
                          "assets/images/app_icon.png",
                          scale: 3,
                        ),
                      ),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
