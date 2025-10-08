import 'package:refreshed/refreshed.dart';

class MLOListController extends GetxController {

  List<String> MLONames = ["KING CHARTERING AND PROJECT", "LOTUS CONTAINER SHIPPING SERVICES LLC"],
               MLOCodes = ["KCP", "LCS"];
  RxInt selectedCompanyNameIndex = 0.obs;

  set sCIndex(int i) => selectedCompanyNameIndex.value = i;

}