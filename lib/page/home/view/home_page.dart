import 'package:flutter/material.dart';
import 'package:onesthrm/page/belletin/view/view_with_bulletin.dart';
import 'package:onesthrm/page/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return ViewWithBulletin(child: const HomeContent());
  }
}
