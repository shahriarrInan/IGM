import 'package:flutter/material.dart';
import 'package:igm/routes/app_pages.dart';
import 'package:refreshed/get_navigation/get_navigation.dart';

import 'initial_bindings.dart';

void main() {
  runApp(GetMaterialApp(
    // home: AboutUs(),
    initialRoute: AppPages.INITIAL,
    binds: InitialBindings().dependencies(),
    getPages: AppPages.routes,
    debugShowCheckedModeBanner: false,
  ));
}
