import 'package:refreshed/refreshed.dart';

class CompanyListController extends GetxController {

  List<String> companyNames = ["NOBLE SHIPPING LINE", "MMG SHIPPING LINES LTD.", "MMG SEAWAYS LTD.", "MM SEAWAYS LTD."];
  RxInt selectedCompanyNameIndex = 0.obs;

  set sCIndex(int i) => selectedCompanyNameIndex.value = i;

}