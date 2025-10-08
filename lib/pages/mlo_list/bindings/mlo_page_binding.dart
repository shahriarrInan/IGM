import 'package:refreshed/refreshed.dart';

import '../controllers/mlo_page_controller.dart';

class MLOPageBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(() => MLOListController(), permanent: true)];
  }

}