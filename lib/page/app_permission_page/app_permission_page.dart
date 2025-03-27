import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation/view/bottom_navigation_page.dart';

class AppPermissionPage extends StatefulWidget {
  const AppPermissionPage({super.key});

  @override
  State<AppPermissionPage> createState() => _AppPermissionPageState();

  static Route route(){
    return MaterialPageRoute(builder: (_) => const AppPermissionPage());
  }

}

class _AppPermissionPageState extends State<AppPermissionPage> {
  
  @override
  void initState() {
    SharedUtil.setBoolValue(isDisclosure, true);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Branding.colors.primaryLight.withOpacity(0.7), Branding.colors.primaryLight])),
        child: ListView(
          children: [
            const SizedBox(height: 32.0),
            const Text('This App collects location data to enable below features even when the app is closed or not in use',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
            const SizedBox(height: 32.0,),
            const ListTile(
              leading: Icon(Icons.add_location, color: Colors.white, size: 30.0,),
              title: Text('1.Location data to enable  employee attendance and visit feature',
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            const ListTile(leading: Icon(Icons.local_gas_station_sharp, color: Colors.white, size: 30.0),
              title: Text('2.Find distance between employee and office position for accurate daily attendance',
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              leading: Icon(Icons.local_gas_station_sharp, color: Colors.white, size: 30.0,),
              title: Text('3.Allows the employer to track employee, when his/her employee is on the way to field job',
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              leading: Icon(
                Icons.local_gas_station_sharp, color: Colors.white, size: 30.0,),
              title: Text('4.Increase the efficiency and smoothness of the attendance',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              title: Text('You can change this later in the settings app',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final navigator = instance<GlobalKey<NavigatorState>>().currentState!;
                navigator.pushAndRemoveUntil(BottomNavigationPage.route(), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: Text(tr("next"),
                  style: TextStyle(color: Branding.colors.primaryLight, fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}
