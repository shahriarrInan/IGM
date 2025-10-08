import 'package:igm/pages/company_list/bindings/company_page_binding.dart';
import 'package:igm/pages/home/bindings/home_binding.dart';
import 'package:igm/pages/home/views/home.dart';
import 'package:igm/pages/import_bl/bindings/import_bl_binding.dart';
import 'package:igm/pages/company_list/views/company_page.dart';
import 'package:igm/pages/import_bl/views/import_bl.dart';
import 'package:igm/pages/mlo_list/bindings/mlo_page_binding.dart';
import 'package:igm/pages/mlo_list/views/mlo_page.dart';
import 'package:refreshed/get_navigation/src/routes/get_route.dart';

import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME_PAGE;

  static final routes = [
    GetPage(
      name: Routes.IMPORT_BL,
      page: () => ImportBL(),
      binding: ImportBlBinding(),
    ),
    GetPage(
      name: Routes.MLO_PAGE,
      page: () => MLOPage(),
      binding: MLOPageBinding(),
    ),
    GetPage(
      name: Routes.COMPANY_PAGE,
      page: () => CompanyPage(),
      binding: CompanyPageBinding(),
    ),
    GetPage(
      name: Routes.HOME_PAGE,
      page: () => Home(),
      binding: HomeBinding(),
    ),
  ];
}