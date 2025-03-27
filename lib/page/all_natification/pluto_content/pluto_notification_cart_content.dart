import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoNotificationCartContent extends StatelessWidget {
  const PlutoNotificationCartContent({super.key, required this.data,});

  final NotificationModelData? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Branding.colors.primaryLight.withOpacity(0.5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: CachedNetworkImage(height: 50.h, width: 50.w, fit: BoxFit.cover,
                  imageUrl: data?.image ?? "assets/images/placeholder_image.png",
                  placeholder: (context, url) => Center(child: Image.asset("assets/images/placeholder_image.png"),),
                  errorWidget: (context, url, error) => Image.asset("assets/images/placeholder_image.png"),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data?.title ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.r),),
                  const SizedBox(height: 5,),
                  Html(data: data?.body),
                  const SizedBox(height: 5,),
                  if(data?.date != null)
                    Text(
                      '${getDDMMYYYYAsString(date: data!.date!,inputFormat: 'yyyy-mm-dd',outputFormat: 'dd-mm-yyyy')}',
                      style: TextStyle(color: Colors.black54, fontSize: 10.r),
                    )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
