import 'package:flutter/material.dart';

import 'responsive/settings_page_phone.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return const SettingsPagePhone();
  }
}
