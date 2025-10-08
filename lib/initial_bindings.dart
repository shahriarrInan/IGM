import 'package:igm/pages/company_list/controllers/company_pagel_controller.dart';
import 'package:igm/pages/home/controllers/home_controller.dart';
import 'package:igm/pages/import_bl/controllers/import_bl_controller.dart';
import 'package:igm/pages/mlo_list/controllers/mlo_page_controller.dart';
import 'package:refreshed/refreshed.dart';

class InitialBindings extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ImportBLController>(() => ImportBLController(), fenix: true),
      Bind.lazyPut<CompanyListController>(() => CompanyListController(), fenix: true),
      Bind.lazyPut<HomeController>(() => HomeController(), fenix: true),
      Bind.lazyPut<MLOListController>(() => MLOListController(), fenix: true),
      // Bind.put(() => VenturesController(), permanent: true),
    ];
  }
}
