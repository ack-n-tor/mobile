import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import '../../../res/widgets/dynamic_image_viewer.dart';

class MenuContentItem extends StatelessWidget {
  final Function() onPressed;
  final Menu menu;
  final AnimationController animationController;
  final Animation animation;

  const MenuContentItem(
      {super.key,
      required this.onPressed,
      required this.menu,
      required this.animationController,
      required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (_, __) {
          return FadeTransition(
            opacity: kAlwaysCompleteAnimation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 50.0 * (1.0 - animation.value), 0.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0).r,
                ),
                child: TextButton(
                  onPressed: onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        DynamicImageViewer(
                          image: menu.icon ?? "",
                        ),
                        SizedBox(width: 10.0.w),
                        Expanded(
                          child: Text(
                            menu.name ?? '',
                            maxLines: 2,
                            style: TextStyle(fontSize: 12.r,color: Branding.colors.primaryLight),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
