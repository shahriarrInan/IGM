import 'package:igm/pages/company_list/controllers/company_pagel_controller.dart';
import 'package:refreshed/refreshed.dart';

class CompanyPageBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(() => CompanyListController(), permanent: true)];
  }

}