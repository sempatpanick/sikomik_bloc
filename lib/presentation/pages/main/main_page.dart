import 'package:flutter/material.dart';

import 'responsives/main_page_phone.dart';

class MainPage extends StatelessWidget {
  static const String routeName = "/";

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MainPagePhone();
  }
}
