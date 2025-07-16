import 'package:igm/pages/import_bl/controllers/import_bl_controller.dart';
import 'package:refreshed/refreshed.dart';

class ImportBlBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(() => ImportBLController(), permanent: true)];
  }

}