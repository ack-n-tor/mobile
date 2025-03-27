import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrm_framework/hrm_framework.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/menu/bloc/menu_bloc.dart';
import 'package:onesthrm/page/menu/content/menu_header.dart';
import 'package:onesthrm/page/menu/content/menu_list.dart';
import 'package:onesthrm/page/menu/content/menu_profile.dart';
import 'package:onesthrm/page/menu_drawer/view/menu_drawer.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../profile/view/profile_page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;

    return BlocProvider(
        create: (context) => MenuBloc(
            loginData: user!,
            color: colorPrimary,
            getAppName: instance<GetAppNameUseCase>(),
            getAppVersion: instance<GetAppVersionUseCase>())
          ..add(RouteSlug(context: context))
          ..add(OnAppServiceEvent()),
        child: Scaffold(
            key: MenuScreen._scaffoldKey,
            endDrawer: const MenuDrawer(),
            extendBody: true,
            body: BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
              return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Branding.colors.primaryDark, Branding.colors.primaryLight])),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Header
                      InkWell(
                        onTap: () {
                          Navigator.push(context, ProfileScreen.route(user?.user?.id));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
                            child: Row(
                              children: [
                                const MenuProfile(),
                                SizedBox(
                                  width: 16.w,
                                ),
                                const MenuHeader(),
                                IconButton(
                                    onPressed: () {
                                      if (MenuScreen._scaffoldKey.currentState!.isEndDrawerOpen) {
                                        MenuScreen._scaffoldKey.currentState?.openEndDrawer();
                                      } else {
                                        MenuScreen._scaffoldKey.currentState?.openEndDrawer();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      color: Branding.colors.primaryLight,
                                      size: 25.r,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Menu List
                      MenuList(
                        animationController: animationController,
                      ),
                      const SizedBox(height: 36.0)
                    ],
                  ));
            })));
  }
}
