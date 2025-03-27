import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/splash/view/splash.dart';
import '../../domain/usecases.dart';
import '../../main_test.dart';

void main() async {
  late AuthenticationBloc authenticationBloc;
  late AuthenticationRepository authenticationRepository;
  late MockHRMCoreBaseService mockHRMCoreBaseService;

  setUpAll(() async {
    await initHydratedStorage();
    mockHRMCoreBaseService = MockHRMCoreBaseService();
    authenticationRepository = AuthenticationRepository(hrmCoreBaseService: mockHRMCoreBaseService);
    authenticationBloc = AuthenticationBloc(authenticationRepository: authenticationRepository);
  });

  group('Splash screen', () {
    group('Render splash screen', () {
      testWidgets('Find SplashScreen widget', (tester) async {
        await tester.pumpWidget(MultiBlocProvider(providers: [
          BlocProvider(create: (context) => authenticationBloc),
        ], child: const MaterialApp(home: SplashScreen())));
        expect(find.byType(SplashScreen), findsOneWidget);
      });

      testWidgets('Find splash screen logo', (tester) async {
        await tester.pumpWidget(MultiBlocProvider(providers: [
          BlocProvider(create: (context) => authenticationBloc),
        ], child: const MaterialApp(home: SplashScreen())));
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('Check splash screen logo is same as appLogo', (tester) async {
        await tester.pumpWidget(MultiBlocProvider(providers: [
          BlocProvider(create: (context) => authenticationBloc),
        ], child: const MaterialApp(home: SplashScreen())));
        expect(find.byKey(const ValueKey('SPLASH_LOGO')), findsOneWidget);
      });
    });
  });
}
